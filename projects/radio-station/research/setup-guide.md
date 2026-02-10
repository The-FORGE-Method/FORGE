# Internet Radio Station Setup Guide
## Comprehensive Research Document

*Last Updated: February 2026*

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Legal Requirements & Music Licensing](#legal-requirements--music-licensing)
3. [Technical Infrastructure Options](#technical-infrastructure-options)
4. [Programming & Scheduling Systems](#programming--scheduling-systems)
5. [Revenue Models & Monetization](#revenue-models--monetization)
6. [Costs & Ongoing Fees](#costs--ongoing-fees)
7. [Business Structure Considerations](#business-structure-considerations)
8. [Conclusion & Recommendations](#conclusion--recommendations)

---

## Executive Summary

Starting an internet radio station in 2026 requires navigating a complex landscape of music licensing, technical infrastructure, and business considerations. Unlike traditional FM/AM broadcasting, internet radio does not require an FCC license in the US, but does require proper music licensing—a more demanding requirement than terrestrial radio faces.

**Key Takeaways:**
- Multiple licenses are required (PROs + SoundExchange)
- Costs range from ~$2,000/year for small operations to $100,000+/year for commercial ventures
- Self-hosted solutions (AzuraCast, Icecast) vs. managed services (Live365, RadioKing)
- Revenue primarily comes from advertising, sponsorships, and subscriptions
- Integration with a music licensing company offers significant strategic synergies

---

## Legal Requirements & Music Licensing

### Overview of US Music Licensing

Internet radio stations must secure multiple licenses to legally stream copyrighted music. This is fundamentally different from traditional radio, which only pays publishing royalties. Internet radio pays both **publishing royalties** (to songwriters/publishers) and **performance royalties** (to recording artists/labels).

### Required Licenses

#### 1. Performance Rights Organizations (PROs) — Publishing Rights

These organizations collect royalties for songwriters, composers, and music publishers:

| Organization | Description | Annual Minimum | Rate Structure |
|--------------|-------------|----------------|----------------|
| **ASCAP** | ~920,000 members, millions of songs | ~$500-$1,000+ | Based on revenue/listenership |
| **BMI** | 1+ million members, 22.4+ million works | ~$500-$1,000+ | Based on revenue/listenership |
| **SESAC** | Invite-only, selective catalog | Negotiated | Varies by use case |
| **GMR** | Newer PRO (founded 2013), 123,000+ titles | Negotiated | Blanket license model |

**Key Points:**
- You typically need licenses from ALL PROs to legally play any song
- ASCAP and BMI are the largest; SESAC and GMR have smaller but important catalogs
- Rates are typically based on a percentage of revenue (often 3-5% per PRO) or per-performance fees
- Small webcasters may qualify for reduced rate structures

**ASCAP Internet License Categories:**
- Website, Podcast, or Mobile App
- Streaming services
- Interactive and non-interactive services

**BMI Licensing:**
- Over 60 different license types
- Internet/Digital category covers webcasters
- Contact: (888) 689-5264

#### 2. SoundExchange — Sound Recording Performance Rights

SoundExchange is the **sole organization designated by US Congress** to collect and distribute digital performance royalties for sound recordings. This is separate from PRO payments.

**Key Facts:**
- Collects over $1 billion annually
- Distributes to 700,000+ artists and rights holders
- Required for all non-interactive digital streaming services
- Rates set by the Copyright Royalty Board (CRB)

**Current Webcasting Rates (CRB-established):**

| Type | Per-Performance Rate (2024-2028) |
|------|----------------------------------|
| Commercial Non-Subscription | ~$0.0024 per song per listener |
| Commercial Subscription | ~$0.0028 per song per listener |
| Non-Commercial Educational | Reduced rates available |
| Small Webcaster | Special provisions may apply |

**Minimum Fees:**
- $500/year per station or channel (minimum)
- $50,000 annual cap for services with 100+ channels

**Reporting Requirements:**
- Detailed playlists with artist, track, ISRC codes
- Listener counts per track
- AzuraCast and other software can generate SoundExchange-compatible reports

#### 3. Mechanical Licenses (If Applicable)

If your station creates recordings (podcasts featuring music, etc.), you may need mechanical licenses through:
- **Harry Fox Agency (HFA)**
- **Music Reports**
- The **Mechanical Licensing Collective (MLC)** — established by the Music Modernization Act

### Statutory License (Section 114/112)

Most internet radio stations operate under the **statutory license**, which provides:
- Automatic access to all commercially released sound recordings
- No need to negotiate individual licenses with labels
- Must comply with performance rules (e.g., sound recording performance complement)

**Performance Complement Rules:**
- No more than 3 songs from same album in 3-hour window
- No more than 4 songs from same artist in 3-hour window
- No more than 4 songs from same box set in 3-hour window
- No pre-announcement of specific songs

### International Considerations

If streaming internationally, additional licenses may be needed:
- **PRS for Music** (UK)
- **SOCAN** (Canada)
- **GEMA** (Germany)
- **SACEM** (France)

SoundExchange has collection agreements with 40+ international organizations.

---

## Technical Infrastructure Options

### Self-Hosted Solutions

#### 1. Icecast 2 (Open Source)

**Overview:** Free, open-source streaming media server supporting Ogg Vorbis, Opus, WebM, and MP3.

**Pros:**
- Completely free (GNU GPL v2)
- Highly customizable
- Active development (v2.5.0 released Dec 2025)
- Large community support
- Can be installed on any Linux server

**Cons:**
- Requires technical expertise
- No built-in automation/scheduling
- Need to manage your own infrastructure
- Bandwidth costs scale with listeners

**Requirements:**
- Linux VPS ($5-50/month for small stations)
- Source client (e.g., Liquidsoap, BUTT)
- Sufficient bandwidth

#### 2. Shoutcast DNAS (Free/Commercial)

**Overview:** Long-running streaming solution from Nullsoft/Winamp.

**Pros:**
- Easy setup
- Wide player compatibility
- Free version available
- Built-in monetization tools with Targetspot

**Cons:**
- Proprietary software
- Commercial features require payment
- Less flexibility than Icecast

#### 3. AzuraCast (Open Source — Recommended)

**Overview:** Self-hosted, all-in-one web radio management suite. Highly recommended for its comprehensive feature set.

**Pros:**
- **Free and open-source** (AGPL v3)
- **All-in-one solution**: streaming, automation, scheduling, analytics
- Built-in Liquidsoap AutoDJ
- Icecast-KH or Shoutcast as frontend
- **SoundExchange-compatible reporting**
- Multi-station administration
- Web-based DJ tool (no software needed)
- Listener request system
- Remote relay support
- Docker-based installation

**Cons:**
- Requires VPS/server management knowledge
- Self-managed infrastructure

**Key Features:**
- Rich media management and metadata editing
- Playlist scheduling (sequential, shuffled, scheduled)
- Live DJ accounts with streaming support
- Public pages and embeddable players
- Webhooks for Discord, Slack, Twitter, TuneIn
- Real-time and historical analytics
- Automatic nginx proxy (works with CloudFlare)
- S3-compatible storage support

**Recommended Hosting:**
- DigitalOcean ($10-40/month)
- Linode ($10-40/month)
- Vultr ($10-40/month)

#### 4. LibreTime (Open Source)

**Overview:** Radio broadcast and automation platform, successor to Airtime.

**Pros:**
- Free and open-source
- Designed for broadcast-quality operations
- Powerful library management
- Supports both AM/FM playout and internet streaming
- Show scheduling and podcast automation

**Cons:**
- More complex than AzuraCast
- Primarily designed for terrestrial broadcast integration
- Less active development than AzuraCast

### Managed/Cloud Services

#### 1. Live365

**Overview:** Pioneer of internet radio (founded 1999), offers managed streaming with licensing included.

**Key Features:**
- All US music licensing INCLUDED in plans
- No separate SoundExchange/PRO payments needed
- Directory listing on Live365 platform
- Apps for iOS, Android, Alexa

**Typical Pricing:** $59-299/month (licensing included)

**Best For:** Hobbyists and small stations who want simplicity

#### 2. RadioKing

**Overview:** European-based managed radio platform.

**Pricing Tiers:**
- **Discover:** Free trial, limited features
- **Start:** ~€9/month — 50 simultaneous listeners, real-time stats
- **Pro:** ~€29/month — Radio page, weekly reports
- **Business:** ~€59/month — Advanced normalization, premium features

**Note:** Does NOT include music licensing

**Best For:** European stations or those wanting affordable cloud hosting

#### 3. Radionomy

**Overview:** Free hosting with advertising-supported model.

**Pros:**
- Free streaming
- Monetization through ads

**Cons:**
- Ads played on your stream
- Less control over content
- May have catalog restrictions

#### 4. Triton Digital

**Overview:** Enterprise-grade streaming and monetization platform used by major broadcasters (CBS, Salem Media, iHeart).

**Features:**
- Enterprise streaming infrastructure
- Programmatic ad insertion
- Audience measurement (Webcast Metrics)
- Podcast metrics
- Audio marketplace (100+ billion impressions/month)

**Best For:** Large commercial operations, terrestrial stations going digital

**Pricing:** Enterprise/negotiated (typically $1,000+/month)

### Infrastructure Cost Comparison

| Solution | Monthly Cost | Licensing Included? | Technical Skill Required |
|----------|-------------|---------------------|--------------------------|
| Icecast + VPS | $5-100 | No | High |
| AzuraCast + VPS | $10-100 | No | Medium-High |
| Shoutcast + VPS | $5-100 | No | Medium |
| LibreTime + VPS | $10-100 | No | High |
| Live365 | $59-299 | **Yes** | Low |
| RadioKing | $9-59 | No | Low |
| Triton Digital | $1,000+ | No | Low (managed) |

---

## Programming & Scheduling Systems

### Radio Automation Software

#### 1. SAM Broadcaster Pro ($299 one-time)

**Overview:** Industry-leading Windows-based internet radio software, powering 200,000+ stations in 160 countries.

**Key Features:**
- Advanced audio processing (5-band compressor/limiter)
- Cross-fade detection and gap killer
- Beat matching and voice tracking
- Stream encoding (MP3, AAC, Ogg, etc.)
- Multi-format streaming (SHOUTcast, Icecast)
- Real-time listener statistics
- Media library management
- Amazon.com track lookup
- Dual deck operation
- Auto DJ functionality

**Pricing:** $299 (one-time) + optional cloud add-ons

**Best For:** Serious hobbyists and semi-professional stations on Windows

#### 2. RadioDJ (Free)

**Overview:** Free Windows-based radio automation software.

**Features:**
- Playlist automation
- Live assist mode
- Track rotation rules
- Basic audio processing

**Pros:** Free, capable for basic needs
**Cons:** Windows-only, fewer features than paid alternatives

#### 3. Liquidsoap (Free/Open Source)

**Overview:** Powerful audio streaming language and tool, often used as the AutoDJ engine in AzuraCast.

**Features:**
- Programmable audio scripting
- Multiple input sources
- Cross-fading and transitions
- Dynamic playlist generation

**Best For:** Technical users wanting maximum flexibility

#### 4. PlayIt Live (Free/Paid)

**Overview:** Professional radio playout software for Windows.

**Tiers:**
- Free version with basic features
- Pro version (~$200) with advanced scheduling

### Cloud-Based Scheduling

#### 1. AzuraCast (Built-in)

- Web-based playlist management
- Scheduled playlists (time-based, rotation-based)
- Jingle/sweeper rotation
- Voice tracking upload
- Listener request integration

#### 2. Centova Cast ($3-15/month per station)

- Control panel for streaming servers
- Playlist scheduling
- Auto DJ
- Statistics and reporting

### Content Scheduling Best Practices

1. **Dayparting:** Schedule different content for morning, afternoon, evening
2. **Rotation Rules:** Balance new releases with library tracks
3. **Clock Formats:** Traditional radio "hot clocks" for consistent sound
4. **Voice Tracking:** Pre-record DJ breaks for automated playback
5. **Live Events:** Plan for special programming (artist interviews, etc.)

---

## Revenue Models & Monetization

### 1. Advertising

#### Pre-Roll/Mid-Roll Audio Ads

**Types:**
- **Live-read:** DJ announces sponsors
- **Pre-recorded spots:** 15-60 second commercials
- **Programmatic insertion:** Automated ad placement via platforms like Triton's TAP

**Revenue Potential:**
- CPM (Cost Per Mille): $2-25 per 1,000 impressions
- Higher rates for targeted demographics
- Music format typically commands lower CPMs than talk

**Platforms:**
- **Targetspot** (via Shoutcast)
- **Triton Digital Audio Marketplace**
- **AdsWizz**
- **Direct sales** to local businesses

#### Display/Banner Ads

- Website companion ads
- Mobile app banner ads
- Lower revenue than audio ($0.50-5 CPM)

### 2. Sponsorship

**Types:**
- **Program sponsorship:** "This hour brought to you by..."
- **Station sponsorship:** Naming rights, major branding
- **Event sponsorship:** Live broadcasts, concerts

**Pricing:** Negotiated, typically monthly/annual contracts
- Small stations: $100-500/month
- Medium stations: $500-2,500/month
- Large operations: $5,000+/month

### 3. Subscription/Premium Tiers

**Models:**
- **Ad-free listening:** $4.99-9.99/month
- **High-quality streams:** 320kbps vs 128kbps
- **Exclusive content:** Shows, interviews, early access
- **Merchandise bundles:** Subscription + swag

**Platforms for Subscriptions:**
- Patreon
- Memberful
- Custom integration

### 4. Listener Donations

**Platforms:**
- PayPal donations
- Ko-fi
- Buy Me a Coffee
- Cryptocurrency

**Best Practices:**
- Regular donation drives
- Donor recognition (on-air shoutouts)
- Tiered rewards

### 5. Merchandise

- Branded apparel
- Stickers, mugs, accessories
- Artist collaboration items

**Fulfillment Options:**
- Print-on-demand (Printful, Printify)
- Self-managed inventory

### 6. Affiliate Revenue

- Amazon affiliate links for featured music
- Music equipment recommendations
- Streaming service referrals

**AzuraCast Note:** Built-in support for generating music purchase links with affiliate tracking.

### 7. Live Events

- Virtual concerts
- Meet and greets
- Festival partnerships

### Revenue Benchmarks

| Station Size | Monthly Listeners | Potential Monthly Revenue |
|--------------|-------------------|---------------------------|
| Hobby | < 1,000 | $0-200 (donations) |
| Small | 1,000-10,000 | $200-2,000 |
| Medium | 10,000-100,000 | $2,000-20,000 |
| Large | 100,000+ | $20,000+ |

---

## Costs & Ongoing Fees

### Startup Costs

| Item | One-Time Cost |
|------|---------------|
| Computer/Studio Equipment | $500-5,000 |
| Microphone + Audio Interface | $200-1,000 |
| Software (SAM Broadcaster, etc.) | $0-500 |
| Website/Domain | $50-200 |
| Legal/Business Formation | $200-1,000 |
| **Total Startup (Minimal)** | **$950-7,700** |

### Annual Operating Costs

#### Small Operation (< 5,000 listeners/month)

| Expense | Annual Cost |
|---------|-------------|
| VPS Hosting (AzuraCast) | $120-480 |
| ASCAP License | $500-1,000 |
| BMI License | $500-1,000 |
| SESAC License | $500+ (negotiated) |
| SoundExchange | $500 minimum + per-play |
| Domain/SSL | $50-100 |
| Misc. Software | $100-300 |
| **Total (Self-Hosted)** | **$2,270-3,380+** |

*Alternative: Live365 all-inclusive at $708-3,588/year*

#### Medium Operation (10,000-50,000 listeners/month)

| Expense | Annual Cost |
|---------|-------------|
| Hosting/CDN | $1,200-6,000 |
| ASCAP | $1,500-5,000 |
| BMI | $1,500-5,000 |
| SESAC/GMR | $1,000-3,000 |
| SoundExchange | $2,000-15,000 |
| Staff/Contractors | $0-24,000 |
| Marketing | $1,200-6,000 |
| **Total** | **$8,400-64,000** |

#### Large Commercial Operation (100,000+ listeners)

| Expense | Annual Cost |
|---------|-------------|
| Enterprise Streaming (Triton) | $12,000-50,000 |
| PRO Licenses (all) | $10,000-50,000 |
| SoundExchange | $20,000-200,000+ |
| Full-time Staff | $100,000-500,000 |
| Marketing/Promotion | $24,000-100,000 |
| Office/Studio Space | $12,000-60,000 |
| Legal/Accounting | $10,000-30,000 |
| **Total** | **$188,000-990,000+** |

### SoundExchange Cost Calculation Example

**Scenario:** 10,000 average listeners, 15 songs/hour, 24/7 operation

```
Monthly plays = 10,000 listeners × 15 songs/hour × 730 hours
             = 109,500,000 performances

Monthly cost = 109,500,000 × $0.0024
             = $262,800/month ← This can't be right!
```

**Reality Check:** Actual listener hours are typically much lower. A station averaging 100 concurrent listeners 24/7:

```
Monthly performances = 100 × 15 × 730 = 1,095,000
Monthly cost = 1,095,000 × $0.0024 = $2,628
Annual cost = ~$31,536 + $500 minimum = ~$32,000
```

---

## Business Structure Considerations

### Option 1: Standalone Internet Radio Company

**Pros:**
- Full creative control
- Direct listener relationships
- Flexible programming
- Can build brand independently

**Cons:**
- High licensing overhead
- Need to negotiate all licenses individually
- Limited leverage with PROs
- All costs borne by single entity
- Complex compliance requirements

**Best For:** Niche formats, community radio, passion projects

### Option 2: Division of Music Licensing Company

**Significant Strategic Advantages:**

#### Licensing Synergies

1. **Bulk Negotiating Power**
   - Volume discounts on PRO licenses
   - Better SoundExchange rate positions
   - Existing relationships with rights holders

2. **Simplified Compliance**
   - Existing license management infrastructure
   - Staff already trained on music rights
   - Reporting systems in place

3. **Catalog Access**
   - Potential for direct licensing deals
   - Access to independent/unsigned content
   - First-look at new releases

#### Operational Synergies

1. **Shared Infrastructure**
   - IT systems
   - Legal/compliance teams
   - Marketing resources

2. **Data Advantages**
   - Listening data informs licensing decisions
   - Cross-promotional opportunities
   - Artist relationship development

3. **Revenue Diversification**
   - Licensing fees
   - Streaming revenue
   - Advertising
   - Data/analytics services

#### Financial Considerations

| Factor | Standalone | Licensing Division |
|--------|------------|-------------------|
| License Costs | Full retail | Potential discounts |
| Compliance Staff | Must hire | Shared resource |
| Legal Expertise | Must hire | Existing team |
| Startup Capital | Higher | Potentially lower |
| Revenue Sharing | 100% retained | Internal allocation |
| Risk | Concentrated | Diversified |

### Recommendation: Division Structure

**For a music licensing company**, launching an internet radio division makes strategic sense:

1. **Reduced marginal licensing costs** — Existing PRO relationships
2. **Compliance infrastructure exists** — Minimal additional overhead
3. **Market insight** — Real-world listening data
4. **Artist relationships** — Showcase for represented artists
5. **Technology synergies** — Shared platforms possible
6. **Brand extension** — Reinforces music expertise

**Implementation Path:**
1. Start with small test station using AzuraCast
2. License through existing company agreements
3. Test monetization with small ad/sponsorship deals
4. Scale based on listener growth and revenue
5. Expand to multiple format stations if successful

---

## Conclusion & Recommendations

### Starting Small: Recommended Stack

For a music licensing company testing internet radio:

| Component | Recommendation | Cost |
|-----------|----------------|------|
| Streaming | AzuraCast on DigitalOcean | $20/month |
| AutoDJ | Liquidsoap (built-in) | Free |
| CDN | Cloudflare (free tier) | Free |
| Licensing | Through parent company | Varies |
| Analytics | AzuraCast built-in | Free |
| Mobile | Web-based player initially | Free |

**Total Infrastructure: ~$240/year**

### Growth Path

1. **Phase 1 (0-6 months):** 
   - Launch single format station
   - Build audience organically
   - Test ad insertion
   - Target: 1,000 regular listeners

2. **Phase 2 (6-12 months):**
   - Add second format
   - Launch mobile apps
   - Secure first sponsors
   - Target: 5,000 regular listeners

3. **Phase 3 (12-24 months):**
   - Multiple stations/formats
   - Programmatic ad platform
   - Premium subscription tier
   - Target: 25,000+ regular listeners

### Key Success Factors

1. **Unique Programming** — Differentiate from Spotify/Apple Music
2. **Community Building** — Engage listeners beyond just streaming
3. **Quality Audio** — 128kbps minimum, 192-320kbps preferred
4. **Reliable Uptime** — 99.9%+ availability
5. **Mobile-First** — Apps for iOS/Android
6. **Smart Promotion** — Leverage parent company relationships

### Final Verdict

**Should a music licensing company launch an internet radio division?**

**YES** — With the following conditions:

- ✅ Start small with minimal investment
- ✅ Leverage existing licensing infrastructure
- ✅ Focus on unique programming that complements licensing business
- ✅ Build slowly, validating revenue at each stage
- ✅ Consider it a 2-3 year strategic investment
- ⚠️ Don't expect profitability in Year 1
- ⚠️ Plan for licensing costs to scale with success

The synergies between music licensing and internet radio are substantial, making the division model significantly more viable than standalone operation.

---

## Appendix: Resource Links

### Licensing Organizations
- ASCAP: https://www.ascap.com/music-users
- BMI: https://www.bmi.com/licensing
- SESAC: https://www.sesac.com/licensing
- SoundExchange: https://www.soundexchange.com
- Global Music Rights: https://globalmusicrights.com/licensing

### Technical Platforms
- AzuraCast: https://azuracast.com
- Icecast: https://icecast.org
- Shoutcast: https://shoutcast.com
- LibreTime: https://libretime.org

### Managed Services
- Live365: https://live365.com
- RadioKing: https://radioking.com
- Triton Digital: https://tritondigital.com

### Automation Software
- SAM Broadcaster: https://spacial.com/sam-broadcaster-pro
- RadioDJ: https://www.radiodj.ro
- PlayIt Live: https://www.playitsoftware.com

---

*Document prepared for Mi Amigos AI — February 2026*
