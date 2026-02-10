-- ============================================================================
-- LASTING EMBER - Database Schema
-- Supabase PostgreSQL
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";  -- For fuzzy text matching

-- ============================================================================
-- ENUMS
-- ============================================================================

CREATE TYPE user_role AS ENUM ('artist', 'buyer', 'admin');
CREATE TYPE track_status AS ENUM ('draft', 'pending', 'approved', 'rejected');
CREATE TYPE license_status AS ENUM ('pending', 'active', 'expired', 'revoked');
CREATE TYPE subscription_tier AS ENUM ('free', 'creator', 'pro', 'business', 'enterprise');
CREATE TYPE subscription_status AS ENUM ('active', 'past_due', 'canceled', 'paused', 'trialing');
CREATE TYPE payout_status AS ENUM ('pending', 'processing', 'completed', 'failed');

-- ============================================================================
-- PROFILES (extends auth.users)
-- ============================================================================

-- Base profile for all users
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  role user_role NOT NULL DEFAULT 'buyer',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Artist-specific profile
CREATE TABLE artist_profiles (
  id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  display_name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  bio TEXT,
  avatar_url TEXT,
  banner_url TEXT,
  website TEXT,
  social_links JSONB DEFAULT '{}',
  
  -- Stripe Connect
  stripe_account_id TEXT,
  stripe_onboarded BOOLEAN DEFAULT FALSE,
  
  -- Status
  verified BOOLEAN DEFAULT FALSE,
  featured BOOLEAN DEFAULT FALSE,
  
  -- Stats (denormalized for performance)
  total_tracks INTEGER DEFAULT 0,
  total_licenses_sold INTEGER DEFAULT 0,
  total_earnings_cents BIGINT DEFAULT 0,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Buyer-specific profile  
CREATE TABLE buyer_profiles (
  id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
  company_name TEXT,
  company_type TEXT, -- 'individual', 'agency', 'production', 'brand'
  
  -- Subscription
  subscription_tier subscription_tier DEFAULT 'free',
  stripe_customer_id TEXT,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- CATALOG ORGANIZATION
-- ============================================================================

CREATE TABLE genres (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  parent_id UUID REFERENCES genres(id),
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE moods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE instruments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT UNIQUE NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  category TEXT, -- 'strings', 'percussion', 'electronic', etc.
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- TRACKS
-- ============================================================================

CREATE TABLE tracks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  artist_id UUID NOT NULL REFERENCES artist_profiles(id) ON DELETE CASCADE,
  
  -- Basic Info
  title TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,
  
  -- Audio Properties
  duration_seconds INTEGER NOT NULL,
  bpm INTEGER,
  musical_key TEXT, -- e.g., 'C Major', 'A Minor'
  
  -- Categorization (arrays for flexibility)
  tags TEXT[] DEFAULT '{}',
  
  -- File URLs (Cloudflare R2)
  original_file_key TEXT NOT NULL,   -- Private: WAV/FLAC master
  mp3_file_key TEXT,                  -- Private: 320kbps download
  preview_file_key TEXT,              -- Public: Watermarked preview
  waveform_data JSONB,                -- Waveform for UI
  
  -- Artwork (Supabase Storage)
  artwork_url TEXT,
  
  -- Pricing
  base_price_cents INTEGER NOT NULL DEFAULT 4900, -- $49 default
  exclusive_price_cents INTEGER,      -- If exclusive available
  exclusive_available BOOLEAN DEFAULT TRUE,
  
  -- Status
  status track_status DEFAULT 'draft',
  rejection_reason TEXT,
  
  -- Flags
  featured BOOLEAN DEFAULT FALSE,
  explicit BOOLEAN DEFAULT FALSE,
  
  -- Stats
  play_count INTEGER DEFAULT 0,
  license_count INTEGER DEFAULT 0,
  
  -- Full-text search
  search_vector TSVECTOR,
  
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  published_at TIMESTAMPTZ,
  
  -- Constraints
  UNIQUE(artist_id, slug)
);

-- Junction tables for many-to-many relationships
CREATE TABLE track_genres (
  track_id UUID REFERENCES tracks(id) ON DELETE CASCADE,
  genre_id UUID REFERENCES genres(id) ON DELETE CASCADE,
  PRIMARY KEY (track_id, genre_id)
);

CREATE TABLE track_moods (
  track_id UUID REFERENCES tracks(id) ON DELETE CASCADE,
  mood_id UUID REFERENCES moods(id) ON DELETE CASCADE,
  PRIMARY KEY (track_id, mood_id)
);

CREATE TABLE track_instruments (
  track_id UUID REFERENCES tracks(id) ON DELETE CASCADE,
  instrument_id UUID REFERENCES instruments(id) ON DELETE CASCADE,
  PRIMARY KEY (track_id, instrument_id)
);

-- ============================================================================
-- LICENSE TYPES & LICENSES
-- ============================================================================

-- Define available license types
CREATE TABLE license_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,                 -- 'Standard', 'Premium', 'Unlimited', 'Exclusive'
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  
  -- Default pricing (can be overridden per track)
  default_price_cents INTEGER NOT NULL,
  credits_required INTEGER DEFAULT 1, -- For subscription users
  
  -- Usage rights (what this license permits)
  usage_rights JSONB NOT NULL DEFAULT '{
    "youtube": true,
    "podcast": true,
    "social_media": true,
    "film": false,
    "tv": false,
    "advertising": false,
    "games": false,
    "monetization": true,
    "distribution_limit": null
  }',
  
  -- Terms
  is_exclusive BOOLEAN DEFAULT FALSE,
  duration_type TEXT DEFAULT 'perpetual', -- 'perpetual', 'yearly'
  
  -- Display
  display_order INTEGER DEFAULT 0,
  featured BOOLEAN DEFAULT FALSE,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Track-specific license pricing (optional override)
CREATE TABLE track_license_prices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  track_id UUID REFERENCES tracks(id) ON DELETE CASCADE,
  license_type_id UUID REFERENCES license_types(id) ON DELETE CASCADE,
  price_cents INTEGER NOT NULL,
  available BOOLEAN DEFAULT TRUE,
  UNIQUE(track_id, license_type_id)
);

-- Purchased licenses
CREATE TABLE licenses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  
  -- Parties
  track_id UUID NOT NULL REFERENCES tracks(id),
  buyer_id UUID NOT NULL REFERENCES buyer_profiles(id),
  license_type_id UUID NOT NULL REFERENCES license_types(id),
  
  -- Financial
  amount_cents INTEGER NOT NULL,
  platform_fee_cents INTEGER NOT NULL,
  artist_payout_cents INTEGER NOT NULL,
  currency TEXT DEFAULT 'usd',
  
  -- Stripe
  stripe_payment_intent_id TEXT,
  stripe_invoice_id TEXT,
  used_credits BOOLEAN DEFAULT FALSE,    -- Paid with subscription credits
  
  -- License details
  project_name TEXT,                      -- What buyer is using it for
  project_description TEXT,
  license_pdf_url TEXT,                   -- Generated contract PDF
  
  -- Status
  status license_status DEFAULT 'pending',
  
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  activated_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ                  -- NULL = perpetual
);

-- Download tracking
CREATE TABLE license_downloads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  license_id UUID NOT NULL REFERENCES licenses(id) ON DELETE CASCADE,
  downloaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ip_address INET,
  user_agent TEXT,
  file_type TEXT -- 'wav', 'mp3', 'stems'
);

-- ============================================================================
-- SUBSCRIPTIONS
-- ============================================================================

CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  buyer_id UUID UNIQUE NOT NULL REFERENCES buyer_profiles(id) ON DELETE CASCADE,
  
  -- Plan
  tier subscription_tier NOT NULL,
  
  -- Stripe
  stripe_subscription_id TEXT UNIQUE,
  stripe_customer_id TEXT,
  stripe_price_id TEXT,
  
  -- Credits
  monthly_credits INTEGER NOT NULL,
  credits_remaining INTEGER NOT NULL DEFAULT 0,
  credits_reset_at TIMESTAMPTZ,
  
  -- Status
  status subscription_status DEFAULT 'active',
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOLEAN DEFAULT FALSE,
  
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Credit usage history
CREATE TABLE credit_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subscription_id UUID NOT NULL REFERENCES subscriptions(id),
  license_id UUID REFERENCES licenses(id),
  
  credits_used INTEGER NOT NULL,
  credits_before INTEGER NOT NULL,
  credits_after INTEGER NOT NULL,
  
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================================
-- ARTIST EARNINGS & PAYOUTS
-- ============================================================================

CREATE TABLE artist_earnings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  artist_id UUID NOT NULL REFERENCES artist_profiles(id),
  license_id UUID NOT NULL REFERENCES licenses(id),
  
  amount_cents INTEGER NOT NULL,
  currency TEXT DEFAULT 'usd',
  
  -- Payout status
  paid_out BOOLEAN DEFAULT FALSE,
  payout_id UUID,
  
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE payouts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  artist_id UUID NOT NULL REFERENCES artist_profiles(id),
  
  amount_cents INTEGER NOT NULL,
  currency TEXT DEFAULT 'usd',
  
  -- Stripe
  stripe_transfer_id TEXT,
  stripe_payout_id TEXT,
  
  status payout_status DEFAULT 'pending',
  
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ
);

-- ============================================================================
-- FAVORITES & COLLECTIONS (future feature)
-- ============================================================================

CREATE TABLE favorites (
  buyer_id UUID REFERENCES buyer_profiles(id) ON DELETE CASCADE,
  track_id UUID REFERENCES tracks(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (buyer_id, track_id)
);

CREATE TABLE collections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  buyer_id UUID NOT NULL REFERENCES buyer_profiles(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  is_public BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE collection_tracks (
  collection_id UUID REFERENCES collections(id) ON DELETE CASCADE,
  track_id UUID REFERENCES tracks(id) ON DELETE CASCADE,
  added_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (collection_id, track_id)
);

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Profiles
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_artist_profiles_slug ON artist_profiles(slug);
CREATE INDEX idx_artist_profiles_stripe ON artist_profiles(stripe_account_id) WHERE stripe_account_id IS NOT NULL;

-- Tracks
CREATE INDEX idx_tracks_artist ON tracks(artist_id);
CREATE INDEX idx_tracks_status ON tracks(status);
CREATE INDEX idx_tracks_status_featured ON tracks(status, featured) WHERE status = 'approved';
CREATE INDEX idx_tracks_search ON tracks USING GIN(search_vector);
CREATE INDEX idx_tracks_tags ON tracks USING GIN(tags);
CREATE INDEX idx_tracks_created ON tracks(created_at DESC);
CREATE INDEX idx_tracks_popular ON tracks(license_count DESC) WHERE status = 'approved';

-- Licenses
CREATE INDEX idx_licenses_buyer ON licenses(buyer_id);
CREATE INDEX idx_licenses_track ON licenses(track_id);
CREATE INDEX idx_licenses_status ON licenses(status);
CREATE INDEX idx_licenses_created ON licenses(created_at DESC);

-- Subscriptions
CREATE INDEX idx_subscriptions_stripe ON subscriptions(stripe_subscription_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);

-- Earnings
CREATE INDEX idx_earnings_artist ON artist_earnings(artist_id);
CREATE INDEX idx_earnings_unpaid ON artist_earnings(artist_id) WHERE paid_out = FALSE;

-- ============================================================================
-- FUNCTIONS
-- ============================================================================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Update search vector for tracks
CREATE OR REPLACE FUNCTION update_track_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector := 
    setweight(to_tsvector('english', COALESCE(NEW.title, '')), 'A') ||
    setweight(to_tsvector('english', COALESCE(NEW.description, '')), 'B') ||
    setweight(to_tsvector('english', COALESCE(array_to_string(NEW.tags, ' '), '')), 'B');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Increment artist track count
CREATE OR REPLACE FUNCTION update_artist_track_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE artist_profiles 
    SET total_tracks = total_tracks + 1 
    WHERE id = NEW.artist_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE artist_profiles 
    SET total_tracks = total_tracks - 1 
    WHERE id = OLD.artist_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Update artist stats on license sale
CREATE OR REPLACE FUNCTION update_artist_stats_on_license()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' AND NEW.status = 'active' THEN
    -- Get artist_id from track
    UPDATE artist_profiles ap
    SET 
      total_licenses_sold = total_licenses_sold + 1,
      total_earnings_cents = total_earnings_cents + NEW.artist_payout_cents
    FROM tracks t
    WHERE t.id = NEW.track_id AND ap.id = t.artist_id;
    
    -- Update track license count
    UPDATE tracks 
    SET license_count = license_count + 1 
    WHERE id = NEW.track_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- Updated_at triggers
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER artist_profiles_updated_at
  BEFORE UPDATE ON artist_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER buyer_profiles_updated_at
  BEFORE UPDATE ON buyer_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tracks_updated_at
  BEFORE UPDATE ON tracks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER subscriptions_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Search vector trigger
CREATE TRIGGER tracks_search_vector_update
  BEFORE INSERT OR UPDATE OF title, description, tags ON tracks
  FOR EACH ROW EXECUTE FUNCTION update_track_search_vector();

-- Stats triggers
CREATE TRIGGER update_artist_track_count
  AFTER INSERT OR DELETE ON tracks
  FOR EACH ROW EXECUTE FUNCTION update_artist_track_count();

CREATE TRIGGER update_artist_stats_on_license
  AFTER INSERT OR UPDATE ON licenses
  FOR EACH ROW EXECUTE FUNCTION update_artist_stats_on_license();

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE artist_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE buyer_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE licenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE artist_earnings ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- Profiles: Users can view all, edit own
CREATE POLICY "Profiles viewable by all" ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Artist profiles: Public read, owner write
CREATE POLICY "Artist profiles are public" ON artist_profiles
  FOR SELECT USING (true);

CREATE POLICY "Artists can update own profile" ON artist_profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Artists can insert own profile" ON artist_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Buyer profiles: Owner only
CREATE POLICY "Buyers can view own profile" ON buyer_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Buyers can update own profile" ON buyer_profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Buyers can insert own profile" ON buyer_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Tracks: Approved public, owner manages
CREATE POLICY "Approved tracks are public" ON tracks
  FOR SELECT USING (
    status = 'approved' 
    OR artist_id = auth.uid()
  );

CREATE POLICY "Artists can insert own tracks" ON tracks
  FOR INSERT WITH CHECK (artist_id = auth.uid());

CREATE POLICY "Artists can update own tracks" ON tracks
  FOR UPDATE USING (artist_id = auth.uid());

CREATE POLICY "Artists can delete own tracks" ON tracks
  FOR DELETE USING (artist_id = auth.uid());

-- Licenses: Owner (buyer) can view own
CREATE POLICY "Buyers can view own licenses" ON licenses
  FOR SELECT USING (buyer_id = auth.uid());

CREATE POLICY "System can insert licenses" ON licenses
  FOR INSERT WITH CHECK (buyer_id = auth.uid());

-- Subscriptions: Owner only
CREATE POLICY "Buyers can view own subscription" ON subscriptions
  FOR SELECT USING (buyer_id = auth.uid());

-- Artist earnings: Artist can view own
CREATE POLICY "Artists can view own earnings" ON artist_earnings
  FOR SELECT USING (artist_id = auth.uid());

-- Favorites: Owner only
CREATE POLICY "Buyers can manage own favorites" ON favorites
  FOR ALL USING (buyer_id = auth.uid());

-- ============================================================================
-- SEED DATA
-- ============================================================================

-- Default genres
INSERT INTO genres (name, slug, display_order) VALUES
  ('Electronic', 'electronic', 1),
  ('Hip Hop', 'hip-hop', 2),
  ('Pop', 'pop', 3),
  ('Rock', 'rock', 4),
  ('R&B', 'rnb', 5),
  ('Jazz', 'jazz', 6),
  ('Classical', 'classical', 7),
  ('Ambient', 'ambient', 8),
  ('Folk', 'folk', 9),
  ('World', 'world', 10),
  ('Cinematic', 'cinematic', 11),
  ('Indie', 'indie', 12);

-- Default moods
INSERT INTO moods (name, slug, display_order) VALUES
  ('Uplifting', 'uplifting', 1),
  ('Energetic', 'energetic', 2),
  ('Calm', 'calm', 3),
  ('Dark', 'dark', 4),
  ('Romantic', 'romantic', 5),
  ('Melancholic', 'melancholic', 6),
  ('Epic', 'epic', 7),
  ('Playful', 'playful', 8),
  ('Tense', 'tense', 9),
  ('Dreamy', 'dreamy', 10),
  ('Aggressive', 'aggressive', 11),
  ('Peaceful', 'peaceful', 12);

-- Default instruments
INSERT INTO instruments (name, slug, category) VALUES
  ('Piano', 'piano', 'keys'),
  ('Guitar', 'guitar', 'strings'),
  ('Drums', 'drums', 'percussion'),
  ('Bass', 'bass', 'strings'),
  ('Synthesizer', 'synth', 'electronic'),
  ('Violin', 'violin', 'strings'),
  ('Vocals', 'vocals', 'voice'),
  ('Saxophone', 'saxophone', 'brass'),
  ('Trumpet', 'trumpet', 'brass'),
  ('Strings', 'strings', 'orchestral'),
  ('Orchestra', 'orchestra', 'orchestral'),
  ('Electronic Beats', 'beats', 'electronic');

-- Default license types
INSERT INTO license_types (name, slug, description, default_price_cents, credits_required, usage_rights, is_exclusive, display_order) VALUES
  (
    'Standard',
    'standard',
    'Perfect for YouTube, podcasts, and social media content with up to 100K views/listens.',
    4900,
    1,
    '{"youtube": true, "podcast": true, "social_media": true, "film": false, "tv": false, "advertising": false, "games": false, "monetization": true, "distribution_limit": 100000}',
    false,
    1
  ),
  (
    'Premium',
    'premium',
    'For professional productions with unlimited distribution. Includes film and TV rights.',
    14900,
    3,
    '{"youtube": true, "podcast": true, "social_media": true, "film": true, "tv": true, "advertising": false, "games": false, "monetization": true, "distribution_limit": null}',
    false,
    2
  ),
  (
    'Commercial',
    'commercial',
    'Full commercial rights including advertising, games, and broadcast.',
    29900,
    5,
    '{"youtube": true, "podcast": true, "social_media": true, "film": true, "tv": true, "advertising": true, "games": true, "monetization": true, "distribution_limit": null}',
    false,
    3
  ),
  (
    'Exclusive',
    'exclusive',
    'Full buyout. Track is removed from catalog after purchase. You own all rights.',
    99900,
    0,
    '{"youtube": true, "podcast": true, "social_media": true, "film": true, "tv": true, "advertising": true, "games": true, "monetization": true, "distribution_limit": null, "exclusive": true}',
    true,
    4
  );
