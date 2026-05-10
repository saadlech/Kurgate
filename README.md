<p align="center">
  <img src="assets/images/logo_full.png" alt="Kurgate Logo" width="280"/>
</p>

<h1 align="center">Kurgate</h1>

<p align="center">
  <strong>🇲🇦 Votre Portail Touristique Intelligent pour Marrakech</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11+-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase" alt="Supabase"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-orange" alt="Platform"/>
  <img src="https://img.shields.io/badge/License-Private-red" alt="License"/>
</p>

---

## 📖 À Propos

**Kurgate** est une application mobile de tourisme intelligente conçue comme Projet de Fin d'Études (PFE). Elle offre une expérience complète de découverte et de réservation touristique à Marrakech, avec une interface premium sombre et des interactions fluides.

L'application permet aux utilisateurs d'explorer des hôtels, louer des véhicules, découvrir des expériences locales, trouver des restaurants authentiques et acheter des produits artisanaux — le tout depuis une interface unifiée et élégante.

---

## ✨ Fonctionnalités

### 🔐 Authentification
- Inscription avec vérification par email (Supabase Auth)
- Connexion sécurisée avec gestion d'erreurs contextuelle
- Réinitialisation de mot de passe par email
- Gestion de session persistante

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
- Filtrage par catégorie (Aventure, Culture, Nature, Gastronomie)
- Détails : durée, capacité, prix par personne

### 🍽️ Restaurants
- Sélection de restaurants authentiques de Marrakech
- Fiches avec menus, spécialités et localisations
- Système de notation et avis

### 🏺 Boutiques Artisanales
- Artisanat marocain : tapis, poteries, maroquinerie, bijoux
- Catalogue produits avec prix et descriptions
- Navigation par catégorie

---

## 🛠️ Stack Technique

| Composant | Technologie |
|-----------|------------|
| **Framework** | Flutter 3.11+ |
| **Langage** | Dart 3.11+ |
| **State Management** | Riverpod (flutter_riverpod) |
| **Navigation** | GoRouter (go_router) |
| **Backend** | Supabase (Auth + Database) |
| **Typographie** | Darker Grotesque (custom font) |
| **Design System** | Dark theme, accent orange `#FF8C00` |

---

## 📁 Architecture du Projet

```
kurgate/
├── lib/
│   ├── main.dart                    # Point d'entrée de l'application
│   ├── models/                      # Modèles de données
│   │   ├── utilisateur.dart         # Modèle utilisateur
│   │   ├── hotel.dart               # Modèle hôtel
│   │   ├── vehicule.dart            # Modèle véhicule
│   │   ├── experience.dart          # Modèle expérience
│   │   ├── restaurant.dart          # Modèle restaurant
│   │   ├── boutique_artisanale.dart # Modèle boutique
│   │   ├── destination.dart         # Modèle destination
│   │   ├── reservation.dart         # Modèle réservation
│   │   └── ...
│   ├── providers/                   # State management (Riverpod)
│   │   ├── auth_provider.dart       # Authentification & gestion utilisateur
│   │   ├── destination_provider.dart
│   │   └── onboarding_provider.dart
│   ├── router/
│   │   └── app_router.dart          # Configuration GoRouter
│   ├── screens/                     # Écrans de l'application
│   │   ├── splash_screen.dart       # Écran de démarrage animé
│   │   ├── onboarding_screen.dart   # Onboarding (3 pages)
│   │   ├── login_screen.dart        # Connexion
│   │   ├── signup_screen.dart       # Inscription
│   │   ├── forgot_password_screen.dart
│   │   ├── home_screen.dart         # Écran principal
│   │   ├── main_shell.dart          # Shell avec bottom navigation
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
│   │   └── destination_screen.dart
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
│       │   └── ...
│       └── vehicules/               # 6 véhicules × 4 photos
│           ├── dacia_duster/
│           ├── mercedes_classe_e/
│           └── ...
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
git clone https://github.com/your-username/kurgate.git
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

# Générer les icônes de l'application
dart run flutter_launcher_icons
```

---

## 🎨 Design System

### Palette de couleurs

| Couleur | Hex | Utilisation |
|---------|-----|-------------|
| 🟠 **Orange** | `#FF8C00` | Accent principal, CTA, étoiles |
| 🟡 **Orange clair** | `#FCA91C` | Accent secondaire |
| 🟠 **Orange foncé** | `#E77728` | Accent tertiaire |
| ⬛ **Noir profond** | `#1A1A1A` | Fond principal |
| ⬛ **Gris foncé** | `#2A2A2A` | Cartes, conteneurs |

### Typographie

La police **Darker Grotesque** est utilisée en 7 graisses (300–900) pour créer une hiérarchie visuelle claire et moderne.

### Principes UI/UX

- **Dark Mode exclusif** — Interface sombre haut de gamme
- **Animations fluides** — Transitions de page, entrées d'éléments, micro-interactions
- **Glassmorphism** — Effets de transparence sur les cartes et overlays
- **Responsive** — Adapté à toutes les tailles d'écrans mobiles

---

## 🗄️ Backend (Supabase)

Le backend utilise **Supabase** pour :

- **Authentication** — Email/password avec vérification, reset password
- **Database (PostgreSQL)** — Table `utilisateurs` pour les profils
- **Row Level Security** — Sécurité au niveau des lignes

### Configuration Supabase

L'URL et la clé anonyme sont configurées dans `lib/main.dart`. Pour un déploiement en production, utilisez des variables d'environnement.

---

## 📱 Captures d'Écran

| Splash | Onboarding | Login |
|--------|-----------|-------|
| Écran animé avec logo | 3 pages de découverte | Connexion avec animations |

| Accueil | Hôtels | Détail Hôtel |
|---------|--------|-------------|
| Dashboard principal | Liste avec filtres | Galerie + Réservation |

| Véhicules | Détail Véhicule | Expériences |
|-----------|----------------|-------------|
| 6 voitures réelles | Slider 4 images | Activités filtrables |

---

## 👥 Auteur

**Saadeddine Lechgar**

Projet de Fin d'Études (PFE) — 2026

---

## 📄 License

Ce projet est privé et développé dans le cadre d'un PFE universitaire. Tous droits réservés.
