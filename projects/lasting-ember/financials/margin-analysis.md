# Lasting Ember - Margin Analysis

*Last Updated: January 2025*

## Executive Summary

This document analyzes gross margins per tier, break-even points, and the path to profitability for Lasting Ember's music licensing platform and Radio Station division.

---

## Part 1: Gross Margin by Subscription Tier

### 1.1 Revenue Waterfall (Per Subscriber)

```
Gross Revenue
  - Payment Processing (Stripe: 2.9% + $0.30)
  = Net Revenue
  - Artist Payout (50% of Net)
  = Gross Margin
  - Variable Costs (Infrastructure per user)
  = Contribution Margin
```

### 1.2 Creator Tier ($14.99/mo or $9.99/mo annual)

**Monthly Billing:**
| Line Item | Amount | % of Gross |
|-----------|--------|------------|
| Gross Revenue | $14.99 | 100% |
| Stripe Fees | ($0.73) | 4.9% |
| Net Revenue | $14.26 | 95.1% |
| Artist Payout (50%) | ($7.13) | 47.6% |
| **Gross Margin** | **$7.13** | **47.6%** |
| Variable Infra (~$0.50/user) | ($0.50) | 3.3% |
| **Contribution Margin** | **$6.63** | **44.2%** |

**Annual Billing ($9.99/mo = $119.88/yr):**
| Line Item | Amount/mo | % of Gross |
|-----------|-----------|------------|
| Gross Revenue | $9.99 | 100% |
| Stripe Fees (amortized) | ($0.32) | 3.2% |
| Net Revenue | $9.67 | 96.8% |
| Artist Payout (50%) | ($4.84) | 48.4% |
| **Gross Margin** | **$4.84** | **48.4%** |
| Variable Infra | ($0.50) | 5.0% |
| **Contribution Margin** | **$4.34** | **43.4%** |

### 1.3 Pro Tier ($29.99/mo or $19.99/mo annual)

**Monthly Billing:**
| Line Item | Amount | % of Gross |
|-----------|--------|------------|
| Gross Revenue | $29.99 | 100% |
| Stripe Fees | ($1.17) | 3.9% |
| Net Revenue | $28.82 | 96.1% |
| Artist Payout (50%) | ($14.41) | 48.1% |
| **Gross Margin** | **$14.41** | **48.1%** |
| Variable Infra (~$0.75/user) | ($0.75) | 2.5% |
| **Contribution Margin** | **$13.66** | **45.6%** |

**Annual Billing ($19.99/mo = $239.88/yr):**
| Line Item | Amount/mo | % of Gross |
|-----------|-----------|------------|
| Gross Revenue | $19.99 | 100% |
| Stripe Fees (amortized) | ($0.61) | 3.0% |
| Net Revenue | $19.38 | 97.0% |
| Artist Payout (50%) | ($9.69) | 48.5% |
| **Gross Margin** | **$9.69** | **48.5%** |
| Variable Infra | ($0.75) | 3.8% |
| **Contribution Margin** | **$8.94** | **44.7%** |

### 1.4 Business Tier ($49.99/mo or $39.99/mo annual)

**Monthly Billing:**
| Line Item | Amount | % of Gross |
|-----------|--------|------------|
| Gross Revenue | $49.99 | 100% |
| Stripe Fees | ($1.75) | 3.5% |
| Net Revenue | $48.24 | 96.5% |
| Artist Payout (50%) | ($24.12) | 48.3% |
| **Gross Margin** | **$24.12** | **48.3%** |
| Variable Infra (~$1.00/user) | ($1.00) | 2.0% |
| **Contribution Margin** | **$23.12** | **46.3%** |

**Annual Billing ($39.99/mo = $479.88/yr):**
| Line Item | Amount/mo | % of Gross |
|-----------|-----------|------------|
| Gross Revenue | $39.99 | 100% |
| Stripe Fees (amortized) | ($1.19) | 3.0% |
| Net Revenue | $38.80 | 97.0% |
| Artist Payout (50%) | ($19.40) | 48.5% |
| **Gross Margin** | **$19.40** | **48.5%** |
| Variable Infra | ($1.00) | 2.5% |
| **Contribution Margin** | **$18.40** | **46.0%** |

### 1.5 Enterprise Tier ($99+/mo custom)

**At $99/mo baseline:**
| Line Item | Amount | % of Gross |
|-----------|--------|------------|
| Gross Revenue | $99.00 | 100% |
| Stripe Fees | ($3.17) | 3.2% |
| Net Revenue | $95.83 | 96.8% |
| Artist Payout (50%) | ($47.92) | 48.4% |
| **Gross Margin** | **$47.92** | **48.4%** |
| Variable Infra (~$2.00/user) | ($2.00) | 2.0% |
| **Contribution Margin** | **$45.92** | **46.4%** |

### 1.6 Margin Summary Table

| Tier | Monthly Price | Contribution Margin | CM % |
|------|---------------|---------------------|------|
| Creator (monthly) | $14.99 | $6.63 | 44.2% |
| Creator (annual) | $9.99 | $4.34 | 43.4% |
| Pro (monthly) | $29.99 | $13.66 | 45.6% |
| Pro (annual) | $19.99 | $8.94 | 44.7% |
| Business (monthly) | $49.99 | $23.12 | 46.3% |
| Business (annual) | $39.99 | $18.40 | 46.0% |
| Enterprise | $99.00 | $45.92 | 46.4% |

**Key Insight:** Contribution margins are remarkably consistent (43-47%) across tiers due to the 50% artist revenue share dominating the cost structure.

---

## Part 2: Break-Even Analysis

### 2.1 Fixed Costs (Monthly)

| Category | Launch | 6 Months | 1 Year |
|----------|--------|----------|--------|
| Operations | $2,500 | $16,000 | $37,000 |
| Marketing | $500 | $15,000 | $50,000 |
| Legal/Compliance | $300* | $1,400 | $3,400 |
| Fixed Infrastructure | $100 | $500 | $2,000 |
| **Total Fixed Costs** | **$3,400** | **$32,900** | **$92,400** |

*Launch legal excludes one-time setup

### 2.2 Break-Even Subscribers

**Formula:**
```
Break-Even Subscribers = Fixed Costs / Weighted Average Contribution Margin
```

**Tier Mix Assumptions:**
| Tier | % of Subscribers | Weighted CM |
|------|------------------|-------------|
| Creator | 50% | $5.49 × 0.50 = $2.75 |
| Pro | 35% | $11.30 × 0.35 = $3.96 |
| Business | 12% | $20.76 × 0.12 = $2.49 |
| Enterprise | 3% | $45.92 × 0.03 = $1.38 |
| **Weighted Average CM** | 100% | **$10.58** |

*Using blended monthly/annual pricing (70% annual)

**Break-Even Calculation:**

| Stage | Fixed Costs | Avg CM | Break-Even Subs |
|-------|-------------|--------|-----------------|
| Launch | $3,400 | $10.58 | **322 subscribers** |
| 6 Months | $32,900 | $10.58 | **3,110 subscribers** |
| 1 Year | $92,400 | $10.58 | **8,733 subscribers** |

### 2.3 Break-Even Timeline

**Conservative Growth Scenario:**
| Month | Subscribers | Revenue | Fixed Costs | Net Income | Cumulative |
|-------|-------------|---------|-------------|------------|------------|
| 1 | 100 | $2,500 | $3,400 | ($1,860) | ($1,860) |
| 2 | 180 | $4,500 | $3,600 | ($440) | ($2,300) |
| 3 | 300 | $7,500 | $3,800 | $370 | ($1,930) |
| 4 | 500 | $12,500 | $8,000 | ($530) | ($2,460) |
| 5 | 800 | $20,000 | $12,000 | $340 | ($2,120) |
| 6 | 1,200 | $30,000 | $16,000 | $680 | ($1,440) |
| **7** | **1,800** | **$45,000** | **$20,000** | **$990** | **($450)** |
| **8** | **2,500** | **$62,500** | **$24,000** | **$2,420** | **$1,970** |

**Break-even achieved: Month 8** (cumulative cash flow positive)

### 2.4 Sensitivity Analysis

**Impact of Tier Mix on Break-Even:**

| Scenario | Weighted CM | Break-Even (at $32,900) |
|----------|-------------|-------------------------|
| Base case | $10.58 | 3,110 subs |
| More Pro/Business | $12.50 | 2,632 subs |
| More Creator | $8.00 | 4,113 subs |
| Enterprise-heavy | $15.00 | 2,193 subs |

**Impact of Churn on Break-Even:**

| Monthly Churn | Annual Retention | LTV Impact |
|---------------|------------------|------------|
| 3% | 69% | Baseline |
| 5% | 54% | LTV -22% |
| 8% | 38% | LTV -45% |
| 10% | 28% | LTV -59% |

---

## Part 3: Radio Station Margins

### 3.1 Free Tier (Ad-Supported)

**Per User Economics:**
| Metric | Value |
|--------|-------|
| Avg listening: 15 hours/month | |
| Ads per hour: 4 | |
| Total ad impressions: 60 | |
| CPM (audio): $18 | |
| **Revenue/user/month** | **$1.08** |
| Bandwidth cost: 0.9 GB × $0.05 | ($0.05) |
| Infrastructure allocation | ($0.10) |
| **Contribution Margin** | **$0.93** |
| **CM %** | **86.1%** |

### 3.2 Premium Tier ($4.99/mo)

| Line Item | Amount | % |
|-----------|--------|---|
| Gross Revenue | $4.99 | 100% |
| Stripe Fees | ($0.44) | 8.9% |
| Net Revenue | $4.55 | 91.1% |
| Bandwidth (2 GB × $0.05) | ($0.10) | 2.0% |
| Infrastructure | ($0.15) | 3.0% |
| **Contribution Margin** | **$4.30** | **86.2%** |

### 3.3 Premium vs Free Comparison

| Metric | Free (Ad) | Premium | Premium is... |
|--------|-----------|---------|---------------|
| Revenue/user | $1.08 | $4.99 | 4.6x higher |
| CM/user | $0.93 | $4.30 | 4.6x higher |
| Retention | Lower | Higher | Better |
| User Experience | Ads | No ads | Better |

**Implication:** Aggressively convert free to premium; each conversion = ~4x revenue

### 3.4 Radio Station Break-Even

**Fixed Costs:**
| Category | 10K Subs | 100K Subs |
|----------|----------|-----------|
| Operations | $1,500 | $6,000 |
| Fixed Infrastructure | $800 | $3,000 |
| **Total** | **$2,300** | **$9,000** |

**Break-Even (80% free / 20% premium mix):**
```
Blended CM = (0.80 × $0.93) + (0.20 × $4.30) = $1.60/user
Break-even = $2,300 / $1.60 = 1,438 active listeners

At 100K scale:
Break-even = $9,000 / $1.60 = 5,625 active listeners
```

**Result:** Radio station is profitable at very low subscriber counts

---

## Part 4: Path to Profitability

### 4.1 Profitability Milestones

| Milestone | Subscribers | Monthly Revenue | Operating Profit | Status |
|-----------|-------------|-----------------|------------------|--------|
| Break-even | 3,000 | $75,000 | $0 | Month 6-8 |
| Sustainable | 10,000 | $250,000 | $50,000 | Month 12-15 |
| Profitable | 25,000 | $625,000 | $180,000 | Month 18-24 |
| Scale | 100,000 | $2,500,000 | $800,000 | Year 3+ |

### 4.2 Key Levers for Profitability

**1. Tier Upselling (Biggest Impact)**
- Moving users from Creator to Pro = +$5 CM/user
- Moving from Pro to Business = +$10 CM/user
- Target: 20% annual upsell rate

**2. Annual Conversion**
- Monthly users churn 2-3x more than annual
- Annual = better cash flow + lower effective churn
- Target: 70% annual, 30% monthly

**3. Churn Reduction**
- 1% churn reduction = ~15% LTV increase
- Invest in onboarding, engagement, content quality
- Target: <5% monthly churn

**4. Marketing Efficiency**
- Reduce CAC through organic/referral
- Target CAC:LTV ratio of 1:3 minimum
- At scale, CAC should be <$50

### 4.3 Unit Economics Target

**Healthy SaaS Benchmarks:**

| Metric | Our Target | Industry Median |
|--------|------------|-----------------|
| Gross Margin | 45-48% | 70-80%* |
| CAC:LTV Ratio | 1:3+ | 1:3+ |
| CAC Payback | <12 months | 12-18 months |
| Net Revenue Retention | 105%+ | 100-110% |
| Monthly Churn | <5% | 3-7% |

*Our gross margin is lower due to 50% artist share - this is intentional and a competitive advantage

### 4.4 Profitability Timeline

```
Year 1: Investment Phase
├── Months 1-6: Build catalog, acquire early users
├── Months 7-12: Reach break-even, optimize conversion
└── End of Year 1: 10,000 subscribers, $50K/mo profit

Year 2: Growth Phase
├── Scale marketing spend profitably
├── Launch enterprise tier
├── Expand radio station
└── End of Year 2: 50,000 subscribers, $200K/mo profit

Year 3: Scale Phase
├── International expansion
├── B2B/API revenue streams
├── Potential acquisition target
└── End of Year 3: 150,000 subscribers, $600K/mo profit
```

### 4.5 Risk Factors

| Risk | Impact | Mitigation |
|------|--------|------------|
| High churn | Delayed profitability | Focus on engagement, content quality |
| Low tier conversion | Lower ARPU | Invest in product value for Pro/Business |
| Artist exodus | Catalog depletion | Maintain fair payouts, buyout options |
| Competition | Price pressure | Differentiate on artist economics, UX |
| Copyright claims | Legal costs | Robust artist verification, insurance |

---

## Summary

**Key Takeaways:**

1. **Contribution margins are healthy (44-47%)** but capped by 50% artist share
2. **Break-even at ~3,000 subscribers** (Month 6-8)
3. **Radio station is highly profitable** due to zero licensing costs
4. **Path to $1M+ annual profit** at 25,000 subscribers
5. **Artist economics are a feature, not a bug** - drives catalog quality and differentiation
