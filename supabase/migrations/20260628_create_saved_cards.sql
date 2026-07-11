CREATE TABLE IF NOT EXISTS saved_cards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  card_number TEXT NOT NULL,
  card_last4 TEXT NOT NULL,
  card_expiry TEXT NOT NULL,
  card_holder TEXT NOT NULL,
  card_brand TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id)
);

ALTER TABLE saved_cards ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own card" ON saved_cards
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own card" ON saved_cards
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own card" ON saved_cards
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own card" ON saved_cards
  FOR DELETE USING (auth.uid() = user_id);
