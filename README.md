<p align="center">
  <img src="https://raw.githubusercontent.com/saadlech/Kurgate/main/assets/images/logo_full.png" alt="Kurgate Logo" width="280"/>
</p>

<h1 align="center">Kurgate</h1>

<p align="center">
  <strong>🇲🇦 Votre Portail Touristique Intelligent pour Marrakech</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11+-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase" alt="Supabase"/>
  <img src="https://img.shields.io/badge/Hive-Local%20Storage-orange?logo=hive" alt="Hive"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-orange" alt="Platform"/>
  <img src="https://img.shields.io/badge/License-Private-red" alt="License"/>
</p>

---

## 📖 À Propos

**Kurgate** est une application mobile de tourisme intelligente conçue comme Projet de Fin d'Études (PFE). Elle offre une expérience complète de découverte et de réservation touristique à Marrakech, avec une interface premium sombre et des interactions fluides..

L'application permet aux utilisateurs d'explorer des hôtels, louer des véhicules, découvrir des expériences locales, trouver des restaurants authentiques et acheter des produits artisanaux — le tout depuis une interface unifiée et élégante.

---

## ✨ Fonctionnalités

### 🔐 Authentification
- Inscription avec vérification par email (Supabase Auth)
- Connexion sécurisée avec gestion d'erreurs contextuelle
- Réinitialisation de mot de passe par email
- **Remember Me** — Persistance des identifiants via Hive (stockage local sécurisé)
- **Auto-login** — Reconnexion automatique au lancement si Remember Me est activé
- Gestion de session persistante

### 🏠 Écran d'Accueil
- **Hub centralisé** avec 5 sections de contenu (Hôtels, Véhicules, Expériences, Restaurants, Boutiques)
- **Recherche globale** — Recherche en temps réel à travers toutes les catégories
- **Navigation rapide** — Badge Marrakech → écran destinations, Avatar → profil
- Carrousel horizontal par catégorie avec images locales haute qualité
- Bannière AI Travel Assistant
- Catégories interactives avec navigation directe

### 🏨 Hôtels
- Catalogue de 6 hôtels premium de Marrakech (Royal Mansour, La Mamounia, La Sultana, Mandarin Oriental, Riad Kniza, Riad Yasmine)
- Galerie photo swipeable (6 images par hôtel)
- Système de réservation avec sélection de dates et nombre de personnes
- Fiches détaillées avec descriptions, équipements et avis

### 🚗 Location de Véhicules
- 6 véhicules réels populaires au Maroc (Dacia Duster, Renault Clio 5, Mercedes Classe E, Toyota Hilux, Peugeot 3008, Citroën Berlingo)
- Galerie de 4 photos par véhicule (extérieur, intérieur, arrière, action)
- Réservation avec options chauffeur et assurance
- Filtrage par catégorie (SUV, Citadine, Berline, Utilitaire)

### 🎯 Expériences
- Activités locales : Safari désert, randonnée Atlas, cours de cuisine, vol en montgolfière
- Galerie de 3 photos par expérience
- Filtrage par catégorie (Aventure, Culture, Nature, Gastronomie)
- Détails : durée, capacité, prix par personne

### 🍽️ Restaurants
- Sélection de 6 restaurants authentiques de Marrakech (Le Jardin, Nomad, Al Fassia, Cafe Clock, La Table du Palais, Chez Lamine)
- Fiches avec spécialités, horaires et localisations
- Filtrage par catégorie (Marocain, International, Rooftop, Street Food)
- Système de notation et avis

### 🏺 Boutiques Artisanales
- 6 boutiques artisanales (Tapis Berbères, Céramique Safi, Maroquinerie, Bijoux Touareg, Tissages Amazigh, Poterie Tamegroute)
- Galerie de 3 photos par boutique
- Catalogue produits avec prix et descriptions
- Navigation par catégorie (Tapis, Poterie, Cuir, Bijoux, Textile)

### 📅 Réservations & Panier
- Système de réservation centralisé (hôtels, véhicules, expériences, restaurants)
- Panier pour les produits artisanaux
- Onglets dédiés dans la navigation principale

### 👤 Profil
- Affichage des informations utilisateur (nom, email, téléphone)
- Déconnexion sécurisée avec effacement des données locales

---

## 🛠️ Stack Technique

| Composant | Technologie |
|-----------|------------|
| **Framework** | Flutter 3.11+ |
| **Langage** | Dart 3.11+ |
| **State Management** | Riverpod (flutter_riverpod) |
| **Navigation** | GoRouter (go_router) |
| **Backend** | Supabase (Auth + Database) |
| **Stockage Local** | Hive (hive_flutter) |
| **Typographie** | Darker Grotesque (custom font) |
| **Design System** | Dark theme, accent orange `#FF8C00` |

---

## 📁 Architecture du Projet

```
kurgate/
├── lib/
│   ├── main.dart                    # Point d'entrée (init Hive + Supabase)
│   ├── models/                      # Modèles de données
│   │   ├── utilisateur.dart         # Modèle utilisateur
│   │   ├── hotel.dart               # Modèle hôtel
│   │   ├── vehicule.dart            # Modèle véhicule
│   │   ├── experience.dart          # Modèle expérience
│   │   ├── restaurant.dart          # Modèle restaurant
│   │   ├── boutique_artisanale.dart # Modèle boutique
│   │   ├── destination.dart         # Modèle destination
│   │   ├── reservation.dart         # Modèle réservation
│   │   ├── offre_touristique.dart   # Modèle offre touristique
│   │   ├── produit.dart             # Modèle produit artisanal
│   │   └── ...
│   ├── providers/                   # State management (Riverpod)
│   │   ├── auth_provider.dart       # Auth, login, signup, remember me, auto-login
│   │   ├── booking_provider.dart    # Gestion des réservations
│   │   ├── cart_provider.dart       # Panier artisanal
│   │   └── ...
│   ├── services/
│   │   └── local_storage_service.dart # Stockage Hive (credentials, remember me)
│   ├── router/
│   │   └── app_router.dart          # Configuration GoRouter (18 routes)
│   ├── screens/                     # Écrans de l'application
│   │   ├── splash_screen.dart       # Splash animé + auto-login
│   │   ├── onboarding_screen.dart   # Onboarding (3 pages)
│   │   ├── login_screen.dart        # Connexion + Remember Me
│   │   ├── signup_screen.dart       # Inscription
│   │   ├── forgot_password_screen.dart
│   │   ├── destination_screen.dart  # Sélection de ville
│   │   ├── main_shell.dart          # Shell avec bottom navigation (5 onglets)
│   │   ├── home_screen.dart         # Hub principal avec recherche + 5 sections
│   │   ├── hotel_list_screen.dart   # Liste des hôtels
│   │   ├── hotel_detail_screen.dart # Détail hôtel + réservation
│   │   ├── vehicule_list_screen.dart
│   │   ├── vehicule_detail_screen.dart
│   │   ├── experience_list_screen.dart
│   │   ├── experience_detail_screen.dart
│   │   ├── restaurant_list_screen.dart
│   │   ├── restaurant_detail_screen.dart
│   │   ├── boutique_list_screen.dart
│   │   ├── boutique_detail_screen.dart
│   │   ├── bookings_screen.dart     # Mes réservations
│   │   ├── cart_screen.dart         # Panier artisanal
│   │   └── profile_screen.dart      # Profil utilisateur
│   └── widgets/                     # Composants réutilisables
│       ├── kurgate_button.dart      # Bouton animé personnalisé
│       ├── kurgate_loading_overlay.dart
│       └── auth_error_snackbar.dart
├── assets/
│   ├── fonts/                       # Darker Grotesque (7 weights)
│   └── images/
│       ├── hotels/                  # 6 hôtels × 6 photos
│       │   ├── la_mamounia/
│       │   ├── royal_mansour/
│       │   ├── riad_yasmine/
│       │   ├── la_sultana/
│       │   ├── mandarin_oriental/
│       │   └── riad_kniza/
│       ├── vehicules/               # 6 véhicules × 4 photos
│       │   ├── dacia_duster/
│       │   ├── renault_clio/
│       │   ├── mercedes_classe_e/
│       │   ├── toyota_hilux/
│       │   ├── peugeot_3008/
│       │   └── citroen_berlingo/
│       ├── experiences/             # 6 expériences × 3 photos
│       │   ├── safari_agafay/
│       │   ├── medina_visite/
│       │   ├── randonnee_atlas/
│       │   ├── cours_cuisine/
│       │   ├── vol_montgolfiere/
│       │   └── jardin_majorelle/
│       ├── restaurants/             # 6 restaurants × 3 photos
│       │   ├── le_jardin/
│       │   ├── nomad/
│       │   ├── al_fassia/
│       │   ├── cafe_clock/
│       │   ├── la_table_du_palais/
│       │   └── chez_lamine/
│       └── boutiques/               # 6 boutiques × 3 photos
│           ├── tapis_berberes/
│           ├── ceramique_safi/
│           ├── maroquinerie_youssef/
│           ├── bijoux_touareg/
│           ├── tissages_amazigh/
│           └── poterie_tamegroute/
└── pubspec.yaml
```

---

## 🚀 Installation & Lancement

### Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.11
- [Dart SDK](https://dart.dev/get-dart) ≥ 3.11
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
| 🟢 **Vert succès** | `#4ADE80` | Confirmations, succès |
| 🔴 **Rouge erreur** | `#FF5252` | Erreurs, déconnexion |
| ⬛ **Noir profond** | `#1A1A1A` | Fond principal |
| ⬛ **Gris foncé** | `#2A2A2A` | Cartes, conteneurs |

### Typographie

La police **Darker Grotesque** est utilisée en 7 graisses (300–900) pour créer une hiérarchie visuelle claire et moderne.

### Principes UI/UX

- **Dark Mode exclusif** — Interface sombre haut de gamme
- **Animations fluides** — Transitions de page, entrées d'éléments, micro-interactions
- **Glassmorphism** — Effets de transparence sur les cartes et overlays
- **Responsive** — Adapté à toutes les tailles d'écrans mobiles
- **Orbes animés** — Effets lumineux subtils en arrière-plan

---

## 🗄️ Backend & Stockage

### Supabase (Cloud)

- **Authentication** — Email/password avec vérification, reset password
- **Database (PostgreSQL)** — Table `utilisateurs` pour les profils
- **Row Level Security** — Sécurité au niveau des lignes

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
    ├── [Remember Me ON] → Auto-login → Home Screen
    └── [Remember Me OFF] → Onboarding → Login/Signup
                                              │
                                    Destination Screen (Marrakech)
                                              │
                                         Home Screen
                                    ┌────┬────┬────┬────┐
                                    │    │    │    │    │
                                  Home Bookings Map Cart Profile
                                    │
                    ┌────────┬──────┬──────┬──────┬──────┐
                  Hotels  Vehicles Experiences Restaurants Boutiques
                    │        │         │          │         │
                  Detail   Detail    Detail     Detail   Detail
                    │        │         │          │
                 Booking  Booking   Booking    Booking
```

---

## 📱 Captures d'Écran

| Splash | Onboarding | Login |
|--------|-----------|-------|
| Écran animé avec logo | 3 pages de découverte | Connexion avec Remember Me |

| Accueil | Recherche | Destinations |
|---------|-----------|-------------|
| Hub avec 5 sections | Recherche globale temps réel | Sélection de ville |

| Hôtels | Détail Hôtel | Véhicules |
|--------|-------------|-----------|
| Liste avec filtres | Galerie 6 photos + Réservation | 6 voitures réelles |

| Expériences | Restaurants | Boutiques |
|-------------|-------------|-----------|
| Activités filtrables | 6 adresses authentiques | Artisanat marocain |

---

## 📦 Dépendances Principales

```yaml
dependencies:
  flutter_riverpod: ^2.6.1    # State management
  go_router: ^14.8.1           # Navigation déclarative
  supabase_flutter: ^2.8.4     # Backend Supabase
  hive: ^2.2.3                 # Stockage local
  hive_flutter: ^1.1.0         # Hive Flutter bindings
```

---

## 👥 Auteur

**Saadeddine Lechgar**

Projet de Fin d'Études (PFE) — 2026

---

## 📄 License

Ce projet est privé et développé dans le cadre d'un PFE universitaire. Tous droits réservés.
