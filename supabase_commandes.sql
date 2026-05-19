-- ============================================================
-- KURGATE — Create commandes table + RLS (safe re-run)
-- Run in Supabase SQL Editor
-- ============================================================

CREATE TABLE IF NOT EXISTS commandes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  boutique_name TEXT NOT NULL DEFAULT '',
  artisan TEXT DEFAULT '',
  product_name TEXT NOT NULL DEFAULT '',
  product_desc TEXT DEFAULT '',
  image_url TEXT DEFAULT '',
  unit_price INT DEFAULT 0,
  quantity INT DEFAULT 1,
  total_price INT DEFAULT 0,
  address TEXT DEFAULT '',
  statut TEXT DEFAULT 'En attente',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;

-- Drop existing policies (safe re-run)
DROP POLICY IF EXISTS "Users read own commandes" ON commandes;
DROP POLICY IF EXISTS "Users insert own commandes" ON commandes;
DROP POLICY IF EXISTS "Users update own commandes" ON commandes;

-- Recreate policies
CREATE POLICY "Users read own commandes"
  ON commandes FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users insert own commandes"
  ON commandes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users update own commandes"
  ON commandes FOR UPDATE
  USING (auth.uid() = user_id);
