<!-- Audience: Public -->

# FORGE Template: Handoff Protocols

**Version:** 1.0
**Status:** Operational Template
**For:** Human team handoff documentation
**Purpose:** Enable smooth transition from AI implementation to human ownership

---

## Overview

This template defines documentation requirements and handoff protocols for transitioning FORGE-built projects to human development teams.

**Key Principles:**
- **Documentation is required** — Projects ship with complete docs
- **Handoff success = team velocity** — Good docs enable fast onboarding
- **Architecture > implementation** — Explain "why" not just "what"
- **Living documentation** — Docs updated with code changes

---

## Table of Contents

1. [Required Documentation](#1-required-documentation)
2. [README Template](#2-readme-template)
3. [ARCHITECTURE Template](#3-architecture-template)
4. [ONBOARDING Template](#4-onboarding-template)
5. [ADR Template](#5-adr-template)
6. [Inline Documentation Standards](#6-inline-documentation-standards)
7. [Handoff Success Criteria](#7-handoff-success-criteria)

---

## 1. Required Documentation

### 1.1 Core Documentation Files

All FORGE SaaS projects must include these files before handoff to human team:

| File | Purpose | Audience | Update Frequency |
|------|---------|----------|------------------|
| **README.md** | Quick start, tech stack, Sacred Four | Developers (first read) | Every release |
| **ARCHITECTURE.md** | System design, data flow, key patterns | Developers (deep dive) | When architecture changes |
| **ONBOARDING.md** | Human team onboarding checklist | New team members | When process changes |
| **ADR-NNN-*.md** | Architecture Decision Records | Developers (context) | Per architectural decision |
| **GOVERNANCE.md** | Team roles, decision process, escalation | Team leads | When team changes |

### 1.2 Optional Documentation

| File | Purpose | When to Create |
|------|---------|----------------|
| **CONTRIBUTING.md** | Contribution guidelines | Open source projects |
| **API.md** | API reference documentation | Public API |
| **DEPLOYMENT.md** | Deployment runbook | Complex deployment |
| **TROUBLESHOOTING.md** | Common issues + fixes | Repeated support issues |

---

## 2. README Template

### 2.1 README Structure

**File:** `README.md`

```markdown
# Project Name

Brief description of the project (1-2 sentences).

## Overview

**What it does:** [User-facing description]
**Who it's for:** [Target audience]
**Key features:**
- Feature 1
- Feature 2
- Feature 3

## Tech Stack

**Frontend:**
- Next.js 15 (App Router)
- React 19 (Server Components)
- TypeScript (strict mode)
- Tailwind CSS v4
- Radix UI + shadcn/ui

**Backend:**
- Supabase Postgres (database)
- Supabase Auth (authentication)
- Supabase Storage (file uploads)
- Stripe (payments)

**Testing:**
- Vitest (unit + integration)
- Playwright (E2E)
- Coverage: 86% (threshold: 70%)

**Deployment:**
- Vercel (application)
- GitHub Actions (CI/CD)
- Supabase (database + auth)

## Quick Start

### Prerequisites

- Node.js 20+
- pnpm 8+
- Supabase account
- Vercel account (optional, for deployment)

### Installation

```bash
# Install dependencies
pnpm install

# Copy environment variables
cp .env.example .env.local

# Edit .env.local with your keys
# See "Environment Variables" section below

# Run development server
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000).

### Environment Variables

**Required:**

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key

# Stripe (if using payments)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_xxx
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx
```

See `.env.example` for all variables.

## Sacred Four

All PRs must pass the Sacred Four before merge:

```bash
pnpm typecheck  # TypeScript type checking
pnpm lint       # ESLint + Prettier
pnpm test       # Vitest with coverage (≥70%)
pnpm build      # Next.js production build
```

**Run all at once:**

```bash
pnpm sacred-four
```

## Testing

```bash
# Run unit + integration tests
pnpm test

# Run tests in watch mode
pnpm test --watch

# Run tests with coverage
pnpm test --coverage

# Run E2E tests (Playwright)
pnpm playwright test

# Run E2E tests with UI
pnpm playwright test --ui
```

## Project Structure

```
src/
├── app/              # Next.js App Router
│   ├── (auth)/      # Protected routes
│   ├── (public)/    # Public routes
│   └── api/         # API routes
├── components/
│   ├── ui/          # Base components (shadcn)
│   └── features/    # Feature components
├── lib/             # Utilities and integrations
├── hooks/           # Custom React hooks
└── types/           # TypeScript definitions

tests/
├── unit/            # Vitest unit tests
├── integration/     # API + DB tests
└── e2e/             # Playwright E2E tests

supabase/
├── migrations/      # SQL migrations
└── functions/       # Edge functions

docs/
├── adr/             # Architecture Decision Records
├── ARCHITECTURE.md  # System design
└── ONBOARDING.md    # Team onboarding
```

## Documentation

- **Architecture:** See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- **Onboarding:** See [docs/ONBOARDING.md](docs/ONBOARDING.md)
- **ADRs:** See [docs/adr/](docs/adr/)

## Deployment

**Preview deployments:**
- Automatic on PRs to `main`
- URL: `pr-<number>.staging.example.com`

**Production deployment:**
- Automatic on merge to `main`
- URL: `example.com`

See [.github/workflows/](.github/workflows/) for CI/CD configuration.

## Contributing

1. Create feature branch: `git checkout -b feat/feature-name`
2. Make changes and commit
3. Run Sacred Four: `pnpm sacred-four`
4. Push and create PR
5. Wait for CI validation + Human Lead approval
6. Merge to `main`

## License

[License type] - See LICENSE file.
```

---

## 3. ARCHITECTURE Template

### 3.1 ARCHITECTURE Structure

**File:** `docs/ARCHITECTURE.md`

```markdown
# Architecture Documentation

**Last Updated:** YYYY-MM-DD
**Status:** Current

---

## System Overview

### Purpose

[1-2 sentence description of what the system does]

### Key Stakeholders

- **End users:** [Description]
- **Admins:** [Description]
- **Developers:** [Description]

### High-Level Architecture

```
┌─────────────────────────────────────────────┐
│                 Frontend                    │
│  (Next.js App Router + React Server         │
│   Components)                               │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│           API Routes (Next.js)              │
│  (Server Actions + REST endpoints)          │
└────────────────┬────────────────────────────┘
                 │
    ┌────────────┼────────────┐
    ▼            ▼            ▼
┌────────┐  ┌─────────┐  ┌─────────┐
│Supabase│  │ Stripe  │  │  Edge   │
│Postgres│  │   API   │  │Functions│
└────────┘  └─────────┘  └─────────┘
```

---

## Technology Stack

### Why Next.js?

- **App Router:** Server Components reduce client JS bundle
- **Streaming SSR:** Progressive page rendering
- **Built-in API routes:** No separate backend needed
- **Vercel optimization:** Zero-config deployment

**Decision:** See ADR-001-use-nextjs.md

### Why Supabase?

- **Postgres + RLS:** Security built into database
- **Auth included:** OAuth + email/password
- **Real-time subscriptions:** Live updates
- **Edge functions:** Serverless close to database

**Decision:** See ADR-002-use-supabase.md

### Why TypeScript Strict Mode?

- **Type safety:** Catch errors at compile time
- **Better DX:** Autocomplete, refactoring
- **Documentation:** Types are executable docs

**Decision:** See ADR-003-typescript-strict.md

---

## Data Flow

### User Authentication Flow

```
1. User submits login form
   → POST /api/auth/login

2. API route validates credentials
   → supabase.auth.signInWithPassword()

3. Supabase returns session token
   → Set cookie with token

4. Redirect to /dashboard
   → Middleware verifies token
   → Server Component fetches user data
   → Page renders with user data
```

### Payment Flow (Stripe)

```
1. User clicks "Upgrade" button
   → POST /api/checkout

2. API route creates Stripe checkout session
   → stripe.checkout.sessions.create()

3. Redirect to Stripe checkout page
   → User enters payment info

4. Stripe redirects to success URL
   → /api/webhooks/stripe receives event

5. Webhook handler updates user subscription
   → supabase.from('subscriptions').update()

6. User sees updated plan in dashboard
```

---

## Key Design Patterns

### Server Components (Default)

**When to use:**
- Fetching data from database
- Rendering static content
- SEO-critical pages

**Example:**

```typescript
// app/dashboard/page.tsx
export default async function DashboardPage() {
  const supabase = createClient()
  const { data } = await supabase.from('properties').select('*')

  return <PropertyList properties={data} />
}
```

### Client Components (`'use client'`)

**When to use:**
- Interactive UI (forms, buttons)
- Browser APIs (localStorage, geolocation)
- React hooks (useState, useEffect)

**Example:**

```typescript
'use client'

import { useState } from 'react'

export function LoginForm() {
  const [email, setEmail] = useState('')
  // ...form logic
}
```

### Row-Level Security (RLS)

**Pattern:** All database access controlled by RLS policies

**Example policy:**

```sql
CREATE POLICY "Users can view own properties"
  ON public.properties
  FOR SELECT
  USING (auth.uid() = owner_id);
```

**Why:** Security enforced at database level, not application level.

### Zod Validation

**Pattern:** All API inputs validated with Zod schemas

**Example:**

```typescript
const createUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
})

const validatedData = createUserSchema.parse(requestBody)
```

**Why:** Type-safe validation with auto-generated TypeScript types.

---

## Security Considerations

### Authentication

- **Session tokens stored in HTTP-only cookies** (XSS protection)
- **Tokens verified on every request** (middleware + RLS)
- **Passwords hashed with bcrypt** (Supabase Auth handles this)

### Data Access

- **RLS policies enforce authorization** (users can only access own data)
- **Service role key never exposed to client** (server-only)
- **API routes validate user identity** (check auth.uid())

### Payment Security

- **Stripe webhook signatures verified** (prevents forged events)
- **Idempotency keys used** (prevents duplicate charges)
- **Payment data never stored** (Stripe handles card data)

---

## Database Schema

### Users

Managed by Supabase Auth (`auth.users` table).

### Properties

```sql
CREATE TABLE public.properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID NOT NULL REFERENCES auth.users(id),
  title TEXT NOT NULL,
  description TEXT,
  price INTEGER NOT NULL,
  location TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

**Indexes:**
- `properties_owner_id_idx` on `owner_id`
- `properties_created_at_idx` on `created_at DESC`

**RLS Policies:**
- Users can SELECT/INSERT/UPDATE/DELETE own properties only

### Subscriptions

```sql
CREATE TABLE public.subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  stripe_subscription_id TEXT UNIQUE NOT NULL,
  status TEXT NOT NULL, -- active, canceled, past_due
  plan TEXT NOT NULL,   -- free, pro, enterprise
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

---

## Performance Considerations

### Server Components Reduce Bundle Size

- Server Components don't ship to client
- Only client components add to JS bundle
- Result: Faster page loads

### Streaming SSR

- Page renders progressively
- Critical content shows first
- Slower data loads in background

### Database Indexes

- All foreign keys indexed
- Common query columns indexed
- `EXPLAIN ANALYZE` used to verify query performance

---

## Testing Strategy

### Test Pyramid

```
           /\
          /E2E\      ← 5% (critical user flows)
         /------\
        /  Int   \   ← 25% (API + DB)
       /----------\
      /    Unit    \ ← 70% (functions, components)
     /--------------\
```

### Coverage Requirements

- **Default:** 70% line coverage
- **Sacred Four paths:** 100% coverage (auth, payments, data integrity, security)

### Test Environments

- **Unit/Integration:** Supabase local (Docker)
- **E2E:** Supabase staging project
- **CI:** Supabase test project (dedicated)

---

## Deployment Architecture

### Environments

| Environment | Branch | Database | URL |
|-------------|--------|----------|-----|
| Development | Local | Local Docker | localhost:3000 |
| Staging | PR | Supabase staging | pr-N.staging.example.com |
| Production | main | Supabase prod | example.com |

### CI/CD Pipeline

```
PR created → Sacred Four (CI) → Deploy preview → Manual QA
                 ↓ pass
PR approved → Merge to main → Deploy production → Run migrations
```

---

## Future Considerations

### Scalability

- **Database:** Supabase scales to millions of rows; connection pooling handles concurrent users
- **Application:** Vercel serverless scales automatically
- **File uploads:** Supabase Storage uses CDN (Cloudflare)

### Monitoring

- **Error tracking:** [TBD: Sentry, LogRocket]
- **Performance:** [TBD: Vercel Analytics, Lighthouse CI]
- **Uptime:** [TBD: Uptime Robot, Pingdom]

### Technical Debt

- [ ] Add real-time subscriptions for live property updates
- [ ] Optimize image loading (blur placeholders)
- [ ] Add rate limiting to API routes
- [ ] Implement caching layer (Redis or Vercel KV)

---

## Appendix: Key Files

| File | Purpose |
|------|---------|
| `middleware.ts` | Auth verification, redirects |
| `lib/supabase/client.ts` | Browser Supabase client |
| `lib/supabase/server.ts` | Server Supabase client (SSR) |
| `app/api/webhooks/stripe/route.ts` | Stripe webhook handler |
| `.github/workflows/pr-validation.yml` | Sacred Four CI |

---

**Last Updated:** YYYY-MM-DD
```

---

## 4. ONBOARDING Template

### 4.1 ONBOARDING Structure

**File:** `docs/ONBOARDING.md`

```markdown
# Team Onboarding Checklist

Welcome! This guide will help you get up to speed on the project.

---

## Prerequisites

Before you begin, ensure you have:

- [ ] MacOS, Linux, or WSL2 (Windows)
- [ ] Node.js 20+ installed
- [ ] pnpm 8+ installed (`npm install -g pnpm`)
- [ ] Git configured with your name/email
- [ ] GitHub account with repo access
- [ ] Supabase account (for local development)
- [ ] Vercel account (optional, for deployment)

---

## Day 1: Setup

### 1. Clone Repository

```bash
git clone https://github.com/org/repo.git
cd repo
```

### 2. Install Dependencies

```bash
pnpm install
```

### 3. Setup Environment

```bash
# Copy example env file
cp .env.example .env.local

# Get keys from team lead or Supabase dashboard
# Edit .env.local with real values
```

### 4. Run Development Server

```bash
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000).

### 5. Run Sacred Four

```bash
pnpm typecheck  # Should pass
pnpm lint       # Should pass
pnpm test       # Should pass
pnpm build      # Should pass
```

**If anything fails, ask team lead for help.**

---

## Day 2: Codebase Tour

### 6. Read Documentation

- [ ] Read `README.md` — Quick start and tech stack
- [ ] Read `docs/ARCHITECTURE.md` — System design
- [ ] Skim `docs/adr/` — Architecture decisions

### 7. Explore Project Structure

```bash
src/
├── app/           # Next.js routes (start here)
├── components/    # React components
├── lib/           # Utilities (formatters, helpers)
└── hooks/         # Custom React hooks

tests/
├── unit/          # Fast, isolated tests
├── integration/   # API + DB tests
└── e2e/           # Full user flows

supabase/
├── migrations/    # Database schema changes
└── functions/     # Edge functions
```

### 8. Run Example Test

```bash
# Pick a test file and read it
cat tests/unit/lib/utils.test.ts

# Run just that test
pnpm test tests/unit/lib/utils.test.ts
```

### 9. Make a Trivial Change

```bash
# Create branch
git checkout -b feat/test-change

# Edit README.md (add your name to contributors)
# Commit
git add README.md
git commit -m "Add [Your Name] to contributors"

# Run Sacred Four
pnpm sacred-four

# Push (don't create PR yet)
git push -u origin feat/test-change
```

---

## Day 3: First Task

### 10. Pick a Starter Task

Ask team lead for a "good first issue" labeled task.

### 11. Read Handoff Packet

Handoff packets live in `ai_prompts/active/<task-id>/`.

Read:
- `handoff-packet.md` — What to build
- `task-brief.md` — Detailed requirements

### 12. Write Tests First (TDD)

```bash
# Create test file
touch tests/unit/lib/newFeature.test.ts

# Write failing test
# Implement feature
# Make test pass
```

### 13. Run Sacred Four

```bash
pnpm sacred-four
```

**Do NOT create PR if Sacred Four fails.**

### 14. Create PR

```bash
git push
gh pr create --title "Feat: [description]" --body "[details]"
```

Wait for CI validation + team lead review.

---

## Week 1: Best Practices

### 15. Code Style

- **TypeScript strict mode:** No `any` types
- **Tailwind CSS:** Use utility classes, not inline styles
- **Component naming:** PascalCase for components, camelCase for utilities
- **Import order:** React → Next → third-party → internal → relative

### 16. Testing

- **70% coverage minimum:** Run `pnpm test --coverage` to check
- **Sacred Four paths (auth, billing) need 100% coverage**
- **TDD preferred:** Write tests first when possible

### 17. Git Workflow

```bash
# Always create feature branch
git checkout -b feat/feature-name

# Commit often with clear messages
git commit -m "Add user profile form"

# Keep branch up to date with main
git fetch origin
git rebase origin/main

# Create PR only after Sacred Four passes
pnpm sacred-four && gh pr create
```

### 18. Getting Help

- **Stuck?** Ask team lead or post in #dev channel
- **Sacred Four fails?** Read error messages carefully
- **Test fails?** Run `pnpm test --watch` for interactive debugging
- **Architecture question?** Check `docs/ARCHITECTURE.md` first

---

## Month 1: Ownership

### 19. Own a Feature

By the end of month 1, you should:
- [ ] Complete 3+ tasks independently
- [ ] Write ADR for an architecture decision
- [ ] Review a teammate's PR
- [ ] Add a new test suite (unit or integration)

### 20. Contribute to Docs

Update documentation when you:
- Make architecture changes (update `ARCHITECTURE.md`)
- Add new patterns (create ADR in `docs/adr/`)
- Find unclear onboarding steps (update this file!)

---

## Resources

### Internal Docs

- **Architecture:** `docs/ARCHITECTURE.md`
- **ADRs:** `docs/adr/`
- **FORGE Method:** `method/` (if applicable)

### External Docs

- **Next.js:** https://nextjs.org/docs
- **Supabase:** https://supabase.com/docs
- **Vitest:** https://vitest.dev/
- **Playwright:** https://playwright.dev/

### Team Contacts

- **Team Lead:** [Name] — [Email/Slack]
- **Architecture Questions:** [Name] — [Email/Slack]
- **DevOps/Deployment:** [Name] — [Email/Slack]

---

**Welcome to the team! 🎉**
```

---

## 5. ADR Template

### 5.1 ADR Structure

**File:** `docs/adr/ADR-NNN-title.md`

```markdown
# ADR-NNN: [Title]

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded
**Deciders:** [Names]
**Related ADRs:** ADR-XXX, ADR-YYY

---

## Context

[Describe the problem or decision to be made. Include relevant background information.]

---

## Decision

[Describe the decision and the rationale for choosing it.]

---

## Alternatives Considered

### Alternative 1: [Name]

**Pros:**
- Pro 1
- Pro 2

**Cons:**
- Con 1
- Con 2

**Why rejected:** [Reason]

### Alternative 2: [Name]

**Pros:**
- Pro 1
- Pro 2

**Cons:**
- Con 1
- Con 2

**Why rejected:** [Reason]

---

## Consequences

### Positive

- Consequence 1
- Consequence 2

### Negative

- Consequence 1
- Consequence 2

### Neutral

- Consequence 1
- Consequence 2

---

## Implementation Notes

[Any notes about how to implement this decision, or migration steps if changing existing architecture.]

---

## References

- [Link 1]
- [Link 2]
```

### 5.2 ADR Example

**File:** `docs/adr/ADR-001-use-nextjs.md`

```markdown
# ADR-001: Use Next.js for Frontend Framework

**Date:** 2026-02-01
**Status:** Accepted
**Deciders:** Leo (Human Lead), Jordan (Product Strategist)
**Related ADRs:** None

---

## Context

We need to choose a frontend framework for our SaaS application. Requirements:
- Server-side rendering for SEO
- Fast page loads
- Easy deployment
- Good developer experience
- Strong ecosystem

---

## Decision

We will use **Next.js 15 with App Router** as our frontend framework.

---

## Alternatives Considered

### Alternative 1: Remix

**Pros:**
- Great DX
- Built-in form handling
- Strong server-side focus

**Cons:**
- Smaller ecosystem than Next.js
- Less mature (newer framework)
- Fewer deployment options

**Why rejected:** Smaller ecosystem and less mature tooling.

### Alternative 2: SvelteKit

**Pros:**
- Excellent performance
- Simple syntax
- Reactive by default

**Cons:**
- Smaller community
- Fewer component libraries
- Less TypeScript maturity

**Why rejected:** Smaller community and ecosystem.

---

## Consequences

### Positive

- **Vercel deployment:** Zero-config deployment to Vercel
- **Server Components:** Reduce client JS bundle size
- **Built-in API routes:** No separate backend needed
- **Strong ecosystem:** shadcn/ui, Radix UI, Tailwind CSS all work well

### Negative

- **Learning curve:** App Router is new, team must learn Server Components
- **Vendor lock-in:** Vercel-specific features (Edge Runtime) harder to migrate

### Neutral

- **Large bundle:** Next.js has larger initial bundle than alternatives
- **Complexity:** More concepts to learn (RSC, SSR, SSG, ISR)

---

## Implementation Notes

- Use App Router (not Pages Router)
- Prefer Server Components by default
- Add `'use client'` only when necessary (interactivity, hooks)

---

## References

- https://nextjs.org/docs
- https://vercel.com/docs
```

---

## 6. Inline Documentation Standards

### 6.1 JSDoc for Functions

```typescript
/**
 * Formats a number as USD currency.
 *
 * @param amount - The amount in cents (e.g., 1000 = $10.00)
 * @returns Formatted currency string (e.g., "$10.00")
 *
 * @example
 * ```ts
 * formatCurrency(1000) // "$10.00"
 * formatCurrency(-500) // "-$5.00"
 * ```
 */
export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  }).format(amount / 100)
}
```

### 6.2 Comments for Complex Logic

```typescript
// ✅ GOOD: Explains WHY, not WHAT
// Use service role key for admin operations (bypasses RLS)
const adminClient = createClient(supabaseUrl, serviceRoleKey)

// ❌ BAD: Explains WHAT (code already shows this)
// Create admin client
const adminClient = createClient(supabaseUrl, serviceRoleKey)
```

### 6.3 TODO Comments

```typescript
// TODO(username): Add pagination (issue #42)
const properties = await supabase.from('properties').select('*')

// FIXME(username): This query is slow (>2s), needs optimization
const users = await supabase.from('users').select('*, properties(*)')
```

---

## 7. Handoff Success Criteria

### 7.1 Pre-Handoff Checklist

Before handing off to human team:

**Documentation:**
- [ ] README.md complete with quick start
- [ ] ARCHITECTURE.md documents system design
- [ ] ONBOARDING.md provides team onboarding steps
- [ ] ADRs created for all major decisions
- [ ] Inline documentation for complex logic

**Code Quality:**
- [ ] Sacred Four passes (typecheck, lint, test, build)
- [ ] Coverage ≥70% (100% for Sacred Four paths)
- [ ] No console.log statements
- [ ] No TODOs without issue numbers

**Deployment:**
- [ ] CI/CD workflows configured
- [ ] Preview deployments working
- [ ] Production deployment successful
- [ ] Environment variables documented in .env.example

**Knowledge Transfer:**
- [ ] Architecture walkthrough completed
- [ ] Q&A session held with team
- [ ] First task assigned and guided
- [ ] Team can run Sacred Four independently

### 7.2 Handoff Metrics

**Successful handoff = team velocity maintained or increased**

| Metric | Target |
|--------|--------|
| **Time to first PR** | <3 days |
| **Sacred Four pass rate** | >90% |
| **Questions per week** | <5 (after week 1) |
| **First feature shipped** | <2 weeks |

### 7.3 Post-Handoff Support

**First week:**
- Daily check-ins
- Answer questions synchronously
- Pair programming on first task

**First month:**
- Weekly check-ins
- Review PRs with feedback
- Update docs based on team feedback

**After month 1:**
- Async support only
- Team fully autonomous

---

*This template defines handoff protocols for transitioning FORGE-built projects to human teams. Documentation is required.*

**Last Updated:** 2026-02-06
**Version:** 1.0
**Status:** Operational Template
