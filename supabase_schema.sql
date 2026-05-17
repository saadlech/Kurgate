-- ============================================================
-- KURGATE DATABASE SCHEMA
-- Run this in Supabase SQL Editor (Dashboard > SQL Editor)
-- ============================================================

-- 1. DESTINATIONS
CREATE TABLE IF NOT EXISTS destinations (
  id TEXT PRIMARY KEY,
  nom TEXT NOT NULL,
  sous_titre TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  est_disponible BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. HOTELS
CREATE TABLE IF NOT EXISTS hotels (
  id TEXT PRIMARY KEY,
  destination_id TEXT REFERENCES destinations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  location TEXT DEFAULT '',
  price INT DEFAULT 0,
  rating FLOAT DEFAULT 0,
  reviews INT DEFAULT 0,
  image_url TEXT DEFAULT '',
  description TEXT DEFAULT '',
  tags TEXT[] DEFAULT '{}',
  category TEXT DEFAULT '',
  images TEXT[] DEFAULT '{}',
  stars INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. RESTAURANTS
CREATE TABLE IF NOT EXISTS restaurants (
  id TEXT PRIMARY KEY,
  destination_id TEXT REFERENCES destinations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  location TEXT DEFAULT '',
  price INT DEFAULT 0,
  rating FLOAT DEFAULT 0,
  reviews INT DEFAULT 0,
  image_url TEXT DEFAULT '',
  description TEXT DEFAULT '',
  tags TEXT[] DEFAULT '{}',
  category TEXT DEFAULT '',
  images TEXT[] DEFAULT '{}',
  specialite TEXT DEFAULT '',
  capacite INT DEFAULT 0,
  horaires TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 4. EXPERIENCES
CREATE TABLE IF NOT EXISTS experiences (
  id TEXT PRIMARY KEY,
  destination_id TEXT REFERENCES destinations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  location TEXT DEFAULT '',
  price INT DEFAULT 0,
  rating FLOAT DEFAULT 0,
  reviews INT DEFAULT 0,
  image_url TEXT DEFAULT '',
  description TEXT DEFAULT '',
  tags TEXT[] DEFAULT '{}',
  category TEXT DEFAULT '',
  images TEXT[] DEFAULT '{}',
  duree TEXT DEFAULT '',
  capacite INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 5. BOUTIQUES ARTISANALES
CREATE TABLE IF NOT EXISTS boutiques_artisanales (
  id TEXT PRIMARY KEY,
  destination_id TEXT REFERENCES destinations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  location TEXT DEFAULT '',
  price INT DEFAULT 0,
  rating FLOAT DEFAULT 0,
  reviews INT DEFAULT 0,
  image_url TEXT DEFAULT '',
  description TEXT DEFAULT '',
  tags TEXT[] DEFAULT '{}',
  category TEXT DEFAULT '',
  images TEXT[] DEFAULT '{}',
  artisan TEXT DEFAULT '',
  prix_moyen TEXT DEFAULT '',
  horaires TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 6. VEHICULES
CREATE TABLE IF NOT EXISTS vehicules (
  id TEXT PRIMARY KEY,
  destination_id TEXT REFERENCES destinations(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  agence TEXT DEFAULT '',
  price INT DEFAULT 0,
  rating FLOAT DEFAULT 0,
  reviews INT DEFAULT 0,
  image_url TEXT DEFAULT '',
  tags TEXT[] DEFAULT '{}',
  category TEXT DEFAULT '',
  transmission TEXT DEFAULT '',
  carburant TEXT DEFAULT '',
  places INT DEFAULT 0,
  description TEXT DEFAULT '',
  images TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 7. CHAMBRES (Hotel Rooms)
CREATE TABLE IF NOT EXISTS chambres (
  id TEXT PRIMARY KEY,
  hotel_id TEXT REFERENCES hotels(id) ON DELETE CASCADE,
  numero TEXT NOT NULL,
  type_chambre TEXT DEFAULT '',
  description TEXT DEFAULT '',
  capacite INT DEFAULT 0,
  prix_par_nuit INT DEFAULT 0,
  image_url TEXT DEFAULT '',
  est_disponible BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 8. PRODUITS (Boutique Products)
CREATE TABLE IF NOT EXISTS produits (
  id TEXT PRIMARY KEY,
  boutique_id TEXT REFERENCES boutiques_artisanales(id) ON DELETE CASCADE,
  nom TEXT NOT NULL,
  prix INT DEFAULT 0,
  description TEXT DEFAULT '',
  stock INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 9. ATTRACTIONS
CREATE TABLE IF NOT EXISTS attractions (
  id TEXT PRIMARY KEY,
  destination_id TEXT REFERENCES destinations(id) ON DELETE CASCADE,
  nom TEXT NOT NULL,
  type TEXT DEFAULT '',
  description TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  note FLOAT DEFAULT 0,
  location TEXT DEFAULT '',
  lat FLOAT DEFAULT 0,
  lon FLOAT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 10. RESERVATIONS
CREATE TABLE IF NOT EXISTS reservations (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  item_id TEXT DEFAULT '',
  type_offre TEXT DEFAULT '',
  nom TEXT DEFAULT '',
  sous_titre TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  nb_personnes INT DEFAULT 1,
  date_debut TIMESTAMPTZ NOT NULL,
  date_fin TIMESTAMPTZ NOT NULL,
  prix_total INT DEFAULT 0,
  details JSONB DEFAULT '{}',
  statut TEXT DEFAULT 'En attente',
  note INT,
  commentaire TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 11. AVIS (Reviews)
CREATE TABLE IF NOT EXISTS avis (
  id TEXT PRIMARY KEY,
  item_id TEXT DEFAULT '',
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  user_name TEXT DEFAULT '',
  note INT NOT NULL CHECK (note >= 1 AND note <= 5),
  commentaire TEXT DEFAULT '',
  date_publication TIMESTAMPTZ DEFAULT now()
);

-- 12. COMMANDES (Orders)
CREATE TABLE IF NOT EXISTS commandes (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  date_commande TIMESTAMPTZ DEFAULT now(),
  montant_total FLOAT DEFAULT 0,
  statut TEXT DEFAULT 'En attente',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- INDEXES for performance
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_hotels_destination ON hotels(destination_id);
CREATE INDEX IF NOT EXISTS idx_restaurants_destination ON restaurants(destination_id);
CREATE INDEX IF NOT EXISTS idx_experiences_destination ON experiences(destination_id);
CREATE INDEX IF NOT EXISTS idx_boutiques_destination ON boutiques_artisanales(destination_id);
CREATE INDEX IF NOT EXISTS idx_vehicules_destination ON vehicules(destination_id);
CREATE INDEX IF NOT EXISTS idx_attractions_destination ON attractions(destination_id);
CREATE INDEX IF NOT EXISTS idx_chambres_hotel ON chambres(hotel_id);
CREATE INDEX IF NOT EXISTS idx_produits_boutique ON produits(boutique_id);
CREATE INDEX IF NOT EXISTS idx_reservations_user ON reservations(user_id);
CREATE INDEX IF NOT EXISTS idx_avis_user ON avis(user_id);
CREATE INDEX IF NOT EXISTS idx_avis_item ON avis(item_id);
CREATE INDEX IF NOT EXISTS idx_commandes_user ON commandes(user_id);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Catalog tables: anyone can read, only service_role can write
ALTER TABLE destinations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read destinations" ON destinations FOR SELECT USING (true);

ALTER TABLE hotels ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read hotels" ON hotels FOR SELECT USING (true);

ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read restaurants" ON restaurants FOR SELECT USING (true);

ALTER TABLE experiences ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read experiences" ON experiences FOR SELECT USING (true);

ALTER TABLE boutiques_artisanales ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read boutiques" ON boutiques_artisanales FOR SELECT USING (true);

ALTER TABLE vehicules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read vehicules" ON vehicules FOR SELECT USING (true);

ALTER TABLE chambres ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read chambres" ON chambres FOR SELECT USING (true);

ALTER TABLE produits ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read produits" ON produits FOR SELECT USING (true);

ALTER TABLE attractions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read attractions" ON attractions FOR SELECT USING (true);

-- User-specific tables: users can only access their own data
ALTER TABLE reservations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users read own reservations" ON reservations
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users insert own reservations" ON reservations
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users update own reservations" ON reservations
  FOR UPDATE USING (auth.uid() = user_id);

ALTER TABLE avis ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public read avis" ON avis FOR SELECT USING (true);
CREATE POLICY "Users insert own avis" ON avis
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users update own avis" ON avis
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users delete own avis" ON avis
  FOR DELETE USING (auth.uid() = user_id);

ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users read own commandes" ON commandes
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users insert own commandes" ON commandes
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users update own commandes" ON commandes
  FOR UPDATE USING (auth.uid() = user_id);
