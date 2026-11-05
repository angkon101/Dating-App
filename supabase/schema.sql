-- ==============================================================================
-- PORICHOY (পরিচয়) - Bangladeshi Minimal & Privacy-First Dating App
-- Supabase / PostgreSQL Database Schema with PostGIS & Row Level Security
-- ==============================================================================

-- 1. Enable PostGIS for ultra-fast, robust geographical distance calculations
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. ENUMS
CREATE TYPE intent_type AS ENUM (
  'serious_marriage',    -- Serious & Marriage Minded
  'meaningful_dating',   -- Long-term Relationship
  'coffee_and_chat',     -- Casual & Exploring
  'halal_modest'         -- Modest & Values-First
);

CREATE TYPE verification_status AS ENUM (
  'unverified',
  'pending_review',
  'verified'
);

CREATE TYPE swipe_direction AS ENUM (
  'like',
  'pass',
  'super_like'
);

-- 3. PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  phone VARCHAR(20) UNIQUE,
  full_name VARCHAR(100) NOT NULL,
  display_name VARCHAR(50),
  birth_date DATE NOT NULL,
  gender VARCHAR(20) NOT NULL, -- 'male', 'female', 'other'
  interested_in VARCHAR(20) NOT NULL, -- 'female', 'male', 'everyone'
  bio TEXT,
  
  -- Bangladeshi Context Fields
  division VARCHAR(50) NOT NULL DEFAULT 'Dhaka',
  area VARCHAR(80) NOT NULL DEFAULT 'Gulshan', -- e.g. Banani, Dhanmondi, Uttara, Chittagong GEC, etc.
  education_institution VARCHAR(100), -- e.g. DU, BUET, IBA, NSU, BRAC, DMC
  profession VARCHAR(100),
  religion_values VARCHAR(50), -- e.g. Practicing, Moderate, Liberal, Spiritual
  
  -- Intent Tag
  intent intent_type NOT NULL DEFAULT 'meaningful_dating',
  
  -- Cultural & Fun Prompts (Key-Value array: [{"q": "My favorite Bangladeshi comfort food", "a": "Kacchi Biryani with extra Aloo"}] )
  prompts JSONB DEFAULT '[]'::jsonb,
  
  -- Media & Privacy Shield
  avatar_urls TEXT[] NOT NULL DEFAULT '{}',
  is_privacy_blurred BOOLEAN NOT NULL DEFAULT false, -- If TRUE, photos remain discreetly blurred until mutual match/permission
  hide_from_contacts BOOLEAN NOT NULL DEFAULT false,
  ghost_mode BOOLEAN NOT NULL DEFAULT false, -- Profile only visible to users you like
  
  -- Safety & Verification
  verification_status verification_status NOT NULL DEFAULT 'unverified',
  verified_at TIMESTAMPTZ,
  
  -- Geo-Location via PostGIS
  location GEOMETRY(Point, 4326), -- Longitude, Latitude
  last_active_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for spatial queries
CREATE INDEX IF NOT EXISTS idx_profiles_location ON public.profiles USING GIST (location);
CREATE INDEX IF NOT EXISTS idx_profiles_gender ON public.profiles(gender, interested_in);
CREATE INDEX IF NOT EXISTS idx_profiles_division ON public.profiles(division);

-- 4. SWIPES TABLE
CREATE TABLE IF NOT EXISTS public.swipes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  swiper_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  swiped_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  direction swipe_direction NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(swiper_id, swiped_id)
);

CREATE INDEX IF NOT EXISTS idx_swipes_lookup ON public.swipes(swiper_id, swiped_id, direction);

-- 5. MATCHES TABLE
CREATE TABLE IF NOT EXISTS public.matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_a UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  user_b UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  matched_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Mutual Photo Unblur consent
  user_a_unblurred BOOLEAN NOT NULL DEFAULT false,
  user_b_unblurred BOOLEAN NOT NULL DEFAULT false,
  
  last_message_at TIMESTAMPTZ DEFAULT NOW(),
  last_message_preview TEXT,
  
  CONSTRAINT unique_match_pair UNIQUE (user_a, user_b),
  CONSTRAINT different_users CHECK (user_a != user_b)
);

CREATE INDEX IF NOT EXISTS idx_matches_users ON public.matches(user_a, user_b);

-- 6. REALTIME CHAT MESSAGES
CREATE TABLE IF NOT EXISTS public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  match_id UUID NOT NULL REFERENCES public.matches(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_read BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_messages_match ON public.messages(match_id, created_at ASC);

-- 7. BLOCKED USERS / CONTACTS (Crucial for Bangladeshi Privacy from Family/Neighbors)
CREATE TABLE IF NOT EXISTS public.blocked_contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  phone_hash VARCHAR(64) NOT NULL, -- SHA-256 hashed phone number so contacts aren't leaked
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, phone_hash)
);

-- ==============================================================================
-- AUTOMATIC MATCH GENERATION TRIGGER
-- When User B swipes 'like' or 'super_like' on User A, and User A already liked B:
-- An automatic match is inserted into `public.matches`.
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.handle_mutual_swipe()
RETURNS TRIGGER AS $$
DECLARE
  partner_swipe swipe_direction;
  user_1 UUID;
  user_2 UUID;
BEGIN
  IF NEW.direction IN ('like', 'super_like') THEN
    -- Check if other user already liked this user
    SELECT direction INTO partner_swipe
    FROM public.swipes
    WHERE swiper_id = NEW.swiped_id AND swiped_id = NEW.swiper_id;

    IF partner_swipe IN ('like', 'super_like') THEN
      -- Standardize pair ordering to avoid duplicate matches
      IF NEW.swiper_id < NEW.swiped_id THEN
        user_1 := NEW.swiper_id;
        user_2 := NEW.swiped_id;
      ELSE
        user_1 := NEW.swiped_id;
        user_2 := NEW.swiper_id;
      END IF;

      INSERT INTO public.matches (user_a, user_b, matched_at)
      VALUES (user_1, user_2, NOW())
      ON CONFLICT (user_a, user_b) DO NOTHING;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_swipe_check_match
  AFTER INSERT OR UPDATE ON public.swipes
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_mutual_swipe();

-- ==============================================================================
-- POSTGIS DISCOVERY FUNCTION (Find nearby candidates with distance in KM)
-- ==============================================================================
CREATE OR REPLACE FUNCTION public.get_candidates(
  p_user_id UUID,
  p_latitude DOUBLE PRECISION,
  p_longitude DOUBLE PRECISION,
  p_radius_km DOUBLE PRECISION DEFAULT 50.0,
  p_limit INT DEFAULT 20
)
RETURNS TABLE (
  id UUID,
  display_name VARCHAR(50),
  age INT,
  gender VARCHAR(20),
  division VARCHAR(50),
  area VARCHAR(80),
  education_institution VARCHAR(100),
  profession VARCHAR(100),
  intent intent_type,
  bio TEXT,
  prompts JSONB,
  avatar_urls TEXT[],
  is_privacy_blurred BOOLEAN,
  verification_status verification_status,
  distance_km DOUBLE PRECISION
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.id,
    p.display_name,
    EXTRACT(YEAR FROM age(p.birth_date))::INT AS age,
    p.gender,
    p.division,
    p.area,
    p.education_institution,
    p.profession,
    p.intent,
    p.bio,
    p.prompts,
    p.avatar_urls,
    p.is_privacy_blurred,
    p.verification_status,
    ROUND((ST_Distance(
      p.location,
      ST_SetSRID(ST_MakePoint(p_longitude, p_latitude), 4326)::geography
    ) / 1000)::numeric, 1)::DOUBLE PRECISION AS distance_km
  FROM public.profiles p
  WHERE p.id != p_user_id
    AND p.ghost_mode = false
    -- Exclude already swiped profiles
    AND NOT EXISTS (
      SELECT 1 FROM public.swipes s 
      WHERE s.swiper_id = p_user_id AND s.swiped_id = p.id
    )
    -- Geographic radius filter
    AND ST_DWithin(
      p.location,
      ST_SetSRID(ST_MakePoint(p_longitude, p_latitude), 4326)::geography,
      p_radius_km * 1000
    )
  ORDER BY distance_km ASC
  LIMIT p_limit;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blocked_contacts ENABLE ROW LEVEL SECURITY;

-- Profiles: Authenticated users can view profiles (filtered by ghost_mode)
CREATE POLICY "Public profiles are visible to authenticated users" 
ON public.profiles FOR SELECT 
TO authenticated 
USING (ghost_mode = false OR auth.uid() = id);

CREATE POLICY "Users can update their own profile" 
ON public.profiles FOR UPDATE 
TO authenticated 
USING (auth.uid() = id);

-- Swipes: Users can only see and insert their own swipes
CREATE POLICY "Users can insert own swipes" 
ON public.swipes FOR INSERT 
TO authenticated 
WITH CHECK (auth.uid() = swiper_id);

CREATE POLICY "Users can view own swipes" 
ON public.swipes FOR SELECT 
TO authenticated 
USING (auth.uid() = swiper_id);

-- Matches: Users can only view matches they belong to
CREATE POLICY "Users can view their matches" 
ON public.matches FOR SELECT 
TO authenticated 
USING (auth.uid() = user_a OR auth.uid() = user_b);

-- Messages: Users can only view and insert messages in matches they belong to
CREATE POLICY "Users can view messages in their matches" 
ON public.messages FOR SELECT 
TO authenticated 
USING (
  EXISTS (
    SELECT 1 FROM public.matches m 
    WHERE m.id = messages.match_id AND (m.user_a = auth.uid() OR m.user_b = auth.uid())
  )
);

CREATE POLICY "Users can insert messages in their matches" 
ON public.messages FOR INSERT 
TO authenticated 
WITH CHECK (
  auth.uid() = sender_id AND
  EXISTS (
    SELECT 1 FROM public.matches m 
    WHERE m.id = messages.match_id AND (m.user_a = auth.uid() OR m.user_b = auth.uid())
  )
);

