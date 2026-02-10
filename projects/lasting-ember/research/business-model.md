# Lasting Ember: Music Licensing Platform Business Research

**Date:** February 7, 2026  
**Target:** 100K songs in 6 months, 1M songs in 1 year  
**Timeline:** Go-live in ~3 weeks (MVP)

---

## Executive Summary

Lasting Ember aims to become a music licensing platform connecting original music creators with film, TV, games, and advertising buyers. This document outlines the business model options, legal requirements, technical architecture, and operational considerations needed to launch and scale rapidly.

---

## 1. Business Model Options

### 1.1 Licensing Models Comparison

| Model | Description | Pros | Cons | Examples |
|-------|-------------|------|------|----------|
| **Subscription (All-in-One)** | Flat monthly/annual fee for unlimited downloads | Predictable revenue, easy customer UX | Lower per-track value, requires large catalog | Artlist, Epidemic Sound |
| **Per-License/À la Carte** | Pay per track, tiered by usage | Higher per-track value, flexible pricing | Higher friction, complex pricing | Musicbed, PremiumBeat |
| **Royalty-Based** | Revenue share on each use | Aligns incentives, PRO integration | Complex tracking, delayed payments | Traditional sync |
| **Buyout (Work-for-Hire)** | One-time payment, full rights transfer | Clean rights, no ongoing obligations | Artists lose ownership, higher upfront cost | White-label libraries |
| **Hybrid** | Subscription base + premium tracks | Best of both worlds | Operational complexity | Soundstripe |

### 1.2 Recommended Model: Direct Licensing (Epidemic Sound Style)

For rapid scale to 1M songs, the **Direct Licensing / Subscription Model** is recommended:

**Key Features:**
- Own or control 100% of rights to all catalog music
- Artists retain songwriting credit but assign sync rights
- No PRO registration required for catalog tracks (simplified)
- Single blanket license covers all uses globally
- Subscription tiers for different customer segments

**Why This Works for Scale:**
1. **No PRO clearance needed** - Dramatically simplifies licensing
2. **Predictable revenue** - Easier financial planning
3. **Artist appeal** - Guaranteed income vs. uncertain royalties
4. **Customer simplicity** - One license, use anywhere

### 1.3 Customer Segments & Pricing

| Segment | Use Case | Suggested Pricing | License Scope |
|---------|----------|-------------------|---------------|
| **Creator** | YouTubers, podcasters, social | $15-20/month | Personal online use |
| **Professional** | Freelance editors, small agencies | $30-50/month | Client work, commercial |
| **Business** | Companies, brands | $99-199/month | Full commercial, advertising |
| **Enterprise** | Studios, networks, platforms | Custom ($10K-100K+/year) | Broadcast, film, games |

---

## 2. Legal Requirements (US Operations)

### 2.1 Business Entity Formation

**Recommended: Delaware C-Corporation** (for VC-fundable growth)
- Formation cost: ~$200-500
- Registered agent required
- Can later convert to S-Corp for tax benefits if needed

Alternative: **LLC** (Wyoming or Delaware) for simpler structure

**Why Delaware:**
- Favorable business laws
- Established legal precedent
- Preferred by investors
- Privacy protections

### 2.2 Required Registrations & Licenses

| Requirement | Cost | Timeline | Notes |
|-------------|------|----------|-------|
| EIN (Tax ID) | Free | Immediate | IRS Form SS-4 |
| State Business Registration | $50-200 | 1-2 days | State of operation |
| Trademark (USPTO) | $250-350/class | 8-12 months | "Lasting Ember" mark |
| Copyright Registration | $45-65/work | 3-6 months | For owned compositions |
| Music Publisher Registration | Varies | 1-4 weeks | With PROs if needed |

### 2.3 Legal Contracts Needed

1. **Artist Agreement** - Rights acquisition from musicians
2. **Terms of Service** - Customer usage terms
3. **License Agreement** - Specific rights granted to customers
4. **Privacy Policy** - GDPR/CCPA compliant
5. **DMCA Designated Agent** - Copyright Office registration (~$6)

### 2.4 Copyright Considerations

**For Direct Licensing Model (Non-PRO):**
- Artists agree NOT to register tracks with ASCAP/BMI/SESAC
- Platform controls all sync licensing rights
- Mechanical rights handled internally
- No blanket license needed from PROs

**Music Modernization Act (MMA) Considerations:**
- The MLC (Mechanical Licensing Collective) covers streaming/download royalties
- For pure sync licensing, MLC registration not required
- If tracks are distributed to DSPs, MLC registration needed

---

## 3. Artist Acquisition & Contract Structures

### 3.1 Rights Acquisition Models

#### Model A: Non-Exclusive License
```
Artist retains copyright
Platform gets non-exclusive sync rights
Artist can license elsewhere
Revenue: 50/50 split typical
```
**Pros:** Easier artist recruitment  
**Cons:** Competition, rights complexity

#### Model B: Exclusive Assignment
```
Platform acquires exclusive sync rights
Artist retains songwriter credit
Limited term (2-5 years) or perpetual
Revenue: Flat fee OR revenue share
```
**Pros:** Clean rights, catalog control  
**Cons:** Harder to acquire, higher cost

#### Model C: Work-for-Hire / Buyout
```
Platform owns 100% of copyright
One-time payment to artist
Complete rights control
```
**Pros:** Maximum control  
**Cons:** Expensive, less artist appeal

### 3.2 Recommended Contract Structure

**For 100K-1M song scale:**

```
HYBRID EXCLUSIVE AGREEMENT

Rights Granted:
- Exclusive sync licensing rights worldwide
- Non-exclusive distribution rights (streaming)
- Term: 3 years, auto-renew

Artist Retains:
- Songwriter credit and performance royalties (PRO)
- Right to perform live
- Ownership of master (optional)

Compensation Options:
A) Upfront: $50-200 per track + 20% of net revenue
B) Revenue Share: 50% of net revenue (no upfront)
C) Advance Against Royalties: $100-500 per track, recoupable

Territories: Worldwide
Media: All media (film, TV, games, advertising, online)
```

### 3.3 Artist Acquisition Strategy for Scale

**Phase 1: Seed Catalog (0-10K tracks)**
- Partner with 5-10 production music houses
- License existing catalogs non-exclusively
- Commission 500-1000 original tracks

**Phase 2: Organic Growth (10K-100K)**
- Open artist submission portal
- Quality-based curation (10-20% acceptance)
- Offer competitive rev-share (50%+)

**Phase 3: Scale (100K-1M)**
- Acquire smaller catalogs
- International partnerships
- AI-generated music (with disclosure)
- User-generated content partnerships

---

## 4. Competitive Analysis: Existing Platforms

### 4.1 Platform Comparison

| Platform | Model | Catalog Size | Pricing | Key Differentiator |
|----------|-------|--------------|---------|-------------------|
| **Epidemic Sound** | Subscription + Direct License | 50,000+ | $15-49/mo | No PRO, all rights cleared |
| **Artlist** | Subscription | 40,000+ | $199/yr | Unlimited perpetual license |
| **Musicbed** | Per-License | 60,000+ | $49-2500/track | Premium, curated |
| **Soundstripe** | Subscription | 25,000+ | $135-295/yr | SFX included |
| **PremiumBeat** | Per-License | 40,000+ | $49-199/track | Shutterstock owned |
| **AudioJungle** | Per-License | 1.5M+ | $1-50 | Envato marketplace |

### 4.2 Epidemic Sound Deep Dive (Model to Emulate)

**Business Model:**
- Direct licensing: Owns/controls all rights
- Artists NOT registered with PROs for catalog tracks
- Revenue share with artists (undisclosed %, estimated 30-50%)
- Subscription for customers ($15-49/month)
- Enterprise deals for major platforms (YouTube, Facebook)

**Why It Works:**
- No copyright claims on customer content
- Simple one-license model
- Global clearance
- Fast customer onboarding

**Artist Compensation:**
- Monthly royalty based on track performance
- Advance payments for commissioned work
- No specific per-stream rate disclosed

### 4.3 Key Success Factors

1. **Rights Clarity** - Clean, simple licensing
2. **Quality Curation** - Not just volume, but usability
3. **Search/Discovery** - AI-powered, mood/scene-based
4. **Integration** - Plugins for editing software
5. **Customer Trust** - No copyright strikes

---

## 5. Technical Requirements for Platform

### 5.1 Core Platform Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     LASTING EMBER PLATFORM                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Website   │  │  Artist     │  │  API / Enterprise   │  │
│  │   (Next.js) │  │  Portal     │  │  Integrations       │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
│         │                │                     │             │
│         └────────────────┼─────────────────────┘             │
│                          │                                   │
│                   ┌──────▼──────┐                           │
│                   │   API Layer │                           │
│                   │  (Node.js)  │                           │
│                   └──────┬──────┘                           │
│                          │                                   │
│    ┌─────────────────────┼─────────────────────┐            │
│    │                     │                     │            │
│ ┌──▼──┐  ┌───────────────▼──┐  ┌──────────────▼───┐        │
│ │Auth │  │  Music Catalog   │  │  License/Rights  │        │
│ │Svc  │  │  Service         │  │  Management      │        │
│ └─────┘  └────────┬─────────┘  └──────────────────┘        │
│                   │                                         │
│    ┌──────────────┴──────────────┐                         │
│    │                             │                         │
│ ┌──▼────────┐  ┌────────────────▼───┐                     │
│ │PostgreSQL │  │  Object Storage    │                     │
│ │(Supabase) │  │  (S3/Cloudflare R2)│                     │
│ └───────────┘  └────────────────────┘                     │
│                                                             │
│              ┌──────────────────────┐                      │
│              │  CDN (Cloudflare)    │                      │
│              │  Audio Delivery      │                      │
│              └──────────────────────┘                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 Database Schema (Core Tables)

```sql
-- Artists
CREATE TABLE artists (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE,
  payout_details JSONB,
  contract_type TEXT, -- 'exclusive', 'non-exclusive', 'buyout'
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tracks
CREATE TABLE tracks (
  id UUID PRIMARY KEY,
  title TEXT NOT NULL,
  artist_id UUID REFERENCES artists(id),
  duration_seconds INT,
  bpm INT,
  key TEXT,
  genres TEXT[],
  moods TEXT[],
  instruments TEXT[],
  waveform_data JSONB,
  audio_url TEXT,
  preview_url TEXT,
  stems_available BOOLEAN DEFAULT FALSE,
  rights_status TEXT, -- 'cleared', 'pending', 'disputed'
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Licenses
CREATE TABLE licenses (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  track_id UUID REFERENCES tracks(id),
  license_type TEXT, -- 'subscription', 'single', 'enterprise'
  usage_scope TEXT, -- 'personal', 'commercial', 'broadcast'
  territories TEXT[], -- ['US', 'WORLDWIDE']
  valid_from DATE,
  valid_until DATE,
  download_count INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Subscriptions
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  plan_type TEXT, -- 'creator', 'professional', 'business'
  status TEXT, -- 'active', 'cancelled', 'past_due'
  stripe_subscription_id TEXT,
  current_period_start DATE,
  current_period_end DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Usage Tracking (for royalty calculation)
CREATE TABLE track_usage (
  id UUID PRIMARY KEY,
  track_id UUID REFERENCES tracks(id),
  license_id UUID REFERENCES licenses(id),
  usage_type TEXT, -- 'download', 'stream', 'sync'
  platform TEXT, -- where used: 'youtube', 'tiktok', 'film', etc.
  timestamp TIMESTAMPTZ DEFAULT NOW()
);
```

### 5.3 Audio Processing Pipeline

```
INGEST PIPELINE:

1. Upload (Artist Portal)
   └─→ Validate format (WAV, AIFF, FLAC - 16bit/44.1kHz minimum)
   
2. Audio Processing (Background Job)
   ├─→ Generate preview (30-60 sec MP3 128kbps)
   ├─→ Generate waveform (JSON peaks data)
   ├─→ Extract metadata (BPM, key detection)
   ├─→ Generate multiple formats:
   │   ├── WAV (original)
   │   ├── MP3 320kbps (download)
   │   └── MP3 128kbps (preview)
   └─→ AI tagging (genre, mood, instruments)
   
3. Storage
   ├─→ Original → Cold storage (S3 Glacier)
   ├─→ Downloads → Hot storage (S3/R2)
   └─→ Previews → CDN edge cache

4. Cataloging
   └─→ Update search index (Elasticsearch/Algolia)
```

### 5.4 Search & Discovery Features

**Essential:**
- Genre/mood/tempo filters
- Duration filtering
- Keyword search (title, description)
- Similar track recommendations

**Advanced (Phase 2):**
- AI-powered scene matching ("find music for car chase")
- Reference track matching (upload audio → find similar)
- Lyrics search
- Vocal/instrumental filter

**Technical Stack:**
- Algolia or Meilisearch for fast, faceted search
- Audio fingerprinting (Chromaprint/Dejavu)
- ML embeddings for similarity (wav2vec, OpenL3)

### 5.5 MVP Feature Checklist (3 Weeks)

**Week 1:**
- [ ] User auth (Supabase Auth)
- [ ] Basic catalog browsing
- [ ] Audio player with preview
- [ ] Search with filters

**Week 2:**
- [ ] Stripe subscription integration
- [ ] Download with license generation
- [ ] User dashboard (downloads, licenses)
- [ ] Basic artist portal (upload)

**Week 3:**
- [ ] Admin dashboard
- [ ] Batch upload processing
- [ ] License PDF generation
- [ ] Launch marketing site

---

## 6. Payment Processing

### 6.1 Customer Payments

**Recommended: Stripe**

```javascript
// Subscription setup
const subscription = await stripe.subscriptions.create({
  customer: customerId,
  items: [{ price: 'price_professional_monthly' }],
  payment_behavior: 'default_incomplete',
  expand: ['latest_invoice.payment_intent'],
});
```

**Pricing Setup:**
- Monthly and annual plans
- Metered billing for enterprise (per-seat or per-project)
- International pricing (geo-based)

### 6.2 Artist Payouts

**Recommended: Stripe Connect (Express)**

Stripe Connect allows:
- Artist onboarding with identity verification
- Automatic 1099 generation (US)
- International payouts (46+ countries)
- Split payments on each transaction

**Payout Schedule:**
- Monthly payouts (NET 30)
- Minimum threshold: $50
- Processing fee: 0.25% + $0.25 per payout

**Alternative: PayPal Mass Payments / Tipalti** for high-volume, lower-cost payouts

### 6.3 Revenue Split Example

```
Customer pays: $29/month subscription

Platform allocation:
├── Stripe fee (2.9% + $0.30): $1.14
├── Platform revenue (50%): $13.93
└── Artist pool (50%): $13.93

Artist pool distribution:
- Pro-rata based on download count
- Or pro-rata based on listening time
- Minimum per-download: $0.03-0.10
```

---

## 7. PRO Integration & MLC Requirements

### 7.1 Understanding PROs

| Organization | Role | Registration Fee | Notes |
|--------------|------|------------------|-------|
| **ASCAP** | Performance royalties | Free (writers) | Collects when music is publicly performed |
| **BMI** | Performance royalties | Free (writers) | Alternative to ASCAP |
| **SESAC** | Performance royalties | Invite-only | Smaller, selective |
| **The MLC** | Mechanical royalties | Free | For streaming/downloads, mandated by MMA |

### 7.2 Direct Licensing Strategy (Avoiding PRO Complexity)

**The Epidemic Sound Approach:**

To avoid per-use royalty tracking and PRO payments:
1. Artists agree NOT to register catalog tracks with PROs
2. Platform handles all licensing directly
3. Artists receive upfront payment OR revenue share
4. Customers get "all rights included" license

**Legal Language (Artist Agreement):**
```
Artist agrees that the Works submitted to the Platform shall not be 
registered with any performing rights organization (PRO) including 
ASCAP, BMI, SESAC, or any foreign equivalent during the Term of 
this Agreement.

Artist waives any claims to public performance royalties for the 
Works during the Term, in exchange for the compensation set forth 
in Schedule A.
```

### 7.3 If PRO Integration Is Needed

For tracks where artists retain PRO membership:

1. **Register as a Music Publisher** with each PRO (~$150-500)
2. **Obtain blanket licenses** for public performance use
3. **Report cue sheets** for broadcast/film uses
4. **Pay through fees** to customers for PRO-registered tracks

**This adds significant complexity - avoid if possible for MVP**

### 7.4 MLC Registration (If Distributing to DSPs)

If Lasting Ember tracks are distributed to Spotify, Apple Music, etc.:

1. Register as a **Music Publisher** with The MLC
2. Submit works database (track metadata, ownership splits)
3. MLC collects and distributes mechanical royalties
4. Platform or artist can claim as publisher

**For sync-only platform, MLC registration not required**

---

## 8. Go-Live Checklist (3-Week Sprint)

### Week 1: Foundation

**Day 1-2: Legal & Business**
- [ ] Form Delaware C-Corp or LLC
- [ ] Obtain EIN
- [ ] Open business bank account
- [ ] Draft artist agreement (use template, legal review)
- [ ] Draft Terms of Service and License Agreement

**Day 3-5: Technical Setup**
- [ ] Set up Supabase project
- [ ] Configure Cloudflare R2 for storage
- [ ] Set up Next.js project with auth
- [ ] Create database schema
- [ ] Set up Stripe account and products

**Day 6-7: Content Pipeline**
- [ ] License initial catalog (500-1000 tracks)
- [ ] OR commission production music
- [ ] Set up audio processing pipeline

### Week 2: Core Features

**Day 8-10: Customer Experience**
- [ ] Browse/search catalog
- [ ] Audio player
- [ ] User registration/login
- [ ] Subscription checkout

**Day 11-12: Licensing System**
- [ ] Download functionality
- [ ] License generation (PDF)
- [ ] Download history

**Day 13-14: Artist Portal (Basic)**
- [ ] Artist registration
- [ ] Track upload
- [ ] Earnings dashboard

### Week 3: Polish & Launch

**Day 15-17: Admin & Operations**
- [ ] Admin dashboard
- [ ] Content moderation tools
- [ ] Reporting (downloads, revenue)
- [ ] Email notifications

**Day 18-19: Testing & QA**
- [ ] End-to-end user journey testing
- [ ] Payment flow testing
- [ ] Mobile responsiveness
- [ ] Load testing

**Day 20-21: Launch**
- [ ] Deploy to production
- [ ] DNS/SSL configuration
- [ ] Launch marketing push
- [ ] Monitor and hotfix

---

## 9. Scaling to 100K-1M Songs

### 9.1 Catalog Acquisition Strategy

| Phase | Timeline | Target | Strategy |
|-------|----------|--------|----------|
| Seed | Month 1 | 1,000 | Commission + license existing |
| Early Growth | Month 2-3 | 10,000 | Open submissions, partnerships |
| Growth | Month 4-6 | 100,000 | Bulk catalog deals, international |
| Scale | Month 7-12 | 1,000,000 | Acquisitions, AI-assisted, UGC |

### 9.2 International Expansion

**Priority Markets:**
1. United Kingdom (easy, English-speaking)
2. Germany (strong music production industry)
3. Japan (huge media market)
4. Brazil (growing creator economy)

**Requirements per market:**
- Local payment methods
- GDPR/local privacy compliance
- Local currency pricing
- Localized content curation

### 9.3 Technical Scaling Considerations

**Database:**
- Read replicas for search performance
- Sharding by region if needed
- Time-series DB for analytics

**Storage:**
- Multi-region replication
- CDN optimization for audio delivery
- Predictive pre-caching for popular tracks

**Search:**
- Elasticsearch cluster scaling
- Dedicated ML inference servers for similarity

### 9.4 Cost Projections at Scale

| Cost Category | 10K Tracks | 100K Tracks | 1M Tracks |
|---------------|------------|-------------|-----------|
| Storage (GB) | 500 GB ($15/mo) | 5 TB ($150/mo) | 50 TB ($1,500/mo) |
| CDN/Transfer | $200/mo | $2,000/mo | $15,000/mo |
| Database | $100/mo | $500/mo | $2,000/mo |
| Compute | $200/mo | $1,000/mo | $5,000/mo |
| **Total Infra** | **~$500/mo** | **~$4,000/mo** | **~$25,000/mo** |

---

## 10. Risk Factors & Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Copyright infringement claims | High | Medium | Robust vetting, ContentID monitoring |
| Artist disputes | Medium | Medium | Clear contracts, dispute resolution |
| Competitor price war | Medium | High | Differentiate on quality, UX |
| Platform dependency (Stripe) | Medium | Low | Backup payment provider |
| PRO enforcement | High | Low | Clear artist agreements, legal counsel |
| Content quality issues | Medium | Medium | Curation team, AI screening |

---

## 11. Key Metrics to Track

**Business Metrics:**
- MRR (Monthly Recurring Revenue)
- Subscriber count by tier
- Churn rate
- LTV (Lifetime Value) by segment
- CAC (Customer Acquisition Cost)

**Catalog Metrics:**
- Total tracks
- Tracks added per week
- Download-to-catalog ratio
- "Dead" tracks (never downloaded)

**Artist Metrics:**
- Active artists
- Tracks per artist
- Artist earnings distribution
- Artist churn

**Product Metrics:**
- Search-to-download conversion
- Time to find a track
- Return user rate
- License disputes

---

## 12. Next Steps

### Immediate Actions (This Week)

1. **Legal:** Engage entertainment/music lawyer for contract review
2. **Business:** Incorporate in Delaware
3. **Content:** Identify 3-5 production music partners for initial catalog
4. **Technical:** Spin up Supabase project and Stripe account
5. **Branding:** Finalize logo, color scheme, domain purchase

### Questions to Resolve

1. Will artists be able to register tracks with PROs? (Recommend: No)
2. What's the minimum revenue share for artists? (Recommend: 50%)
3. What's the initial subscription pricing? (Recommend: $19/mo creator, $49/mo pro)
4. Will we offer single-track licensing? (Recommend: Not at launch)
5. International from day 1 or US-only? (Recommend: US first, then UK)

---

## Appendix A: Legal Template Resources

- **Musicbed Artist Agreement** (reference): Exclusive, 2-year term, 50/50 split
- **Epidemic Sound Model**: Non-PRO, guaranteed payout, all-in pricing
- **Creative Commons Zero**: For royalty-free reference

## Appendix B: Technology Stack Recommendation

| Layer | Technology | Reason |
|-------|------------|--------|
| Frontend | Next.js 14 | SSR, fast, great DX |
| Auth | Supabase Auth | Easy, secure, OAuth |
| Database | Supabase (Postgres) | SQL, real-time, auth integration |
| Storage | Cloudflare R2 | S3-compatible, no egress fees |
| CDN | Cloudflare | Fast, DDoS protection |
| Search | Meilisearch or Algolia | Fast, faceted, typo-tolerant |
| Payments | Stripe + Connect | Subscriptions, payouts |
| Email | Resend or Postmark | Transactional email |
| Analytics | PostHog or Mixpanel | Product analytics |
| Monitoring | Sentry | Error tracking |

## Appendix C: Competitor Pricing Reference

**Artlist (2024-2026):**
- Social Creator: $119.88/year
- Creator Pro: $179.88/year
- Teams: $499/year

**Epidemic Sound (2024-2026):**
- Personal: $15/month
- Commercial: $49/month
- Enterprise: Custom

**Musicbed (Per-license):**
- Personal Projects: $49-99
- Commercial/Ad: $199-999
- Film/TV: $499-2,500+

---

*Document compiled February 2026 for Lasting Ember platform planning.*
