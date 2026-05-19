<p align="center">
  <img src="https://raw.githubusercontent.com/saadlech/Kurgate/main/assets/images/logo_full.png" alt="Kurgate Logo" width="280"/>
</p>

<h1 align="center">Kurgate</h1>

<p align="center">
  <strong>🇲🇦 Votre Portail Touristique Intelligent au Maroc</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.41+-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.7+-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase" alt="Supabase"/>
  <img src="https://img.shields.io/badge/Hive-Local%20Storage-orange?logo=hive" alt="Hive"/>
  <img src="https://img.shields.io/badge/Riverpod-State%20Mgmt-purple" alt="Riverpod"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-orange" alt="Platform"/>
  <img src="https://img.shields.io/badge/License-Private-red" alt="License"/>
</p>

---

## 📖 À Propos

**Kurgate** est une application mobile de tourisme intelligente conçue comme Projet de Fin d'Études (PFE). Elle offre une expérience complète de découverte et de réservation touristique au Maroc, avec une interface premium sombre et des interactions fluides.

L'application couvre **deux villes** — **Marrakech** et **Casablanca** — et permet aux utilisateurs d'explorer des hôtels, louer des véhicules, découvrir des expériences locales, trouver des restaurants authentiques et acheter des produits artisanaux — le tout depuis une interface unifiée et élégante.

---

## ✨ Fonctionnalités

### 🔐 Authentification
- Inscription avec vérification par email (Supabase Auth)
- Connexion sécurisée avec gestion d'erreurs contextuelle
- Réinitialisation de mot de passe par email
- **Remember Me** — Persistance des identifiants via Hive (stockage local sécurisé)
- **Auto-login** — Reconnexion automatique au lancement si Remember Me est activé
- **Suppression de compte** — Suppression irréversible avec confirmation par saisie
- **Modification du profil** — Mise à jour nom, email et téléphone

### 🌍 Multi-Destinations
- **Marrakech** — Catalogue complet (hôtels, véhicules, expériences, restaurants, boutiques)
- **Casablanca** — Catalogue complet (hôtels, expériences, restaurants, boutiques)
- Sélection de ville via un écran dédié avec cartes visuelles
- Données et assets séparés par destination

### 🏠 Écran d'Accueil
- **Hub centralisé** avec 5 sections de contenu (Hôtels, Véhicules, Expériences, Restaurants, Boutiques)
- **Recherche globale** — Recherche en temps réel à travers toutes les catégories
- **Navigation rapide** — Badge ville → écran destinations, Avatar → profil
- Carrousel horizontal par catégorie avec images locales haute qualité
- Catégories interactives avec navigation directe

### 🏨 Hôtels
- 6 hôtels premium par ville (Royal Mansour, La Mamounia, La Sultana, Mandarin Oriental…)
- Galerie photo swipeable (6 images par hôtel)
- Système de réservation avec sélection de dates et nombre de personnes
- Fiches détaillées avec descriptions, équipements, types de chambres et avis

### 🚗 Location de Véhicules
- 6 véhicules réels populaires au Maroc (Dacia Duster, Renault Clio 5, Mercedes Classe E…)
- Réservation avec options chauffeur et assurance complète
- Adresse de livraison personnalisable
- Filtrage par catégorie (SUV, Citadine, Berline, Utilitaire)

### 🎯 Expériences
- Activités locales : Safari désert, randonnée Atlas, cours de cuisine, vol en montgolfière…
- Filtrage par catégorie (Aventure, Culture, Nature, Gastronomie)
- Détails : durée, capacité, prix par personne

### 🍽️ Restaurants
- Sélection de restaurants authentiques par ville
- Fiches avec spécialités, horaires et localisation
- Filtrage par catégorie (Marocain, International, Rooftop, Street Food)
- Système de notation et avis utilisateurs

### 🏺 Boutiques Artisanales
- Boutiques artisanales (Tapis Berbères, Céramique Safi, Maroquinerie, Bijoux Touareg…)
- Catalogue produits avec prix et descriptions
- **Système de panier** — Ajout au panier avec gestion des quantités

### 📅 Réservations & Paiement
- Système de réservation centralisé (hôtels, véhicules, expériences, restaurants)
- **Panier** pour les produits artisanaux avec **persistance Supabase** (`commandes`)
- **Écran de paiement** avec confirmation et feedback
- Historique des réservations avec statuts (En attente, Payée, Annulée)
- **Synchronisation cloud** — Réservations, paiements et avis sauvegardés dans PostgreSQL

### 🗺️ Carte Interactive
- Carte OpenStreetMap avec points d'intérêt par destination
- Filtrage des POI par catégorie
- Navigation vers les lieux

### ⭐ Avis & Notes
- Système d'avis intégré sur tous les écrans de détail
- Notes 1-5 étoiles avec commentaires
- Prévention des avis doubles par utilisateur
- **Persistance cloud** — Avis sauvegardés dans la table `avis` via Supabase

### 🔧 Performance
- **Cache images optimisé** — `cacheWidth`/`cacheHeight` sur tous les `Image.asset` (400px listes, 500px détails)
- **Limite cache globale** — 50 MB / 30 images max
- **Recyclage mémoire** — `addAutomaticKeepAlives: false` sur les ListViews

---

## 🛠️ Stack Technique

| Composant | Technologie |
|-----------|------------|
| **Framework** | Flutter 3.41 |
| **Langage** | Dart 3.7 |
| **State Management** | Riverpod (`flutter_riverpod`) |
| **Navigation** | GoRouter (`go_router`) |
| **Backend** | Supabase (Auth + PostgreSQL) |
| **Stockage Local** | Hive (`hive_flutter`) |
| **Cartographie** | flutter_map + latlong2 (OpenStreetMap) |
| **Typographie** | Darker Grotesque (7 weights) |
| **Design System** | Dark theme, accent orange `#FF8C00` |

---

## 📁 Architecture du Projet

```
kurgate/
├── lib/
│   ├── main.dart                    # Point d'entrée (init Hive + Supabase + cache)
│   ├── models/                      # 16 modèles de données
│   │   ├── offre_touristique.dart   # Classe de base (id, name, price, rating…)
│   │   ├── hotel.dart               # extends OffreTouristique + stars, imageAssets
│   │   ├── restaurant.dart          # extends OffreTouristique + specialite, capacite
│   │   ├── experience.dart          # extends OffreTouristique + duree, capacite
│   │   ├── boutique_artisanale.dart # extends OffreTouristique + artisan, products
│   │   ├── location_voiture.dart    # extends OffreTouristique + type carburant/transmission
│   │   ├── vehicule.dart            # Classe autonome (agence, transmission, places…)
│   │   ├── destination.dart         # Modèle destination (Marrakech, Casablanca)
│   │   ├── utilisateur.dart         # Modèle utilisateur + modifierProfil()
│   │   ├── reservation.dart         # Modèle réservation + payer(), annuler()
│   │   ├── avis.dart                # Modèle avis (note, commentaire)
│   │   ├── produit.dart             # Modèle produit artisanal
│   │   ├── commande.dart            # Modèle commande
│   │   ├── chambre.dart             # Modèle chambre d'hôtel
│   │   ├── attraction.dart          # Modèle point d'intérêt
│   │   └── chatbot.dart             # Modèle chatbot (réservé)
│   ├── providers/                   # 8 providers Riverpod
│   │   ├── auth_provider.dart       # AuthNotifier (login, signup, delete, update)
│   │   ├── booking_provider.dart    # ReservationNotifier (add, cancel, pay, feedback → Supabase)
│   │   ├── cart_provider.dart       # CartNotifier (add, remove, checkout → Supabase commandes)
│   │   ├── review_provider.dart     # ReviewNotifier (add, average, check → Supabase avis)
│   │   ├── catalog_providers.dart   # FutureProviders for all catalog entities (Supabase)
│   │   ├── destination_provider.dart # FutureProvider → Supabase with static fallback
│   │   └── onboarding_provider.dart # hasSeenOnboarding, splashComplete
│   ├── services/
│   │   ├── supabase_service.dart     # Centralized Supabase data operations (14 methods)
│   │   └── local_storage_service.dart # Hive (credentials, remember me)
│   ├── router/
│   │   └── app_router.dart          # GoRouter (20 routes avec transitions)
│   ├── screens/                     # 24 écrans
│   │   ├── splash_screen.dart       # Splash animé + auto-login
│   │   ├── onboarding_screen.dart   # Onboarding (3 pages)
│   │   ├── login_screen.dart        # Connexion + Remember Me
│   │   ├── signup_screen.dart       # Inscription
│   │   ├── forgot_password_screen.dart
│   │   ├── destination_screen.dart  # Sélection de ville (Marrakech/Casablanca)
│   │   ├── main_shell.dart          # Shell avec bottom navigation (5 onglets)
│   │   ├── home_screen.dart         # Hub principal + recherche + 5 sections
│   │   ├── map_screen.dart          # Carte interactive OpenStreetMap
│   │   ├── hotel_list_screen.dart   # Liste hôtels (import Hotel)
│   │   ├── hotel_detail_screen.dart # Détail hôtel + réservation
│   │   ├── vehicule_list_screen.dart    # Liste véhicules (import Vehicule)
│   │   ├── vehicule_detail_screen.dart  # Détail véhicule + réservation
│   │   ├── experience_list_screen.dart  # Liste expériences (import Experience)
│   │   ├── experience_detail_screen.dart
│   │   ├── restaurant_list_screen.dart  # Liste restaurants (import Restaurant)
│   │   ├── restaurant_detail_screen.dart
│   │   ├── boutique_list_screen.dart    # Liste boutiques (import BoutiqueArtisanale)
│   │   ├── boutique_detail_screen.dart
│   │   ├── bookings_screen.dart     # Mes réservations
│   │   ├── cart_screen.dart         # Panier artisanal
│   │   ├── payment_screen.dart      # Paiement + feedback
│   │   ├── profile_screen.dart      # Profil + déconnexion + suppression
│   │   └── edit_profile_screen.dart # Modification profil
│   └── widgets/                     # 6 composants réutilisables
│       ├── kurgate_button.dart      # Bouton animé personnalisé
│       ├── kurgate_loading_overlay.dart
│       ├── optimized_image.dart     # Image avec cache optimisé
│       ├── reviews_section.dart     # Section avis intégrée
│       ├── feedback_sheet.dart      # Bottom sheet de feedback
│       └── auth_error_snackbar.dart
├── assets/
│   ├── fonts/                       # Darker Grotesque (7 weights)
│   └── images/
│       ├── hotels/                  # Marrakech — 6 hôtels × 6 photos
│       ├── vehicules/               # 6 véhicules × 4 photos
│       ├── experiences/             # Marrakech — 6 expériences × 6 photos
│       ├── restaurants/             # Marrakech — 6 restaurants × 6 photos
│       ├── boutiques/               # Marrakech — 6 boutiques × 6 photos
│       └── casablanca/              # Casablanca
│           ├── hotels/              # 6 hôtels × 6 photos
│           ├── experiences/         # 4 expériences × 6 photos
│           ├── restaurants/         # 6 restaurants × 6 photos
│           └── boutiques/           # 6 boutiques × 6 photos
├── docs/
│   └── class_diagram.puml           # Diagramme de classes PlantUML
└── pubspec.yaml
```

---

## 🏛️ Diagramme de Classes

Le diagramme de classes complet est disponible en PlantUML : [`docs/class_diagram.puml`](docs/class_diagram.puml)

### Hiérarchie des modèles

```
OffreTouristique (classe de base)
├── Hotel            (stars, imageAssets)
├── Restaurant       (specialite, capacite, horaires)
├── Experience       (duree, capacite)
├── LocationVoiture  (typeVehicule, typeCarburant, nbPlaces)
└── BoutiqueArtisanale (artisan, prixMoyen, products → Produit)

Vehicule             (autonome — agence, transmission, carburant, places)
Utilisateur          (modifierProfil, toMap, fromMap)
Reservation          (payer, annuler, copyWith)
Avis                 (note, commentaire, datePublication)
Destination          (cities: Marrakech, Casablanca)
Commande, Chambre, Attraction, ChatBot
```

---

## 🚀 Installation & Lancement

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.41
- [Dart SDK](https://dart.dev/get-dart) ≥ 3.7
- Android Studio / VS Code avec extensions Flutter
- Un appareil Android/iOS ou un émulateur

### Étapes

```bash
# 1. Cloner le projet
git clone https://github.com/saadlech/Kurgate.git
cd kurgate

# 2. Installer les dépendances
flutter pub get

# 3. Vérifier la configuration
flutter doctor

# 4. Lancer l'application
flutter run
```

### Commandes utiles

```bash
# Analyse statique du code
flutter analyze

# Lancer les tests
flutter test

# Build APK de production
flutter build apk --release

# Build pour iOS
flutter build ios --release
```

---

## 🎨 Design System

### Palette de couleurs

| Couleur | Hex | Utilisation |
|---------|-----|-------------|
| 🟠 **Orange** | `#FF8C00` | Accent principal, CTA, étoiles |
| 🟡 **Orange clair** | `#FCA91C` | Accent secondaire |
| 🟠 **Orange foncé** | `#E77728` | Accent tertiaire |
| 🟢 **Vert succès** | `#4ADE80` / `#2ECC71` | Confirmations, succès |
| 🔴 **Rouge erreur** | `#FF5252` | Erreurs, déconnexion, suppression |
| ⬛ **Noir profond** | `#1A1A1A` | Fond principal |
| ⬛ **Gris foncé** | `#2A2A2A` / `#222222` | Cartes, conteneurs, modals |

### Typographie

La police **Darker Grotesque** est utilisée en 7 graisses (300–900) pour créer une hiérarchie visuelle claire et moderne.

### Principes UI/UX

- **Dark Mode exclusif** — Interface sombre haut de gamme
- **Animations fluides** — Transitions de page (slide, fade), micro-interactions
- **Glassmorphism** — Effets de transparence sur les cartes et overlays
- **Responsive** — Adapté à toutes les tailles d'écrans mobiles
- **Orbes animés** — Effets lumineux subtils en arrière-plan
- **Performance** — Images optimisées en mémoire (`cacheWidth` / `cacheHeight`)

---

## 🗄️ Backend & Stockage

### Supabase (Cloud) — 100% Connecté

L'application est **entièrement synchronisée** avec Supabase. Toutes les opérations de lecture et d'écriture passent par le cloud.

| Table | Opérations | RLS |
|-------|-----------|-----|
| `destinations` | SELECT | ✅ Public read |
| `hotels` | SELECT (list + by ID) | ✅ Public read |
| `restaurants` | SELECT (list + by ID) | ✅ Public read |
| `experiences` | SELECT (list + by ID) | ✅ Public read |
| `boutiques_artisanales` | SELECT (list + by ID) | ✅ Public read |
| `vehicules` | SELECT (list + by ID) | ✅ Public read |
| `utilisateurs` | SELECT, INSERT, UPDATE, DELETE | ✅ Own user only |
| `reservations` | SELECT, INSERT, UPDATE (status + feedback) | ✅ Own user only |
| `avis` | SELECT, INSERT | ✅ Public read, own insert |
| `commandes` | SELECT, INSERT, UPDATE | ✅ Own user only |

- **Authentication** — Email/password avec vérification, reset password
- **Row Level Security** — Sécurité au niveau des lignes sur toutes les tables
- **RPC** — Fonction `delete_user()` pour suppression de compte
- **Offline-First** — Fallback local si Supabase est indisponible

### Architecture de Synchronisation

```
┌──────────────┐     FutureProvider      ┌──────────────────┐
│  UI Screens  │ ◄──────────────────────► │  SupabaseService │
│  (Riverpod)  │                         │  (14 methods)    │
└──────────────┘                         └────────┬─────────┘
       │                                          │
       │  Fire-and-forget                          ▼
       │  (mutations)                    ┌──────────────────┐
       └────────────────────────────────►│  Supabase Cloud  │
                                         │  PostgreSQL + RLS│
                                         └──────────────────┘
```

- **Lecture** : `FutureProvider` → `SupabaseService.fetch*()` → UI
- **Écriture** : UI → local state update → fire-and-forget Supabase sync
- **Résultat** : UI jamais bloquée par le réseau

### Hive (Local)

- **Remember Me** — Persistance sécurisée des identifiants
- **Auto-login** — Reconnexion automatique via les credentials stockés
- **Préférences** — Flag remember me (boolean)

### Configuration Supabase

L'URL et la clé anonyme sont configurées dans `lib/main.dart`. Pour un déploiement en production, utilisez des variables d'environnement.

---

## 🔄 Flux Utilisateur

```
Splash Screen (animation + auto-login check)
    ├── [Remember Me ON] → Auto-login → Destination → Home
    └── [Remember Me OFF] → Onboarding → Login/Signup
                                              │
                                    Destination Screen
                                    (Marrakech / Casablanca)
                                              │
                                         Home Screen
                                    ┌────┬────┬────┬────┐
                                    │    │    │    │    │
                                  Home  Map Bookings Cart Profile
                                    │                       │
                    ┌────────┬──────┬──────┬──────┬──────┐  Edit Profile
                  Hotels  Vehicles Exp.  Restos Boutiques   Delete Account
                    │        │       │      │       │
                  Detail   Detail  Detail Detail  Detail
                    │        │       │      │       │
                 Booking  Booking Booking Booking  Cart
                    │        │       │      │
                 Payment  Payment Payment Payment
```

---

## 📦 Dépendances Principales

```yaml
dependencies:
  flutter_riverpod: ^2.6.1    # State management
  go_router: ^14.8.1           # Navigation déclarative
  supabase_flutter: ^2.12.4    # Backend Supabase
  hive: ^2.2.3                 # Stockage local
  hive_flutter: ^1.1.0         # Hive Flutter bindings
  flutter_map: ^8.3.0          # Carte interactive
  latlong2: ^0.9.1             # Coordonnées géographiques
  url_launcher: ^6.3.2         # Liens externes
  google_fonts: ^6.2.1         # Polices Google
```

---

## 📱 Captures d'Écran

| Splash | Onboarding | Login |
|--------|-----------|-------|
| Écran animé avec logo | 3 pages de découverte | Connexion avec Remember Me |

| Accueil | Carte | Destinations |
|---------|-------|-------------|
| Hub avec 5 sections | Carte OpenStreetMap | Marrakech / Casablanca |

| Hôtels | Détail Hôtel | Véhicules |
|--------|-------------|-----------| 
| Liste avec filtres | Galerie + Réservation | 6 voitures réelles |

| Expériences | Restaurants | Boutiques |
|-------------|-------------|-----------|
| Activités filtrables | Adresses authentiques | Artisanat marocain |

| Réservations | Panier | Profil |
|-------------|--------|--------|
| Historique + statuts | Produits artisanaux | Info + suppression |

---

## 👥 Auteur

**Saadeddine Lechgar**

Projet de Fin d'Études (PFE) — 2026

---

## 📄 License

Ce projet est privé et développé dans le cadre d'un PFE universitaire. Tous droits réservés.
