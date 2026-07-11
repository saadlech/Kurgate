// Supabase Edge Function: ai-agent
// Kurgate AI travel assistant with Azure OpenAI function calling + direct Supabase DB access.
// Memory is client-side: Flutter sends conversation history with every request.
//
// Deploy: npx supabase functions deploy ai-agent --no-verify-jwt --project-ref aurxykjqywoaiezwkvff

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ── Config ─────────────────────────────────────────────────────────────────
const AZURE_ENDPOINT  = "https://kurgate-resource.services.ai.azure.com";
const AZURE_DEPLOY    = "o4-mini";
const AZURE_API_VER   = "2024-12-01-preview";
const AZURE_KEY       = Deno.env.get("AZURE_OPENAI_KEY") ??
  "DVZ7LZr7y0PyHieaAuNdyuKs0m92iwxX4xYvrW2zMvOdttWzowGhJQQJ99CFACHYHv6XJ3w3AAAAACOGQwpL";

// Supabase — anon key works for all reads (RLS allows public access to catalog tables)
// Service role is auto-injected by Supabase runtime for write operations
const SB_URL  = Deno.env.get("SUPABASE_URL") ??
  "https://aurxykjqywoaiezwkvff.supabase.co";
const SB_ANON = "sb_publishable_VwBR1xse_Z2Zgs4b0kjYhA_w54eXJP8";
const SB_SVC  = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? SB_ANON; // fallback to anon for reads

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// ── City → destination_id ───────────────────────────────────────────────────
const CITIES: Record<string, string> = {
  marrakech: "dest_001",
  casablanca: "dest_002",
  agadir:     "dest_003",
  tangier:    "dest_004",
  tanger:     "dest_004",
};
const destId = (city: string) => CITIES[city.toLowerCase().trim()] ?? "";

// ── System prompt ────────────────────────────────────────────────────────────
const SYSTEM = `Tu es l'agent Kurgate, assistant de tourisme au Maroc.

RÈGLES ABSOLUES:
1. Pour toute question sur hôtels/restaurants/expériences/véhicules/boutiques → appelle TOUJOURS l'outil correspondant. Ne jamais inventer.
2. Villes disponibles: marrakech, casablanca, agadir, tangier.

DEMANDES MULTI-CATÉGORIES (TRÈS IMPORTANT):
Quand l'utilisateur demande PLUSIEURS choses dans un seul message (ex: "je veux un hôtel + restaurant + voiture + expérience"):
1. Appelle TOUS les outils de recherche correspondants EN PARALLÈLE (search_hotels + search_restaurants + search_vehicles + search_experiences en même temps).
2. Présente les résultats de CHAQUE catégorie séparément avec des titres clairs (🏨 Hôtels, 🍽️ Restaurants, 🚗 Véhicules, 🎭 Expériences).
3. Si l'utilisateur demande AUSSI de réserver un item spécifique (ex: "réserve-moi l'hôtel"), fais d'abord TOUTES les recherches, puis propose le récapitulatif de réservation pour l'item demandé.
Ne JAMAIS ignorer une catégorie demandée. Si l'utilisateur mentionne 4 besoins, tu dois chercher les 4.

PLANIFICATION DE VOYAGE:
Quand l'utilisateur demande un plan/itinéraire de voyage (ex: "planifie un voyage de 4 jours"):
1. Choisis 1 à 3 villes selon la durée du voyage et le budget.
2. Appelle search_hotels, search_restaurants, search_experiences pour chaque ville choisie.
3. Compose un itinéraire jour par jour avec:
   - 🏨 Hébergement (prix/nuit)
   - 🍽️ Restaurant(s) recommandé(s)
   - 🎯 Activités/expériences
   - 💰 Budget estimé pour la journée
4. Termine par un récapitulatif total du budget.
5. Propose de réserver les éléments que l'utilisateur souhaite.
IMPORTANT: Appelle PLUSIEURS outils en parallèle pour accélérer la recherche (ex: search_hotels + search_restaurants + search_experiences simultanément pour une même ville).

PROCESSUS RÉSERVATION (SUIVRE EXACTEMENT):
A) L'utilisateur demande à réserver ou fait référence à un établissement -> Identifie l'item (hôtel, restaurant, etc.) actuellement affiché ou discuté dans les derniers messages. S'il est présent, utilise ses détails (ID, nom, ville, prix) directement sans appeler search_*. N'appelle search_* que si aucun item n'est identifié dans l'historique récent.
B) S'il manque des infos (comme les dates/heures ou le nombre de personnes) -> Demande UNIQUEMENT les informations manquantes. Ne redemande jamais la ville ou le nom de l'établissement s'ils sont déjà connus ou déduits de l'historique.
C) Quand tu as toutes les infos (nom, dates/heures, nb_personnes) -> Affiche ce récapitulatif:
   "✅ Récapitulatif:
   • [Nom] — [type]
   • Date/Heure: [date_debut/heure]
   • [nb] personne(s) — Total: [prix_total] MAD
   Confirmez? (oui/non)"
D) Quand l'utilisateur dit OUI/oui/confirmer/ok:
   -> Appelle immédiatement create_booking avec toutes les infos. Ne pose aucune question et annonce le succès.

Prix en MAD. LANGUE: Détecte la langue du PREMIER message de l'utilisateur et réponds TOUJOURS dans cette même langue pour toute la conversation. Exemples: si l'utilisateur écrit en anglais → réponds en anglais, en français → en français, en arabe/darija → en arabe/darija, en espagnol → en espagnol, etc. Utilise des emojis dans toutes les langues.

CAPACITÉS COMPLÈTES (tu peux faire TOUT ce qu'un utilisateur fait dans l'app):
- Rechercher: hôtels, restaurants, expériences, véhicules, boutiques, attractions, produits artisanaux
- Voir les détails complets d'un item avec get_item_details
- Réservations: créer, consulter, annuler, payer, supprimer
- Panier: ajouter des produits, consulter le panier, finaliser l'achat (checkout)
- Avis: laisser une note (1-5) et un commentaire sur n'importe quel item

RÈGLES STRICTES:
- Ne prétends JAMAIS envoyer des emails, SMS ou notifications. Tu n'as pas cette capacité.
- Ne dis JAMAIS que tu as fait quelque chose sans avoir appelé l'outil correspondant.
- Pour annuler des réservations, utilise TOUJOURS cancel_booking ou cancel_all_bookings.
- Pour payer une réservation, utilise pay_booking.
- Après une action, confirme simplement que c'est fait, sans inventer de suivi.
`;

// ── Tool schemas ─────────────────────────────────────────────────────────────
const TOOLS = [
  {
    type: "function",
    function: {
      name: "search_hotels",
      description: "Rechercher des hôtels dans une ville marocaine. Appeler OBLIGATOIREMENT avant de parler d'hôtels.",
      parameters: {
        type: "object",
        properties: { city: { type: "string", description: "marrakech | casablanca | agadir | tangier" } },
        required: ["city"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "search_restaurants",
      description: "Rechercher des restaurants dans une ville marocaine.",
      parameters: {
        type: "object",
        properties: { city: { type: "string", description: "marrakech | casablanca | agadir | tangier" } },
        required: ["city"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "search_experiences",
      description: "Rechercher des expériences et activités touristiques dans une ville.",
      parameters: {
        type: "object",
        properties: { city: { type: "string", description: "marrakech | casablanca | agadir | tangier" } },
        required: ["city"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "search_vehicles",
      description: "Rechercher des véhicules disponibles à la location.",
      parameters: { type: "object", properties: {}, required: [] },
    },
  },
  {
    type: "function",
    function: {
      name: "search_boutiques",
      description: "Rechercher des boutiques artisanales marocaines.",
      parameters: { type: "object", properties: {}, required: [] },
    },
  },
  {
    type: "function",
    function: {
      name: "create_booking",
      description: "Créer une réservation. Appeler UNIQUEMENT après confirmation explicite (oui) de l'utilisateur.",
      parameters: {
        type: "object",
        properties: {
          item_id:      { type: "string", description: "ID exact de l'offre depuis la DB" },
          type_offre:   { type: "string", description: "hotel | restaurant | experience | vehicule | boutique" },
          nom:          { type: "string", description: "Nom complet de l'offre" },
          nb_personnes: { type: "number", description: "Nombre de personnes" },
          date_debut:   { type: "string", description: "Date début YYYY-MM-DD" },
          date_fin:     { type: "string", description: "Date fin YYYY-MM-DD" },
          prix_total:   { type: "number", description: "Prix total en MAD" },
          user_id:      { type: "string", description: "ID utilisateur (optionnel)" },
        },
        required: ["item_id", "type_offre", "nom", "nb_personnes", "date_debut", "date_fin", "prix_total"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "get_bookings",
      description: "Consulter les réservations d'un utilisateur.",
      parameters: {
        type: "object",
        properties: { user_id: { type: "string", description: "ID de l'utilisateur" } },
        required: ["user_id"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "cancel_booking",
      description: "Annuler une réservation spécifique par son ID. Change le statut en 'Annulée'.",
      parameters: {
        type: "object",
        properties: {
          booking_id: { type: "string", description: "ID de la réservation à annuler" },
          user_id:    { type: "string", description: "ID de l'utilisateur" },
        },
        required: ["booking_id"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "cancel_all_bookings",
      description: "Annuler TOUTES les réservations en attente d'un utilisateur.",
      parameters: {
        type: "object",
        properties: {
          user_id: { type: "string", description: "ID de l'utilisateur" },
        },
        required: ["user_id"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "pay_booking",
      description: "Payer/confirmer une réservation. Change le statut en 'Payée'.",
      parameters: {
        type: "object",
        properties: {
          booking_id: { type: "string", description: "ID de la réservation à payer" },
        },
        required: ["booking_id"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "delete_booking",
      description: "Supprimer définitivement une réservation de la base de données.",
      parameters: {
        type: "object",
        properties: {
          booking_id: { type: "string", description: "ID de la réservation à supprimer" },
        },
        required: ["booking_id"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "add_review",
      description: "Laisser un avis/note sur un hôtel, restaurant, expérience, etc.",
      parameters: {
        type: "object",
        properties: {
          item_id:     { type: "string", description: "ID de l'item (hotel_001, resto_001, etc.)" },
          note:        { type: "number", description: "Note de 1 à 5 étoiles" },
          commentaire: { type: "string", description: "Commentaire de l'utilisateur" },
          user_id:     { type: "string", description: "ID utilisateur" },
          user_name:   { type: "string", description: "Nom de l'utilisateur pour l'affichage" },
        },
        required: ["item_id", "note", "commentaire"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "search_attractions",
      description: "Rechercher des attractions touristiques dans une ville.",
      parameters: {
        type: "object",
        properties: { city: { type: "string", description: "marrakech | casablanca | agadir | tangier" } },
        required: ["city"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "search_products",
      description: "Rechercher des produits artisanaux disponibles dans les boutiques.",
      parameters: {
        type: "object",
        properties: {
          boutique_id: { type: "string", description: "ID de la boutique (optionnel, cherche dans toutes si absent)" },
        },
        required: [],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "add_to_cart",
      description: "Ajouter un produit artisanal au panier de l'utilisateur.",
      parameters: {
        type: "object",
        properties: {
          boutique_name:  { type: "string", description: "Nom de la boutique" },
          artisan:        { type: "string", description: "Nom de l'artisan" },
          product_name:   { type: "string", description: "Nom du produit" },
          product_desc:   { type: "string", description: "Description du produit" },
          image_url:      { type: "string", description: "URL image du produit" },
          unit_price:     { type: "number", description: "Prix unitaire en MAD" },
          quantity:        { type: "number", description: "Quantité à ajouter" },
          user_id:        { type: "string", description: "ID utilisateur" },
        },
        required: ["boutique_name", "product_name", "unit_price", "quantity"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "get_cart",
      description: "Consulter le contenu du panier (commandes) de l'utilisateur.",
      parameters: {
        type: "object",
        properties: { user_id: { type: "string", description: "ID de l'utilisateur" } },
        required: ["user_id"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "checkout_cart",
      description: "Finaliser l'achat de tous les articles du panier. Crée les commandes en DB.",
      parameters: {
        type: "object",
        properties: {
          items: { type: "array", description: "Liste des produits à commander", items: {
            type: "object",
            properties: {
              boutique_name: { type: "string" },
              product_name:  { type: "string" },
              unit_price:    { type: "number" },
              quantity:      { type: "number" },
            },
          }},
          address:  { type: "string", description: "Adresse de livraison (optionnel)" },
          user_id:  { type: "string", description: "ID utilisateur" },
        },
        required: ["items"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "get_item_details",
      description: "Obtenir les détails complets d'un item spécifique (hôtel, restaurant, expérience, véhicule, boutique).",
      parameters: {
        type: "object",
        properties: {
          item_id:    { type: "string", description: "ID de l'item" },
          item_type:  { type: "string", description: "hotel | restaurant | experience | vehicule | boutique" },
        },
        required: ["item_id", "item_type"],
      },
    },
  },
];

// ── Tool execution ────────────────────────────────────────────────────────────
async function runTool(name: string, args: Record<string, unknown>): Promise<string> {
  // Use anon key for reads (bypasses service role key problem), service role for writes
  const isWrite = ["create_booking", "get_bookings", "cancel_booking", "cancel_all_bookings",
    "pay_booking", "delete_booking", "add_review", "add_to_cart", "get_cart", "checkout_cart"].includes(name);
  const db = createClient(SB_URL, isWrite ? SB_SVC : SB_ANON);

  switch (name) {
    case "search_hotels": {
      const id = destId(args.city as string);
      if (!id) return JSON.stringify({ error: `Ville inconnue: ${args.city}. Utilise: marrakech, casablanca, agadir, tangier` });
      const { data, error } = await db.from("hotels")
        .select("id, name, location, price, rating, reviews, stars, category, description, image_url")
        .eq("destination_id", id).order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ city: args.city, count: data?.length ?? 0, hotels: data ?? [], _type: "hotel" });
    }

    case "search_restaurants": {
      const id = destId(args.city as string);
      if (!id) return JSON.stringify({ error: `Ville inconnue: ${args.city}` });
      const { data, error } = await db.from("restaurants")
        .select("id, name, location, price, rating, reviews, specialite, category, description, image_url")
        .eq("destination_id", id).order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ city: args.city, count: data?.length ?? 0, restaurants: data ?? [], _type: "restaurant" });
    }

    case "search_experiences": {
      const id = destId(args.city as string);
      if (!id) return JSON.stringify({ error: `Ville inconnue: ${args.city}` });
      const { data, error } = await db.from("experiences")
        .select("id, name, location, price, rating, reviews, duree, capacite, category, description, image_url")
        .eq("destination_id", id).order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ city: args.city, count: data?.length ?? 0, experiences: data ?? [], _type: "experience" });
    }

    case "search_vehicles": {
      const { data, error } = await db.from("vehicules")
        .select("id, name, price, rating, reviews, transmission, carburant, places, category, description, image_url")
        .order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ count: data?.length ?? 0, vehicles: data ?? [], _type: "vehicule" });
    }

    case "search_boutiques": {
      const { data, error } = await db.from("boutiques_artisanales")
        .select("id, name, artisan, prix_moyen, rating, reviews, category, description, tags, image_url")
        .order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ count: data?.length ?? 0, boutiques: data ?? [], _type: "boutique" });
    }

    case "create_booking": {
      const missing = ["item_id","type_offre","nom","nb_personnes","date_debut","date_fin","prix_total"]
        .filter(k => !args[k]);
      if (missing.length) return JSON.stringify({ error: `Champs manquants: ${missing.join(", ")}` });

      console.log("[create_booking] args:", JSON.stringify(args));

      // ── Look up the source item to get image + location ──
      const readDb = createClient(SB_URL, SB_ANON); // anon is fine for reads
      const tableMap: Record<string, string> = {
        hotel: "hotels", restaurant: "restaurants",
        experience: "experiences", vehicule: "vehicules",
        boutique: "boutiques_artisanales",
      };
      const table = tableMap[(args.type_offre as string)] ?? "";
      // Tables that have a 'location' column
      const tablesWithLocation = ["hotels", "restaurants", "experiences"];
      let itemImage = "";
      let itemLocation = "";
      if (table) {
        const cols = tablesWithLocation.includes(table) ? "image_url, location" : "image_url";
        const { data: item } = await readDb.from(table)
          .select(cols)
          .eq("id", args.item_id)
          .maybeSingle();
        if (item) {
          itemImage = item.image_url ?? "";
          itemLocation = item.location ?? "";
        }
      }

      // ── Compute nights + build details ──
      const d1 = new Date(args.date_debut as string);
      const d2 = new Date(args.date_fin as string);
      const nights = Math.max(1, Math.round((d2.getTime() - d1.getTime()) / 86400000));
      const fmtDate = (d: Date) =>
        `${String(d.getDate()).padStart(2, "0")}/${String(d.getMonth() + 1).padStart(2, "0")}/${d.getFullYear()}`;

      const details: Record<string, string> = {
        "Arrivée": fmtDate(d1),
        "Départ": fmtDate(d2),
        "Nuits": String(nights),
        "Personnes": `${args.nb_personnes} personne(s)`,
      };

      const sousTitre = itemLocation
        ? `${itemLocation} · Standard`
        : (args.sous_titre as string) ?? "";

      const payload = {
        id:           crypto.randomUUID(),
        item_id:      args.item_id,
        type_offre:   args.type_offre,
        nom:          args.nom,
        sous_titre:   sousTitre,
        image_url:    itemImage || ((args.image_url as string) ?? ""),
        nb_personnes: Number(args.nb_personnes),
        date_debut:   args.date_debut,
        date_fin:     args.date_fin,
        prix_total:   Number(args.prix_total),
        statut:       "En attente",
        details,
        user_id:      typeof args.user_id === "string" && /^[0-9a-f-]{36}$/i.test(args.user_id) ? args.user_id : null,
      };
      console.log("[create_booking] payload:", JSON.stringify(payload));

      const { data, error } = await db.from("reservations")
        .insert(payload)
        .select("id, item_id, type_offre, nom, sous_titre, image_url, nb_personnes, date_debut, date_fin, prix_total, statut, details")
        .single();

      if (error) {
        console.error("[create_booking] DB error:", JSON.stringify({
          message: error.message, code: error.code,
          details: error.details, hint: error.hint,
        }));
        return JSON.stringify({
          error: error.message, code: error.code,
          hint: error.hint ?? "Vérifiez les RLS policies ou le service_role_key",
        });
      }
      console.log("[create_booking] success:", JSON.stringify(data));
      return JSON.stringify({ success: true, booking: data });
    }

    case "get_bookings": {
      if (!args.user_id) return JSON.stringify({ bookings: [], message: "user_id requis" });
      const { data, error } = await db.from("reservations")
        .select("id, type_offre, nom, nb_personnes, date_debut, date_fin, prix_total, statut")
        .eq("user_id", args.user_id).order("created_at", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ count: data?.length ?? 0, bookings: data ?? [] });
    }

    case "cancel_booking": {
      if (!args.booking_id) return JSON.stringify({ error: "booking_id requis" });
      console.log("[cancel_booking] id:", args.booking_id);
      const { data, error } = await db.from("reservations")
        .update({ statut: "Annulée" })
        .eq("id", args.booking_id)
        .select("id, nom, statut")
        .single();
      if (error) {
        console.error("[cancel_booking] error:", error.message);
        return JSON.stringify({ error: error.message });
      }
      return JSON.stringify({ success: true, cancelled: data });
    }

    case "cancel_all_bookings": {
      if (!args.user_id) return JSON.stringify({ error: "user_id requis" });
      console.log("[cancel_all_bookings] user:", args.user_id);
      const { data, error } = await db.from("reservations")
        .update({ statut: "Annulée" })
        .eq("user_id", args.user_id)
        .eq("statut", "En attente")
        .select("id, nom");
      if (error) {
        console.error("[cancel_all_bookings] error:", error.message);
        return JSON.stringify({ error: error.message });
      }
      return JSON.stringify({ success: true, count: data?.length ?? 0, cancelled: data ?? [] });
    }

    case "pay_booking": {
      if (!args.booking_id) return JSON.stringify({ error: "booking_id requis" });
      console.log("[pay_booking] id:", args.booking_id);
      const { data, error } = await db.from("reservations")
        .update({ statut: "Payée" })
        .eq("id", args.booking_id)
        .select("id, nom, statut, prix_total")
        .single();
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ success: true, paid: data });
    }

    case "delete_booking": {
      if (!args.booking_id) return JSON.stringify({ error: "booking_id requis" });
      console.log("[delete_booking] id:", args.booking_id);
      const { error } = await db.from("reservations")
        .delete()
        .eq("id", args.booking_id);
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ success: true, deleted: args.booking_id });
    }

    case "add_review": {
      if (!args.item_id || !args.note || !args.commentaire) {
        return JSON.stringify({ error: "item_id, note et commentaire requis" });
      }
      console.log("[add_review] item:", args.item_id, "note:", args.note);
      const reviewPayload = {
        id: crypto.randomUUID(),
        item_id: args.item_id,
        user_id: typeof args.user_id === "string" && /^[0-9a-f-]{36}$/i.test(args.user_id) ? args.user_id : null,
        user_name: (args.user_name as string) ?? "Utilisateur Kurgate",
        note: Number(args.note),
        commentaire: args.commentaire,
        date_publication: new Date().toISOString(),
      };
      const { data: reviewData, error: reviewErr } = await db.from("avis")
        .insert(reviewPayload)
        .select("id, item_id, note, commentaire")
        .single();
      if (reviewErr) return JSON.stringify({ error: reviewErr.message });
      return JSON.stringify({ success: true, review: reviewData });
    }

    case "search_attractions": {
      const id = destId(args.city as string);
      if (!id) return JSON.stringify({ error: `Ville inconnue: ${args.city}` });
      const { data, error } = await db.from("attractions")
        .select("id, name, location, rating, reviews, category, description, image_url")
        .eq("destination_id", id).order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ city: args.city, count: data?.length ?? 0, attractions: data ?? [], _type: "attraction" });
    }

    case "search_products": {
      let query = db.from("produits_boutique")
        .select("id, boutique_id, nom, prix, description, stock, image_url");
      if (args.boutique_id) {
        query = query.eq("boutique_id", args.boutique_id);
      }
      const { data, error } = await query.order("prix", { ascending: true });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ count: data?.length ?? 0, products: data ?? [] });
    }

    case "add_to_cart": {
      // Cart is managed client-side in Flutter, so we create a commande record
      console.log("[add_to_cart]", args.product_name);
      const cartPayload = {
        boutique_name: args.boutique_name ?? "",
        artisan: args.artisan ?? "",
        product_name: args.product_name ?? "",
        product_desc: args.product_desc ?? "",
        image_url: args.image_url ?? "",
        unit_price: Number(args.unit_price),
        quantity: Number(args.quantity ?? 1),
        total_price: Number(args.unit_price) * Number(args.quantity ?? 1),
        statut: "Panier",
        user_id: typeof args.user_id === "string" && /^[0-9a-f-]{36}$/i.test(args.user_id) ? args.user_id : null,
      };
      const { data: cartData, error: cartErr } = await db.from("commandes")
        .insert(cartPayload)
        .select("id, product_name, quantity, total_price")
        .single();
      if (cartErr) return JSON.stringify({ error: cartErr.message });
      return JSON.stringify({ success: true, added: cartData });
    }

    case "get_cart": {
      if (!args.user_id) return JSON.stringify({ items: [], message: "user_id requis" });
      const { data, error } = await db.from("commandes")
        .select("id, boutique_name, product_name, unit_price, quantity, total_price, statut")
        .eq("user_id", args.user_id)
        .eq("statut", "Panier")
        .order("created_at", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      const total = (data ?? []).reduce((s: number, i: { total_price: number }) => s + (i.total_price ?? 0), 0);
      return JSON.stringify({ count: data?.length ?? 0, items: data ?? [], total_price: total });
    }

    case "checkout_cart": {
      const items = args.items as Array<Record<string, unknown>> ?? [];
      if (!items.length) return JSON.stringify({ error: "Panier vide" });
      console.log("[checkout_cart] items:", items.length);
      const results = [];
      for (const item of items) {
        const row = {
          boutique_name: item.boutique_name ?? "",
          product_name: item.product_name ?? "",
          unit_price: Number(item.unit_price ?? 0),
          quantity: Number(item.quantity ?? 1),
          total_price: Number(item.unit_price ?? 0) * Number(item.quantity ?? 1),
          statut: "Payée",
          address: (args.address as string) ?? "",
          user_id: typeof args.user_id === "string" && /^[0-9a-f-]{36}$/i.test(args.user_id) ? args.user_id : null,
        };
        const { data, error } = await db.from("commandes").insert(row).select("id, product_name").single();
        if (!error && data) results.push(data);
      }
      return JSON.stringify({ success: true, count: results.length, orders: results });
    }

    case "get_item_details": {
      if (!args.item_id || !args.item_type) {
        return JSON.stringify({ error: "item_id et item_type requis" });
      }
      const detailTableMap: Record<string, string> = {
        hotel: "hotels", restaurant: "restaurants",
        experience: "experiences", vehicule: "vehicules",
        boutique: "boutiques_artisanales",
      };
      const detailTable = detailTableMap[args.item_type as string];
      if (!detailTable) return JSON.stringify({ error: `Type inconnu: ${args.item_type}` });
      const { data: detail, error: detailErr } = await db.from(detailTable)
        .select("*")
        .eq("id", args.item_id)
        .maybeSingle();
      if (detailErr) return JSON.stringify({ error: detailErr.message });
      if (!detail) return JSON.stringify({ error: `Item non trouvé: ${args.item_id}` });
      return JSON.stringify({ item_type: args.item_type, item: detail });
    }

    default:
      return JSON.stringify({ error: `Outil inconnu: ${name}` });
  }
}

// ── Azure OpenAI call ─────────────────────────────────────────────────────────
async function callLLM(messages: unknown[], withTools = true) {
  const url = `${AZURE_ENDPOINT}/openai/deployments/${AZURE_DEPLOY}/chat/completions?api-version=${AZURE_API_VER}`;
  const body: Record<string, unknown> = { messages, max_completion_tokens: 16000 };
  if (withTools) { body.tools = TOOLS; body.tool_choice = "auto"; }

  const res = await fetch(url, {
    method: "POST",
    headers: { "api-key": AZURE_KEY, "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error(`Azure ${res.status}: ${await res.text()}`);
  return await res.json();
}

// ── Main handler ──────────────────────────────────────────────────────────────
serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });

  try {
    const body = await req.json();
    const { question, history = [], sessionId, userId, bookingId, statut, note, commentaire } = body;
    if (!question) return new Response(
      JSON.stringify({ error: "Missing 'question'" }),
      { status: 400, headers: { ...CORS, "Content-Type": "application/json" } }
    );

    // ── Direct booking test (bypasses LLM) ──
    if (question === "__test_booking") {
      const result = await runTool("create_booking", {
        item_id: "hotel_001",
        type_offre: "hotel",
        nom: "Test Hotel",
        nb_personnes: 1,
        date_debut: "2026-07-01",
        date_fin: "2026-07-02",
        prix_total: 100,
        user_id: userId ?? null,
      });
      return new Response(
        JSON.stringify({ test_result: JSON.parse(result), userId }),
        { headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // ── Fetch user bookings (service role, bypasses RLS) ──
    if (question === "__get_bookings") {
      if (!userId) {
        return new Response(
          JSON.stringify({ reservations: [], error: "userId required" }),
          { headers: { ...CORS, "Content-Type": "application/json" } }
        );
      }
      const svcDb = createClient(SB_URL, SB_SVC);
      const { data, error } = await svcDb.from("reservations")
        .select("*")
        .eq("user_id", userId)
        .neq("statut", "Supprimée")
        .order("created_at", { ascending: false });
      return new Response(
        JSON.stringify({ reservations: data ?? [], error: error?.message }),
        { headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // ── Delete a booking (service role, bypasses RLS) ──
    if (question === "__delete_booking") {
      if (!bookingId) {
        return new Response(
          JSON.stringify({ success: false, error: "bookingId required" }),
          { headers: { ...CORS, "Content-Type": "application/json" } }
        );
      }
      const svcDb = createClient(SB_URL, SB_SVC);
      const { error } = await svcDb.from("reservations")
        .delete()
        .eq("id", bookingId);
      return new Response(
        JSON.stringify({ success: !error, error: error?.message }),
        { headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // ── Update booking status (service role, bypasses RLS) ──
    if (question === "__update_booking") {
      if (!bookingId || !statut) {
        return new Response(
          JSON.stringify({ success: false, error: "bookingId and statut required" }),
          { headers: { ...CORS, "Content-Type": "application/json" } }
        );
      }
      const svcDb = createClient(SB_URL, SB_SVC);
      const updatePayload: Record<string, unknown> = { statut };
      if (note !== undefined) updatePayload.note = note;
      if (commentaire !== undefined) updatePayload.commentaire = commentaire;
      const { error } = await svcDb.from("reservations")
        .update(updatePayload)
        .eq("id", bookingId);
      return new Response(
        JSON.stringify({ success: !error, error: error?.message }),
        { headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // ── Save bank card (service role, bypasses RLS) ──
    if (question === "__save_card") {
      const { cardNumber, cardLast4, cardExpiry, cardHolder, cardBrand } = body;
      if (!userId || !cardNumber) {
        return new Response(
          JSON.stringify({ success: false, error: "userId and cardNumber required" }),
          { headers: { ...CORS, "Content-Type": "application/json" } }
        );
      }
      const svcDb = createClient(SB_URL, SB_SVC);
      // Upsert: insert or update if user already has a card
      const { data, error } = await svcDb.from("saved_cards")
        .upsert({
          user_id: userId,
          card_number: cardNumber,
          card_last4: cardLast4 ?? cardNumber.slice(-4),
          card_expiry: cardExpiry,
          card_holder: cardHolder,
          card_brand: cardBrand ?? null,
          updated_at: new Date().toISOString(),
        }, { onConflict: "user_id" })
        .select("id, card_last4, card_expiry, card_holder, card_brand")
        .single();
      console.log("[__save_card]", error ? `error: ${error.message}` : `saved for user ${userId}`);
      return new Response(
        JSON.stringify({ success: !error, card: data, error: error?.message }),
        { headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // ── Get saved card (service role, bypasses RLS) ──
    if (question === "__get_card") {
      if (!userId) {
        return new Response(
          JSON.stringify({ card: null, error: "userId required" }),
          { headers: { ...CORS, "Content-Type": "application/json" } }
        );
      }
      const svcDb = createClient(SB_URL, SB_SVC);
      const { data, error } = await svcDb.from("saved_cards")
        .select("card_number, card_last4, card_expiry, card_holder, card_brand")
        .eq("user_id", userId)
        .maybeSingle();
      return new Response(
        JSON.stringify({ card: data, error: error?.message }),
        { headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // ── Delete saved card (service role, bypasses RLS) ──
    if (question === "__delete_card") {
      if (!userId) {
        return new Response(
          JSON.stringify({ success: false, error: "userId required" }),
          { headers: { ...CORS, "Content-Type": "application/json" } }
        );
      }
      const svcDb = createClient(SB_URL, SB_SVC);
      const { error } = await svcDb.from("saved_cards")
        .delete()
        .eq("user_id", userId);
      console.log("[__delete_card]", error ? `error: ${error.message}` : `deleted for user ${userId}`);
      return new Response(
        JSON.stringify({ success: !error, error: error?.message }),
        { headers: { ...CORS, "Content-Type": "application/json" } }
      );
    }

    // Build context from Flutter history (last 16 msgs max to control tokens)
    const context = (history as Array<{ role: string; content: string }>)
      .slice(-16)
      .filter(m => m.role === "user" || m.role === "assistant");

    // Conversation for this turn: system + history + current question
    const messages: unknown[] = [
      { role: "developer", content: SYSTEM },
      ...context,
      { role: "user", content: question },
    ];

    // Agentic loop — max 5 tool-call iterations
    let assistantMsg: { content: string | null; tool_calls?: Array<{ id: string; function: { name: string; arguments: string } }> } | null = null;
    const toolMessages: unknown[] = [];

    for (let i = 0; i < 10; i++) {
      const result = await callLLM([...messages, ...toolMessages]);
      assistantMsg = result.choices?.[0]?.message;
      if (!assistantMsg?.tool_calls?.length) break;

      // Add assistant message + execute all tool calls in parallel
      toolMessages.push({ role: "assistant", content: assistantMsg.content ?? "", tool_calls: assistantMsg.tool_calls });

      await Promise.all(
        assistantMsg.tool_calls.map(async (tc) => {
          const args = JSON.parse(tc.function.arguments) as Record<string, unknown>;
          const needsUserId = ["create_booking", "get_bookings", "cancel_booking", "cancel_all_bookings",
            "pay_booking", "delete_booking", "add_review", "add_to_cart", "get_cart", "checkout_cart"].includes(tc.function.name);
          if (userId && needsUserId) {
            args.user_id ??= userId;
          }
          const result = await runTool(tc.function.name, args);
          toolMessages.push({ role: "tool", content: result, tool_call_id: tc.id, name: tc.function.name });
        })
      );
    }

    // If content is null/empty but we have tool results, force a final text response
    if ((!assistantMsg?.content) && toolMessages.length > 0) {
      console.log("[ai-agent] Content null after tool loop, forcing final text call");
      // Add the last assistant message (with tool_calls) to context if not already there
      if (assistantMsg?.tool_calls?.length) {
        toolMessages.push({ role: "assistant", content: assistantMsg.content ?? "", tool_calls: assistantMsg.tool_calls });
        // Execute any remaining tool calls
        await Promise.all(
          assistantMsg.tool_calls.map(async (tc) => {
            const args = JSON.parse(tc.function.arguments) as Record<string, unknown>;
            const needsUserId = ["create_booking", "get_bookings", "cancel_booking", "cancel_all_bookings",
              "pay_booking", "delete_booking", "add_review", "add_to_cart", "get_cart", "checkout_cart"].includes(tc.function.name);
            if (userId && needsUserId) {
              args.user_id ??= userId;
            }
            const result = await runTool(tc.function.name, args);
            toolMessages.push({ role: "tool", content: result, tool_call_id: tc.id, name: tc.function.name });
          })
        );
      }
      // Final call WITHOUT tools to force a text summary
      const finalResult = await callLLM([...messages, ...toolMessages], false);
      assistantMsg = finalResult.choices?.[0]?.message ?? assistantMsg;
    }

    // Extract raw tool results for debugging
    const toolDebug = toolMessages
      .filter((m: any) => m.role === "tool")
      .map((m: any) => ({ name: m.name, result: m.content }));

    // Extract structured items from tool results for rich card display
    const items: unknown[] = [];
    for (const tm of toolMessages.filter((m: any) => m.role === "tool")) {
      try {
        const parsed = JSON.parse((tm as any).content);
        const itemType = parsed._type ?? "";
        const list = parsed.hotels ?? parsed.restaurants ?? parsed.experiences
          ?? parsed.vehicles ?? parsed.boutiques ?? parsed.attractions ?? parsed.products ?? [];
        for (const item of list) {
          item._type = itemType;
        }
        items.push(...list);
      } catch { /* ignore non-JSON tool results */ }
    }

    const text = assistantMsg?.content ?? "Désolé, je n'ai pas pu traiter votre demande.";
    return new Response(
      JSON.stringify({ text, sessionId: sessionId ?? `s_${Date.now()}`, items: items.length > 0 ? items : undefined, _debug: toolDebug }),
      { headers: { ...CORS, "Content-Type": "application/json" } }
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: (e as Error).message }),
      { status: 500, headers: { ...CORS, "Content-Type": "application/json" } }
    );
  }
});
