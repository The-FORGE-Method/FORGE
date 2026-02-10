# Lasting Ember MVP Scope

**Target Launch:** March 1, 2025 (~3 weeks)  
**Philosophy:** Ship the smallest thing that proves the business model works.

---

## What MVP Means

A music creator can:
1. ✅ Find a track they like
2. ✅ Preview it
3. ✅ Pay for a license
4. ✅ Download the file

An artist can:
1. ✅ Sign up and create profile
2. ✅ Upload tracks with metadata
3. ✅ Get paid when tracks are licensed

Everything else is nice-to-have.

---

## MVP Features (Must Have)

### 🎵 Core Catalog

**Public Catalog Page**
- [ ] Grid/list view of approved tracks
- [ ] Filter by genre (single-select dropdown)
- [ ] Filter by mood (single-select dropdown)
- [ ] Basic text search (PostgreSQL full-text)
- [ ] Sort: newest, popular, price

**Track Detail Page**
- [ ] Track title, artist name, description
- [ ] Audio player with waveform
- [ ] Genre, mood, BPM, key display
- [ ] License type options with prices
- [ ] "License This Track" button

**Audio Preview**
- [ ] Watermarked MP3 streaming
- [ ] Simple waveform visualization (wavesurfer.js)
- [ ] Play/pause, seek, volume
- [ ] No download of preview file

### 🎤 Artist Portal (Studio)

**Artist Onboarding**
- [ ] Sign up with email + password
- [ ] Basic profile: name, slug, bio, avatar
- [ ] Stripe Connect Express onboarding

**Track Upload**
- [ ] Upload WAV or FLAC (max 100MB)
- [ ] Auto-extract duration
- [ ] Manual entry: title, description, BPM, key
- [ ] Select genres (multi-select, max 3)
- [ ] Select moods (multi-select, max 3)
- [ ] Free-form tags (comma-separated)
- [ ] Upload cover art (optional)
- [ ] Save as draft or submit for review

**Track Management**
- [ ] List my tracks (with status)
- [ ] Edit track metadata
- [ ] Delete track

**Earnings Dashboard (simple)**
- [ ] Total earnings to date
- [ ] List of licenses sold
- [ ] Available balance
- [ ] "Request Payout" button (Stripe Connect)

### 💳 Buyer Portal

**Buyer Onboarding**
- [ ] Sign up with email + password
- [ ] Basic profile: name, company (optional)

**Licensing Flow**
- [ ] Select license type on track page
- [ ] Enter project name (what it's for)
- [ ] Stripe Checkout for payment
- [ ] License confirmation page
- [ ] Download original file (MP3/WAV)

**My Licenses**
- [ ] List purchased licenses
- [ ] Re-download files
- [ ] View license terms

### 💰 Payments (Stripe)

**For Buyers**
- [ ] Stripe Checkout (hosted page)
- [ ] Credit card / Apple Pay / Google Pay
- [ ] Webhook for payment confirmation

**For Artists**
- [ ] Stripe Connect Express onboarding
- [ ] Automatic transfer on license sale
- [ ] 80% to artist, 20% platform (configurable)

### 🔐 Authentication

- [ ] Email/password auth (Supabase)
- [ ] Email confirmation
- [ ] Password reset
- [ ] Role-based routing (artist vs buyer)

### 📧 Transactional Email (Resend)

- [ ] Welcome email (sign up)
- [ ] License purchased (to buyer)
- [ ] Track licensed (to artist)
- [ ] Password reset

---

## NOT in MVP (Phase 2+)

These are explicitly **out of scope** for March 1:

### Subscriptions
- ❌ Monthly subscription tiers
- ❌ License credits system
- ❌ Metered billing
- ❌ Subscription management

*Why:* Adds significant complexity. Start with pay-per-license to validate demand, then add subscriptions based on user feedback.

### Advanced Search
- ❌ Algolia integration
- ❌ Faceted filtering
- ❌ Similar track recommendations
- ❌ BPM range slider
- ❌ Duration range slider

*Why:* PostgreSQL full-text search is sufficient for <1000 tracks. Add Algolia when catalog grows.

### Audio Processing
- ❌ Automatic watermark generation
- ❌ Automatic waveform generation  
- ❌ Automatic BPM detection
- ❌ Automatic key detection
- ❌ Stems/multitracks

*Why:* Manual for MVP. Artist provides watermarked preview, enters BPM/key manually.

### Social Features
- ❌ Artist following
- ❌ Favorites/collections
- ❌ Reviews/ratings
- ❌ Comments

*Why:* Not critical for core transaction flow.

### Admin Portal
- ❌ Full admin dashboard
- ❌ Track moderation queue
- ❌ User management
- ❌ Analytics dashboard

*Why:* Use Supabase dashboard directly for MVP. Admin portal is Phase 2.

### Legal/Contracts
- ❌ Auto-generated license PDFs
- ❌ Digital signatures
- ❌ Custom license terms

*Why:* Static license terms page for MVP. Fancy PDF generation later.

### Marketing
- ❌ Featured tracks carousel
- ❌ Genre landing pages
- ❌ Artist verification badges
- ❌ Promo codes/discounts

---

## MVP Data Model (Simplified)

For MVP, we use a subset of the full schema:

```
Tables Needed:
├── profiles
├── artist_profiles
├── buyer_profiles
├── genres
├── moods
├── tracks
├── track_genres
├── track_moods
├── license_types (seeded)
├── licenses
└── license_downloads
```

**NOT needed for MVP:**
- subscriptions
- credit_transactions
- artist_earnings (calculate on-the-fly)
- payouts (use Stripe Connect dashboard)
- favorites
- collections
- instruments

---

## MVP Tech Simplifications

### Audio Storage

**Full Vision:**
- Upload to R2 → Worker processes → Watermark → Waveform → Multiple formats

**MVP:**
- Artist uploads WAV + separate watermarked preview MP3
- Store both directly to R2 (no processing)
- Use static waveform or none initially
- No automatic anything

### Search

**Full Vision:**
- Algolia with instant search, facets, AI recommendations

**MVP:**
- PostgreSQL `ILIKE` + `to_tsvector` search
- Simple filter dropdowns
- Good enough for <1000 tracks

### File Delivery

**Full Vision:**
- Signed URLs, CDN, expiring links, watermarked downloads

**MVP:**
- Generate signed R2 URL on download
- Link expires after 1 hour
- No additional watermarking

### Track Approval

**Full Vision:**
- Admin moderation queue with AI screening

**MVP:**
- Tracks auto-approved on submit (trust early artists)
- Manual review via Supabase dashboard if issues

---

## MVP Page List

### Public (no auth)
1. `/` - Landing page (hero, featured, how it works)
2. `/catalog` - Browse/search tracks
3. `/track/[id]` - Track detail
4. `/artists` - Artist directory (simple list)
5. `/artist/[slug]` - Artist profile + tracks
6. `/pricing` - License types explained
7. `/login` - Sign in
8. `/signup` - Sign up (choose artist/buyer)

### Buyer Portal (auth required)
9. `/dashboard` - Overview (recent licenses)
10. `/dashboard/licenses` - All my licenses
11. `/checkout/success` - Post-purchase confirmation

### Artist Portal (auth required)
12. `/studio` - Dashboard overview
13. `/studio/upload` - Upload new track
14. `/studio/tracks` - My tracks list
15. `/studio/tracks/[id]/edit` - Edit track
16. `/studio/earnings` - Earnings summary
17. `/studio/settings` - Profile settings
18. `/studio/connect` - Stripe Connect setup

### Utility
19. `/auth/callback` - OAuth callback
20. `/auth/reset-password` - Password reset

---

## MVP API Endpoints

```
# Public
GET  /api/tracks              # List tracks (with search/filter)
GET  /api/tracks/[id]         # Get track detail
GET  /api/artists             # List artists
GET  /api/artists/[slug]      # Get artist detail
GET  /api/genres              # List genres
GET  /api/moods               # List moods

# Auth (Buyer)
POST /api/checkout            # Create Stripe checkout session
GET  /api/licenses            # Get my licenses
GET  /api/download/[licenseId]# Get signed download URL

# Auth (Artist)
POST /api/studio/tracks       # Create track
PUT  /api/studio/tracks/[id]  # Update track
DEL  /api/studio/tracks/[id]  # Delete track
POST /api/studio/upload       # Get presigned upload URL
GET  /api/studio/earnings     # Get earnings summary
POST /api/studio/connect      # Create Stripe Connect link

# Webhooks
POST /api/webhooks/stripe     # Handle Stripe events
```

---

## MVP Timeline

**Week 1 (Feb 10-16): Foundation**
- [ ] Project setup (Next.js, Supabase, Tailwind)
- [ ] Database schema + migrations
- [ ] Auth flow (signup, login, roles)
- [ ] Basic layout and navigation
- [ ] Artist profile CRUD
- [ ] Cloudflare R2 integration

**Week 2 (Feb 17-23): Core Features**
- [ ] Track upload flow
- [ ] Track listing + search
- [ ] Track detail page
- [ ] Audio player component
- [ ] Artist catalog page
- [ ] Stripe Connect onboarding

**Week 3 (Feb 24-Mar 1): Transactions**
- [ ] Stripe Checkout integration
- [ ] License purchase flow
- [ ] Download delivery
- [ ] My Licenses page
- [ ] Artist earnings page
- [ ] Email notifications
- [ ] Testing + bug fixes
- [ ] Deploy to Vercel

---

## Success Metrics (MVP)

Validate these within 30 days of launch:

1. **Artists sign up:** Can we get 10+ artists to upload tracks?
2. **Catalog size:** Can we hit 50+ approved tracks?
3. **First transaction:** Does anyone actually buy a license?
4. **Artist payout:** Does the payment flow work end-to-end?
5. **Repeat usage:** Do buyers come back?

If we see traction on these, Phase 2 (subscriptions, better search, admin tools) becomes priority.

---

## Launch Checklist

**Before Launch:**
- [ ] Domain configured (lastingember.com?)
- [ ] SSL working
- [ ] Stripe account live mode enabled
- [ ] R2 bucket production-ready
- [ ] Transactional email configured
- [ ] Privacy policy page
- [ ] Terms of service page
- [ ] License terms page
- [ ] Error monitoring (Sentry)
- [ ] Basic analytics (Vercel/Plausible)

**Seed Content:**
- [ ] 5-10 test tracks from beta artists
- [ ] Genres and moods seeded
- [ ] License types configured
- [ ] Landing page copy finalized
