-- ============================================
-- Convert ALL prices from USD to MAD (×10)
-- ============================================

-- Hotels: price column
UPDATE hotels SET price = price * 10;

-- Restaurants: price column
UPDATE restaurants SET price = price * 10;

-- Experiences: price column
UPDATE experiences SET price = price * 10;

-- Vehicules: price column
UPDATE vehicules SET price = price * 10;

-- Produits boutique: prix column
UPDATE produits_boutique SET prix = prix * 10;

-- Chambres: prix_par_nuit column
UPDATE chambres SET prix_par_nuit = prix_par_nuit * 10;

-- Boutiques artisanales: prix_moyen (mixed string format — normalize all to 'X - Y MAD')
UPDATE boutiques_artisanales SET prix_moyen = 
  CASE id
    WHEN 'boutique_001' THEN '1500 - 20000 MAD'
    WHEN 'boutique_002' THEN '200 - 3000 MAD'
    WHEN 'boutique_003' THEN '300 - 5000 MAD'
    WHEN 'boutique_004' THEN '500 - 8000 MAD'
    WHEN 'boutique_005' THEN '400 - 6000 MAD'
    WHEN 'boutique_006' THEN '150 - 2000 MAD'
    WHEN 'boutique_007' THEN '350 - 1200 MAD'
    WHEN 'boutique_008' THEN '450 - 1800 MAD'
    WHEN 'boutique_009' THEN '150 - 400 MAD'
    WHEN 'boutique_010' THEN '950 - 2000 MAD'
    ELSE prix_moyen
  END;
