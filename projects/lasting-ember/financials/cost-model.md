# Lasting Ember - Cost Model

*Last Updated: January 2025*

## Executive Summary

This document outlines the complete cost structure for Lasting Ember's music licensing platform and Radio Station division at three growth stages: Launch, 6 Months, and 1 Year.

---

## Part 1: Lasting Ember (Music Licensing Platform)

### 1.1 Infrastructure Costs

#### Storage Costs
| Scale | Songs | Avg File Size | Total Storage | Cost/GB/mo | Monthly Cost |
|-------|-------|---------------|---------------|------------|--------------|
| Launch | 1,000 | 50 MB (WAV+MP3) | 50 GB | $0.023 | **$1.15** |
| 6 Months | 100,000 | 50 MB | 5 TB | $0.023 | **$115** |
| 1 Year | 1,000,000 | 50 MB | 50 TB | $0.021* | **$1,050** |

*Volume discount applied at 50TB+

**Storage breakdown per track:**
- Lossless WAV master: ~40 MB
- MP3 320kbps: ~8 MB
- Preview/watermarked: ~2 MB
- Metadata/waveforms: ~0.5 MB

#### CDN/Bandwidth Costs (AWS CloudFront pricing)
| Scale | Est. Monthly Downloads | Avg Download Size | Total Bandwidth | Cost/GB | Monthly Cost |
|-------|------------------------|-------------------|-----------------|---------|--------------|
| Launch | 500 | 40 MB | 20 GB | $0.085 | **$1.70** |
| 6 Months | 50,000 | 40 MB | 2 TB | $0.080 | **$160** |
| 1 Year | 500,000 | 40 MB | 20 TB | $0.060* | **$1,200** |

*Committed use discount

#### Compute/Hosting (AWS/Vercel hybrid)
| Scale | Infrastructure | Monthly Cost |
|-------|----------------|--------------|
| Launch | Vercel Pro + small RDS | **$70** |
| 6 Months | Vercel Team + RDS db.r6g.large | **$450** |
| 1 Year | Dedicated EC2 cluster + RDS Multi-AZ | **$2,500** |

#### Database (PostgreSQL via Supabase/RDS)
| Scale | Database Size | Instance Type | Monthly Cost |
|-------|---------------|---------------|--------------|
| Launch | 1 GB | Supabase Pro | **$25** |
| 6 Months | 50 GB | RDS db.t4g.medium | **$150** |
| 1 Year | 500 GB | RDS db.r6g.large + replica | **$800** |

#### Search Infrastructure (Elasticsearch/Meilisearch)
| Scale | Index Size | Monthly Cost |
|-------|------------|--------------|
| Launch | Self-hosted | **$0** |
| 6 Months | Meilisearch Cloud | **$100** |
| 1 Year | Elasticsearch Cloud | **$500** |

#### Audio Processing (Waveform generation, transcoding)
| Scale | Processing Jobs/mo | Lambda/CPU cost | Monthly Cost |
|-------|-------------------|-----------------|--------------|
| Launch | 1,000 | AWS Lambda | **$5** |
| 6 Months | 10,000 | AWS Lambda | **$50** |
| 1 Year | 50,000 | Dedicated worker | **$300** |

### 1.2 Payment Processing (Stripe)

**Stripe Fees:** 2.9% + $0.30 per transaction

| Scale | Subscribers | Avg Transaction | Gross Revenue | Stripe Fees | % of Revenue |
|-------|-------------|-----------------|---------------|-------------|--------------|
| Launch | 100 | $25 | $2,500 | **$103** | 4.1% |
| 6 Months | 5,000 | $28 | $140,000 | **$5,560** | 4.0% |
| 1 Year | 25,000 | $30 | $750,000 | **$29,250** | 3.9% |

*Note: Higher-value transactions reduce effective rate due to fixed $0.30 component*

### 1.3 Artist Payouts (Revenue Share Model)

**Revenue Share:** 50% of net revenue (after payment processing)

| Scale | Net Revenue | Artist Payout (50%) |
|-------|-------------|---------------------|
| Launch | $2,397 | **$1,199** |
| 6 Months | $134,440 | **$67,220** |
| 1 Year | $720,750 | **$360,375** |

### 1.4 Legal & Compliance

| Category | Launch | 6 Months | 1 Year |
|----------|--------|----------|--------|
| Terms of Service / Artist Agreements | $3,000 (one-time) | — | — |
| Privacy Policy / GDPR Compliance | $2,000 (one-time) | — | — |
| Music Rights Consultation | $1,500 | $500/mo | $1,000/mo |
| Copyright Registration Tools | $0 | $200/mo | $500/mo |
| Business Insurance | $100/mo | $200/mo | $400/mo |
| Accounting/Tax Compliance | $200/mo | $500/mo | $1,500/mo |
| **Total Legal/Compliance** | **$6,800** | **$1,400/mo** | **$3,400/mo** |

### 1.5 Marketing & Customer Acquisition

**Industry Benchmark CAC for SaaS:** $50-150 per subscriber

| Scale | Strategy | Monthly Budget | Target Signups | Est. CAC |
|-------|----------|----------------|----------------|----------|
| Launch | Organic/Content/SEO | **$500** | 50 | $10 |
| 6 Months | Paid (Google/YouTube) + Influencer | **$15,000** | 300 | $50 |
| 1 Year | Full-funnel + Brand | **$50,000** | 600 | $83 |

**Marketing Mix at Scale:**
- Content Marketing: 25%
- Paid Acquisition: 40%
- Influencer/Creator Partnerships: 20%
- Events/PR: 15%

### 1.6 Operations & Support

| Role | Launch | 6 Months | 1 Year |
|------|--------|----------|--------|
| Customer Support (fractional) | $500/mo | $3,000/mo | $8,000/mo |
| Content Curation/QA | $0 | $2,000/mo | $6,000/mo |
| Engineering (fractional) | $2,000/mo | $8,000/mo | $15,000/mo |
| Product/Operations | $0 | $3,000/mo | $8,000/mo |
| **Total Operations** | **$2,500/mo** | **$16,000/mo** | **$37,000/mo** |

### 1.7 Licensing Fees

**Key Advantage: Zero licensing fees** - Artists upload original works they own, granting us distribution rights. No PRO fees, no mechanical royalties.

| Traditional Platform | Our Model |
|---------------------|-----------|
| PRO licensing (ASCAP/BMI): 3-5% | $0 |
| Mechanical royalties: 9.1¢/track | $0 |
| Master use fees: Varies | $0 |
| **Savings:** | **100%** |

---

## Part 2: Radio Station Division

### 2.1 Streaming Infrastructure

**Audio Streaming Specs:**
- Bitrate: 128 kbps (0.96 MB/min, 57.6 MB/hr)
- Concurrent listener bandwidth calculation

| Scale | Concurrent Listeners | Bandwidth/hour | Monthly Hours | Total Bandwidth | Cost |
|-------|---------------------|----------------|---------------|-----------------|------|
| 10K subs | 500 avg | 28.8 GB/hr | 720 hrs | 20.7 TB | **$1,200** |
| 100K subs | 5,000 avg | 288 GB/hr | 720 hrs | 207 TB | **$8,000** |

**Streaming Server Costs:**
| Scale | Infrastructure | Monthly Cost |
|-------|----------------|--------------|
| 10K subs | Icecast on 2x c5.xlarge | **$300** |
| 100K subs | Icecast cluster + CDN | **$1,500** |

### 2.2 Licensing Savings (Catalog-Only Model)

**Traditional Radio Licensing Costs:**
| License Type | Traditional Cost | Our Cost (Own Catalog) |
|--------------|-----------------|------------------------|
| ASCAP | $500-2,000/mo | **$0** |
| BMI | $500-2,000/mo | **$0** |
| SESAC | $200-800/mo | **$0** |
| SoundExchange | $500/mo minimum | **$0** |
| **Total Savings:** | **$1,700-5,300/mo** | **$0** |

### 2.3 Operations

| Category | 10K Subscribers | 100K Subscribers |
|----------|-----------------|------------------|
| DJ/Programming (automated + human) | $1,000/mo | $3,000/mo |
| Engineering/Monitoring | $500/mo | $2,000/mo |
| Moderation (if chat enabled) | $0 | $1,000/mo |
| **Total Operations** | **$1,500/mo** | **$6,000/mo** |

---

## Total Cost Summary

### Lasting Ember Platform

| Category | Launch | 6 Months | 1 Year |
|----------|--------|----------|--------|
| Infrastructure | $102 | $1,025 | $6,350 |
| Payment Processing | $103 | $5,560 | $29,250 |
| Artist Payouts | $1,199 | $67,220 | $360,375 |
| Legal/Compliance | $6,800* | $1,400 | $3,400 |
| Marketing | $500 | $15,000 | $50,000 |
| Operations | $2,500 | $16,000 | $37,000 |
| **Total Monthly** | **$11,204** | **$106,205** | **$486,375** |
| **Excluding Artist Payouts** | **$10,005** | **$38,985** | **$125,900** |

*Launch includes one-time legal setup costs

### Radio Station Division

| Category | 10K Subscribers | 100K Subscribers |
|----------|-----------------|------------------|
| Streaming Infrastructure | $1,500 | $9,500 |
| Licensing | $0 | $0 |
| Operations | $1,500 | $6,000 |
| **Total Monthly** | **$3,000** | **$15,500** |

---

## Key Cost Drivers & Optimization Opportunities

1. **Artist Payouts (50% of revenue)** - Largest cost, but essential for quality catalog
2. **Marketing CAC** - Focus on organic/content to keep CAC under $50
3. **Infrastructure** - Scales efficiently with cloud pricing
4. **Operations** - Automate support with AI to delay hiring

### Cost Efficiency Targets
- Infrastructure: <5% of revenue
- Payment Processing: ~4% of revenue (fixed by Stripe)
- Artist Payouts: 50% of net revenue (contractual)
- Marketing: 10-15% of revenue at scale
- Operations: 15-20% of revenue at scale
