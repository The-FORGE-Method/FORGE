# Lasting Ember Platform Architecture

## Overview

Lasting Ember is a B2B music licensing marketplace connecting independent artists with content creators, media producers, and businesses who need licensed music.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              LASTING EMBER                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                  │
│  │   ARTIST     │    │    BUYER     │    │    ADMIN     │                  │
│  │   PORTAL     │    │   PORTAL     │    │   PORTAL     │                  │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘                  │
│         │                   │                   │                          │
│  ───────┴───────────────────┴───────────────────┴────────────────────────  │
│                                                                             │
│                         NEXT.JS APPLICATION                                 │
│                    (App Router + Server Components)                         │
│                                                                             │
│  ───────────────────────────────────────────────────────────────────────── │
│                                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│  │  SUPABASE   │  │ CLOUDFLARE  │  │   STRIPE    │  │   SEARCH    │       │
│  │  Auth + DB  │  │     R2      │  │   CONNECT   │  │  (pg/Algolia)│      │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘       │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## System Components

### 1. Frontend (Next.js 14+)

**Stack:**
- Next.js 14 with App Router
- TypeScript
- Tailwind CSS + shadcn/ui
- React Query for data fetching
- Zustand for client state

**Route Structure:**
```
/                           # Landing page
/catalog                    # Browse/search music
/track/[id]                 # Track detail + licensing
/artists                    # Artist directory
/artist/[slug]              # Artist profile + catalog

/dashboard                  # Buyer dashboard
/dashboard/licenses         # My licenses
/dashboard/downloads        # Download history
/dashboard/subscription     # Manage subscription

/studio                     # Artist portal
/studio/upload              # Upload tracks
/studio/catalog             # Manage my tracks
/studio/earnings            # Earnings & payouts
/studio/settings            # Artist profile settings

/admin                      # Admin portal (internal)
/admin/tracks               # Track moderation
/admin/artists              # Artist management
/admin/analytics            # Platform analytics
```

### 2. Backend (Supabase)

**Authentication:**
- Email/password for both artists and buyers
- OAuth (Google, potentially Spotify for artists)
- Role-based access: `artist`, `buyer`, `admin`
- Row Level Security (RLS) for all tables

**Database:**
- PostgreSQL with full-text search
- See `database-schema.sql` for complete schema

**Edge Functions:**
- `process-upload`: Handle audio file processing
- `generate-waveform`: Create waveform data
- `create-preview`: Generate watermarked preview
- `stripe-webhook`: Handle Stripe events
- `search-tracks`: Advanced search with filters

### 3. File Storage

**Cloudflare R2** (Primary audio storage):
- Original WAV/FLAC files (masters)
- Compressed MP3 versions (downloads)
- Watermarked preview MP3s (streaming)
- Cost-effective egress (free!)

**Supabase Storage** (Supplementary):
- Artist profile images
- Album artwork
- Track cover art
- Documents (contracts, etc.)

**File Processing Pipeline:**
```
Artist Upload (WAV/FLAC)
         │
         ▼
┌─────────────────────┐
│  Cloudflare Worker  │
│  (or Edge Function) │
└─────────────────────┘
         │
         ├──► Store Original (R2)
         │
         ├──► Generate MP3 320kbps (R2)
         │
         ├──► Generate Preview + Watermark (R2)
         │
         └──► Generate Waveform JSON (DB)
```

### 4. Payment System (Stripe Connect)

**Architecture:**
- Platform uses Stripe Connect (Express accounts)
- Artists onboard via Stripe Express
- Buyers pay platform → Platform splits to artist

**Flow:**
```
Buyer License Purchase
         │
         ▼
   Stripe Checkout
         │
         ▼
   Payment Intent
         │
         ├──► Platform Fee (15-20%)
         │
         └──► Artist Payout (Stripe Connect)
                    │
                    ▼
              Artist Bank Account
```

**Subscription Model:**
- Stripe Billing for recurring subscriptions
- Metered billing for overage (Enterprise)
- Subscription includes license credits

### 5. Search System

**MVP: PostgreSQL Full-Text Search**
- GIN indexes on searchable fields
- tsvector columns for title, artist, tags, description
- Fast enough for <100k tracks

**Phase 2: Algolia (optional)**
- Better relevance ranking
- Faceted filtering
- Typo tolerance
- Instant search experience

---

## Data Models

### Core Entities

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   ARTIST    │────<│   TRACK     │>────│   LICENSE   │
└─────────────┘     └─────────────┘     └─────────────┘
      │                   │                   │
      │                   │                   │
      ▼                   ▼                   ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  PROFILE    │     │   GENRE     │     │    BUYER    │
│  (Supabase) │     │   MOOD      │     │  (User)     │
└─────────────┘     │   TAG       │     └─────────────┘
                    └─────────────┘
```

### User Model (auth.users + profiles)

```typescript
interface User {
  id: string;                    // Supabase auth ID
  email: string;
  role: 'artist' | 'buyer' | 'admin';
  created_at: timestamp;
}

interface ArtistProfile {
  id: string;                    // = user.id
  display_name: string;
  slug: string;                  // URL-friendly name
  bio: string;
  avatar_url: string;
  website: string;
  social_links: JSON;            // { spotify, instagram, etc }
  stripe_account_id: string;     // Connect account
  stripe_onboarded: boolean;
  verified: boolean;             // Platform verified
  created_at: timestamp;
}

interface BuyerProfile {
  id: string;                    // = user.id
  company_name: string;
  subscription_tier: 'free' | 'creator' | 'pro' | 'business' | 'enterprise';
  subscription_id: string;       // Stripe subscription
  license_credits: number;       // Available credits
  created_at: timestamp;
}
```

### Track Model

```typescript
interface Track {
  id: uuid;
  artist_id: string;             // FK to artist_profile
  
  // Metadata
  title: string;
  description: string;
  duration_seconds: number;
  bpm: number;
  key: string;                   // e.g., "C Major"
  
  // Categorization
  genres: string[];              // FK to genres table
  moods: string[];               // FK to moods table  
  tags: string[];                // Free-form tags
  instruments: string[];
  
  // Files (R2 paths)
  original_file_url: string;     // WAV/FLAC master
  mp3_file_url: string;          // 320kbps download
  preview_url: string;           // Watermarked preview
  waveform_data: JSON;           // For UI rendering
  
  // Cover art (Supabase Storage)
  artwork_url: string;
  
  // Licensing
  license_types: LicenseType[];  // Available license options
  exclusive_available: boolean;
  
  // Status
  status: 'draft' | 'pending' | 'approved' | 'rejected';
  featured: boolean;
  plays: number;
  
  // Search optimization
  search_vector: tsvector;       // Full-text search
  
  created_at: timestamp;
  updated_at: timestamp;
}
```

### License Model

```typescript
interface LicenseType {
  id: uuid;
  name: string;                  // "Standard", "Premium", "Exclusive"
  description: string;
  
  // Pricing
  price_cents: number;
  credits_required: number;      // For subscription users
  
  // Rights
  usage_rights: {
    youtube: boolean;
    podcast: boolean;
    film: boolean;
    tv: boolean;
    advertising: boolean;
    games: boolean;
    monetization_allowed: boolean;
    distribution_limit: number;   // Views/streams limit
  };
  
  // Terms
  duration: 'perpetual' | 'yearly';
  exclusive: boolean;
}

interface License {
  id: uuid;
  track_id: uuid;
  buyer_id: string;
  license_type_id: uuid;
  
  // Transaction
  amount_cents: number;
  platform_fee_cents: number;
  artist_payout_cents: number;
  stripe_payment_id: string;
  
  // License details
  project_name: string;          // What it's being used for
  license_pdf_url: string;       // Generated contract
  
  // Status
  status: 'pending' | 'active' | 'expired' | 'revoked';
  
  created_at: timestamp;
  expires_at: timestamp | null;
}
```

### Subscription Model

```typescript
interface Subscription {
  id: uuid;
  buyer_id: string;
  
  tier: 'creator' | 'pro' | 'business' | 'enterprise';
  
  // Stripe
  stripe_subscription_id: string;
  stripe_customer_id: string;
  
  // Limits
  monthly_license_credits: number;
  credits_remaining: number;
  credits_reset_at: timestamp;
  
  // Status
  status: 'active' | 'past_due' | 'canceled' | 'paused';
  current_period_start: timestamp;
  current_period_end: timestamp;
  
  created_at: timestamp;
}
```

---

## API Structure

### REST Endpoints (Next.js API Routes)

```
# Public
GET  /api/tracks                    # List/search tracks
GET  /api/tracks/[id]               # Get track details
GET  /api/artists                   # List artists
GET  /api/artists/[slug]            # Get artist profile
GET  /api/genres                    # List genres
GET  /api/moods                     # List moods

# Auth Required (Buyers)
POST /api/licenses                  # Purchase license
GET  /api/licenses                  # My licenses
GET  /api/licenses/[id]/download    # Download licensed track
GET  /api/subscription              # Get subscription status
POST /api/subscription              # Create/update subscription

# Auth Required (Artists)
POST /api/studio/tracks             # Upload new track
PUT  /api/studio/tracks/[id]        # Update track
DEL  /api/studio/tracks/[id]        # Delete track
GET  /api/studio/earnings           # Earnings summary
POST /api/studio/payout             # Request payout
POST /api/studio/connect            # Stripe onboarding

# Webhooks
POST /api/webhooks/stripe           # Stripe events
```

### Server Actions (preferred for mutations)

```typescript
// Artist actions
'use server'
async function uploadTrack(formData: FormData)
async function updateTrack(trackId: string, data: TrackUpdate)
async function deleteTrack(trackId: string)
async function requestPayout()

// Buyer actions  
async function purchaseLicense(trackId: string, licenseTypeId: string)
async function downloadTrack(licenseId: string)
async function updateSubscription(tier: string)
```

---

## Security Architecture

### Authentication Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Client    │────>│  Supabase   │────>│   JWT +     │
│             │     │    Auth     │     │   Session   │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │     RLS     │
                    │   Policies  │
                    └─────────────┘
```

### Row Level Security (RLS)

Every table has RLS enabled with policies like:

```sql
-- Artists can only manage their own tracks
CREATE POLICY "Artists manage own tracks" ON tracks
  FOR ALL USING (artist_id = auth.uid());

-- Buyers can view approved tracks
CREATE POLICY "View approved tracks" ON tracks
  FOR SELECT USING (status = 'approved');

-- Buyers can view their own licenses
CREATE POLICY "View own licenses" ON licenses
  FOR SELECT USING (buyer_id = auth.uid());
```

### File Access Security

```
Original Files (R2)
├── Private bucket
├── Only accessible via signed URLs
└── Generated on valid license

Preview Files (R2)
├── Public bucket (watermarked)
└── Anyone can stream previews
```

---

## Infrastructure

### Hosting

- **Frontend/API:** Vercel (Next.js optimal)
- **Database:** Supabase (managed PostgreSQL)
- **Audio Files:** Cloudflare R2
- **CDN:** Cloudflare (included with R2)
- **Email:** Resend or SendGrid

### Environment Variables

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Stripe
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=

# Cloudflare R2
R2_ACCOUNT_ID=
R2_ACCESS_KEY_ID=
R2_SECRET_ACCESS_KEY=
R2_BUCKET_NAME=

# Search (Phase 2)
ALGOLIA_APP_ID=
ALGOLIA_ADMIN_KEY=
NEXT_PUBLIC_ALGOLIA_SEARCH_KEY=
```

---

## Scaling Considerations

### Phase 1 (MVP - Launch)
- Supabase Free/Pro tier
- Cloudflare R2 (scales automatically)
- Vercel Hobby/Pro
- ~1,000 tracks, ~100 users

### Phase 2 (Growth)
- Supabase Pro/Team
- Add Algolia for search
- Add audio processing workers
- ~10,000 tracks, ~1,000 users

### Phase 3 (Scale)
- Supabase Enterprise or self-hosted
- Dedicated audio CDN
- ML-based recommendations
- ~100,000+ tracks

---

## Integration Points

### Artist Onboarding
1. Sign up with email
2. Complete profile
3. Connect Stripe Express
4. Upload first track
5. Track approved → Live in catalog

### Buyer Journey
1. Browse catalog (no auth)
2. Sign up to license
3. Choose subscription tier
4. Use credits or pay per-license
5. Download with license PDF

### Revenue Flow
1. Buyer pays for license
2. Stripe processes payment
3. Platform takes 15-20% fee
4. Remainder held for artist
5. Artist withdraws to bank

---

## Monitoring & Analytics

- **Application:** Vercel Analytics
- **Database:** Supabase Dashboard
- **Payments:** Stripe Dashboard
- **Custom:** PostHog or Mixpanel (Phase 2)

Track key metrics:
- Track uploads/approvals
- Catalog searches
- License purchases
- Artist earnings
- Subscription conversions
