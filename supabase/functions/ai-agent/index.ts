// Supabase Edge Function: ai-agent
// Kurgate AI travel assistant with Azure OpenAI function calling + direct Supabase DB access.
// Memory is client-side: Flutter sends conversation history with every request.
//
// Deploy: npx supabase functions deploy ai-agent --no-verify-jwt --project-ref aurxykjqywoaiezwkvff

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ── Config ─────────────────────────────────────────────────────────────────
const AZURE_ENDPOINT  = "https://kurgate-ai-resource.services.ai.azure.com";
const AZURE_DEPLOY    = "o4-mini";
const AZURE_API_VER   = "2024-12-01-preview";
const AZURE_KEY       = Deno.env.get("AZURE_OPENAI_KEY") ??
  "5YS78po4VoIwyHaPLF9givztdnzfNnGEVKrDQ9mjUO2yBUcGlffSJQQJ99CEACfhMk5XJ3w3AAAAACOGZju5";

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

PROCESSUS RÉSERVATION (SUIVRE EXACTEMENT):
A) L'utilisateur demande à réserver → cherche avec search_* pour obtenir les données réelles + l'ID exact.
B) S'il manque des infos (dates/personnes) → demande uniquement ce qui manque.
C) Quand tu as: nom, dates, nb_personnes → affiche ce récapitulatif:
   "✅ Récapitulatif:
   • [Nom] — [type]
   • Du [date_debut] au [date_fin] ([X] nuits/jours)
   • [nb] personne(s) — Total: [prix × durée] MAD
   Confirmez? (oui/non)"
D) Quand l'utilisateur dit OUI/oui/confirmer/ok:
   → Appelle search_* pour récupérer l'item_id exact depuis la DB
   → Appelle immédiatement create_booking avec toutes les infos
   → Ne pose AUCUNE question — tu as déjà tout
   → Annonce: "🎉 Réservation [id] créée avec succès!"

Prix en MAD. Réponds en français avec emojis. Max 200 mots. Si l'utilisateur parle arabe/darija → réponds pareil.`;

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
];

// ── Tool execution ────────────────────────────────────────────────────────────
async function runTool(name: string, args: Record<string, unknown>): Promise<string> {
  // Use anon key for reads (bypasses service role key problem), service role for writes
  const isWrite = name === "create_booking" || name === "get_bookings";
  const db = createClient(SB_URL, isWrite ? SB_SVC : SB_ANON);

  switch (name) {
    case "search_hotels": {
      const id = destId(args.city as string);
      if (!id) return JSON.stringify({ error: `Ville inconnue: ${args.city}. Utilise: marrakech, casablanca, agadir, tangier` });
      const { data, error } = await db.from("hotels")
        .select("id, name, location, price, rating, reviews, stars, category, description")
        .eq("destination_id", id).order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ city: args.city, count: data?.length ?? 0, hotels: data ?? [] });
    }

    case "search_restaurants": {
      const id = destId(args.city as string);
      if (!id) return JSON.stringify({ error: `Ville inconnue: ${args.city}` });
      const { data, error } = await db.from("restaurants")
        .select("id, name, location, price, rating, reviews, specialite, category, description")
        .eq("destination_id", id).order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ city: args.city, count: data?.length ?? 0, restaurants: data ?? [] });
    }

    case "search_experiences": {
      const id = destId(args.city as string);
      if (!id) return JSON.stringify({ error: `Ville inconnue: ${args.city}` });
      const { data, error } = await db.from("experiences")
        .select("id, name, location, price, rating, reviews, duree, capacite, category, description")
        .eq("destination_id", id).order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ city: args.city, count: data?.length ?? 0, experiences: data ?? [] });
    }

    case "search_vehicles": {
      const { data, error } = await db.from("vehicules")
        .select("id, name, price, rating, reviews, transmission, carburant, places, category, description")
        .order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ count: data?.length ?? 0, vehicles: data ?? [] });
    }

    case "search_boutiques": {
      const { data, error } = await db.from("boutiques_artisanales")
        .select("id, name, artisan, prix_moyen, rating, reviews, category, description, tags")
        .order("rating", { ascending: false });
      if (error) return JSON.stringify({ error: error.message });
      return JSON.stringify({ count: data?.length ?? 0, boutiques: data ?? [] });
    }

    case "create_booking": {
      const missing = ["item_id","type_offre","nom","nb_personnes","date_debut","date_fin","prix_total"]
        .filter(k => !args[k]);
      if (missing.length) return JSON.stringify({ error: `Champs manquants: ${missing.join(", ")}` });

      const { data, error } = await db.from("reservations").insert({
        item_id:      args.item_id,
        type_offre:   args.type_offre,
        nom:          args.nom,
        sous_titre:   (args.sous_titre as string) ?? "",
        image_url:    (args.image_url as string) ?? "",
        nb_personnes: Number(args.nb_personnes),
        date_debut:   args.date_debut,
        date_fin:     args.date_fin,
        prix_total:   Number(args.prix_total),
        statut:       "En attente",
        details:      {},
        user_id:      (args.user_id as string) ?? null,
      }).select("id, nom, type_offre, prix_total, statut").single();

      if (error) return JSON.stringify({ error: error.message });
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

    default:
      return JSON.stringify({ error: `Outil inconnu: ${name}` });
  }
}

// ── Azure OpenAI call ─────────────────────────────────────────────────────────
async function callLLM(messages: unknown[], withTools = true) {
  const url = `${AZURE_ENDPOINT}/openai/deployments/${AZURE_DEPLOY}/chat/completions?api-version=${AZURE_API_VER}`;
  const body: Record<string, unknown> = { messages, max_completion_tokens: 1000 };
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
    const { question, history = [], sessionId, userId } = await req.json();
    if (!question) return new Response(
      JSON.stringify({ error: "Missing 'question'" }),
      { status: 400, headers: { ...CORS, "Content-Type": "application/json" } }
    );

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

    for (let i = 0; i < 5; i++) {
      const result = await callLLM([...messages, ...toolMessages]);
      assistantMsg = result.choices?.[0]?.message;
      if (!assistantMsg?.tool_calls?.length) break;

      // Add assistant message + execute all tool calls in parallel
      toolMessages.push({ role: "assistant", content: assistantMsg.content ?? "", tool_calls: assistantMsg.tool_calls });

      await Promise.all(
        assistantMsg.tool_calls.map(async (tc) => {
          const args = JSON.parse(tc.function.arguments) as Record<string, unknown>;
          if (userId && (tc.function.name === "create_booking" || tc.function.name === "get_bookings")) {
            args.user_id ??= userId;
          }
          const result = await runTool(tc.function.name, args);
          toolMessages.push({ role: "tool", content: result, tool_call_id: tc.id, name: tc.function.name });
        })
      );
    }

    const text = assistantMsg?.content ?? "Désolé, je n'ai pas pu traiter votre demande.";
    return new Response(
      JSON.stringify({ text, sessionId: sessionId ?? `s_${Date.now()}` }),
      { headers: { ...CORS, "Content-Type": "application/json" } }
    );
  } catch (e) {
    return new Response(
      JSON.stringify({ error: (e as Error).message }),
      { status: 500, headers: { ...CORS, "Content-Type": "application/json" } }
    );
  }
});
