# FORGE-ENTRY.md — RecallTech BOLO Platform

**Committed:** February 9, 2026  
**Phase:** Execute (MVP Development)  
**Week:** 1 of 16

---

## Project Identity

**Name:** RecallTech BOLO Platform  
**Codename:** recalltech  
**Repository:** [Mi-Amigos-AI/recalltech-bolo](https://github.com/Mi-Amigos-AI/recalltech-bolo)

---

## Problem Statement

Law enforcement agencies and retail loss prevention teams distribute BOLOs (Be On the Lookout alerts) through fragmented channels — GroupMe, Signal, email, paper binders. Intelligence gets lost. Officers experience BOLO fatigue. The 20% of offenders who cause 70% of loss slip through.

---

## Solution

An AI-powered collaboration platform that:
- Unifies BOLO management with lifecycle tracking
- Enables voice and document-scan BOLO creation via AI extraction
- Bridges retail LP and law enforcement with configurable sharing
- Provides real-time collaboration, search, and notifications

---

## Locked Scope (MVP)

### Core Features
1. **Authentication** — Email/password + 2FA (authenticator app)
2. **Organization Management** — Multi-org (PD + Retail), user invitation, roles
3. **BOLO Creation** — Web form, voice input (Whisper), document scan (OCR + GPT-4)
4. **Search & Discovery** — Full-text search, filters, related BOLO suggestions
5. **Collaboration** — Comments, @mentions, followers, collaborator permissions
6. **Notifications** — In-app inbox, email, SMS for critical alerts
7. **Retail-LE Bridge** — Configurable cross-org sharing
8. **Admin Panels** — Super Admin, PD Admin, Retail Admin dashboards
9. **Audit Logging** — All sensitive actions logged, CJIS compliance ready

### Explicitly NOT in MVP
- Native mobile apps (iOS/Android)
- ML-based pattern matching
- RMS/CAD integrations
- Advanced analytics dashboards
- Offline mode

---

## Contract Terms

| Term | Value |
|------|-------|
| Timeline | 16 weeks (12 target + 4 contingency) |
| Equity | 7% |
| Cash (Series A) | $500,000 |
| Operating Comp | 20% of Gross Revenue |
| Test Coverage | 80%+ required |
| Load Testing | 100+ concurrent users |

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 14 + TypeScript + Tailwind CSS |
| Backend | Supabase (PostgreSQL, Auth, Realtime, Storage) |
| AI | OpenAI GPT-4 (extraction), Whisper (transcription) |
| Vector DB | pgvector (Supabase) for similarity search |
| Hosting | Vercel |
| SMS | Twilio (pending) |

---

## Infrastructure Status

| Component | Status |
|-----------|--------|
| GitHub Repo | ✅ `Mi-Amigos-AI/recalltech-bolo` |
| Supabase Project | ✅ `recall-tech-production` (gucvgkisktmgkqmppqfe) |
| Database Schema | ✅ Deployed (migrations applied) |
| Next.js Scaffold | ✅ In `src/` |
| Environment Vars | ✅ `.env.local` configured |
| Vercel Deployment | ⏳ Pending |
| Stripe Products | ⏳ Pending |

---

## Stakeholders

### Mi Amigos AI (Development Partner)
- **Leonard Knight** — CTO, Technical Lead
- **Jeff Dobson** — CEO
- **Carlos de Almeida** — COO

### Recall Tech Inc. (Client)
- **Antonio Hudson** — CEO
- **TJ Herring** — Advisor

---

## Success Criteria

1. All MVP features implemented and functional
2. 80%+ automated test coverage
3. Security audit passed (no critical vulnerabilities)
4. 100+ concurrent user capacity (load tested)
5. Documentation complete (API, user guide, admin guide)
6. Memphis pilot environment deployed

---

## Key Documents

| Document | Location |
|----------|----------|
| NORTHSTAR | `src/NORTHSTAR.md` |
| MVP Spec v2.0 | OneDrive: `Nashville 2026-02-04/_Reference/Recall Tech BOLO Platform MVP v2.0.docx` |
| Competitive Analysis | OneDrive backup: `RECALL TECH/Research/LP_Software_Competitive_Analysis.md` |
| Database Schema | `src/supabase/migrations/20260209000001_initial_schema.sql` |

---

## FORGE Lifecycle

```
[✓] @A Acquire — Project scaffolded
[✓] @B Brief — Requirements clarified (MVP spec locked)
[✓] @C Commit — Scope locked, entry created
[ ] @F Frame — Architecture decisions
[ ] @O Orchestrate — Build plan, database design, waypoints
[ ] @R Refine — Iteration cycles
[ ] @G Govern — Quality gates, reviews
[ ] @E Execute — Implementation sprints
```

**Next:** Run `@F` to frame architecture decisions, then `@O` to orchestrate the build plan.

---

*Gate unlocked. FORGE lifecycle active.*
