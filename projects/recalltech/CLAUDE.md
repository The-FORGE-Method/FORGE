# RecallTech BOLO Platform

**AI-powered BOLO collaboration for law enforcement and retail loss prevention**

---

## How to Work with This Project

> *I'm your FORGE guide. Tell me what you want to do and I'll help you get there.*

### Quick Start

| You Say | What Happens |
|---------|-------------|
| "What's next?" or "Catch me up" | I show you project status and next steps |
| "I have a new feature idea" | I guide you through discovery submission |
| "How should this be architected?" | I route to architecture planning |
| "Start coding" or "Ship it" | I coordinate implementation |

**Precision addressing:** Use `@role` for direct access (e.g., `@G catch me up`, `@E ship it`).

---

## Project Identity

### What This Is
RecallTech BOLO is an AI-powered collaboration platform that replaces fragmented BOLO distribution (emails, GroupMe, paper binders) with a secure, real-time system for law enforcement and retail loss prevention.

### Key Features (MVP)
- BOLO creation via form, voice, or document scan
- AI field extraction (Whisper + GPT-4)
- Full-text search with advanced filters
- Rule-based related BOLO suggestions
- Collaboration (comments, @mentions, followers)
- Notifications (in-app, email, SMS for critical)
- Retail-LE bridge with configurable sharing
- Admin panels with audit logging

### Who This Is For
- **Primary users:** Police departments, retail loss prevention teams
- **Stakeholders:** RecallTech (Antonio, TJ), Mi Amigos AI (Leo, Carlos)

---

## Contract Summary

| Term | Value |
|------|-------|
| Development Timeline | 16 weeks (12 target + 4 contingency) |
| Equity | 7% |
| Cash at Series A | $500,000 |
| Operating Compensation | 20% of Gross Revenue |
| Test Coverage | 80%+ |
| Load Testing | 100+ concurrent users |

---

## Current Phase

**Phase:** Execute (MVP development)  
**Week:** 1 of 16 (started Feb 5, 2026)

### Priority
**🔥 HIGHEST PRIORITY until MVP delivered**

---

## Documentation

| Document | Location |
|----------|----------|
| Product Vision | OneDrive: `Mi Amigos AI/Projects/RECALL TECH/Product/01_Product_Vision.docx` |
| MVP Scope | OneDrive: `Mi Amigos AI/Projects/RECALL TECH/Product/06_MVP_Scope_Summary.docx` |
| Contract Deliverables | OneDrive: `Mi Amigos AI/Projects/RECALL TECH/Product/09_Contract_Deliverables.md` |
| Decisions Log | OneDrive: `Mi Amigos AI/Projects/RECALL TECH/Product/07_Decisions_Log.md` |
| Future Phases | OneDrive: `Mi Amigos AI/Projects/RECALL TECH/RecallTech-Future-Phases.md` |

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js + React + TypeScript |
| Backend | Next.js API routes + Supabase |
| Database | PostgreSQL (Supabase) |
| Auth | Supabase Auth + 2FA |
| AI | OpenAI (GPT-4, Whisper) |
| Storage | Supabase Storage |
| Hosting | Vercel |

---

## User Roles (10 Total)

### Law Enforcement (7)
1. Super Admin (RecallTech internal)
2. PD Admin (Department administrator)
3. Supervisor (Sergeant/Lieutenant)
4. Detective/Investigator
5. Officer (Patrol)
6. Analyst (Crime/Intel)
7. Read-Only Viewer

### Retail Loss Prevention (3)
1. Retail Admin (Corporate)
2. Regional LP Manager
3. Store LP Staff

---

## Verification

```bash
# Sacred Four (must pass before merge)
npm run typecheck
npm run lint
npm run test
npm run build
```

---

## Non-Negotiables

1. **80%+ test coverage** — Contract requirement
2. **100+ concurrent users** — Load testing required
3. **Security audit** — No critical vulnerabilities
4. **CJIS compliance** — Law enforcement data handling

---

## FORGE Canon Reference

This project operates under **The FORGE Method™**.

**Gate artifact:** `abc/FORGE-ENTRY.md` (to be created)

> **Rule:** Methodology questions → consult FORGE canon in `method/core/`

---

*RecallTech: Replacing fragmented BOLO distribution with intelligent collaboration.*
