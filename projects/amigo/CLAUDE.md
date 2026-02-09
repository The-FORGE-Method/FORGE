# Amigo

**AI Teammate Platform for Organizations**

> Every organization deserves an AI teammate that knows the company, serves the mission, has integrity, enables everyone, and grows with you.

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
Amigo is the AI teammate platform. It provides:
- **Core runtime** — Forked from OpenClaw, rebranded as Amigo
- **Mobile app** — E2E encrypted React Native interface
- **Web platform** — Organization dashboard and management

### What This Is NOT
- Not a chatbot — Amigo is a teammate with memory, personality, and agency
- Not a single-user tool — Built for organizations with roles and teams
- Not a wrapper — Deep integrations and customization

### Who This Is For
- **Primary:** Organizations wanting an AI teammate
- **Secondary:** Developers building on the platform
- **Stakeholders:** Mi Amigos AI founders and investors

---

## Monorepo Structure

```
amigo/
├── packages/
│   ├── core/           # Amigo runtime (forked OpenClaw)
│   │   ├── openclaw/   # The rebranded fork
│   │   └── docs/       # Architecture, security, vault docs
│   ├── mobile/         # React Native app (Expo)
│   │   └── ...         # E2E encryption, UI Control Channel
│   └── platform/       # Next.js web platform
│       └── ...         # Supabase, dashboard, API
├── docs/
│   └── constitution/
│       ├── PRODUCT.md  # Product intent
│       ├── TECH.md     # Technical architecture
│       └── GOVERNANCE.md
├── abc/                # FORGE pre-lifecycle artifacts
└── inbox/              # Feature requests
```

---

## Current Phase

**Phase:** Execute (MVP development)

### Active Work
| Package | Focus | Status |
|---------|-------|--------|
| **core** | Rebrand complete, memory layer next | 🟡 In Progress |
| **mobile** | E2E encryption (PR #2), UI Control (PR #1) | 🟡 In Progress |
| **platform** | Supporting APIs | 🟡 In Progress |

### Open PRs
| PR | Package | Feature |
|----|---------|---------|
| #1 | mobile | UI Control Channel |
| #2 | mobile | E2E Encryption Layer |
| rebrand/amigo | core | OpenClaw → Amigo rebrand |

---

## Key Documents

| Document | Location |
|----------|----------|
| Security Architecture | `packages/core/docs/SECURITY-ARCHITECTURE.md` |
| Amigo Vault | `packages/core/docs/AMIGO-VAULT.md` |
| Mobile App | `packages/core/docs/MOBILE-APP.md` |
| Architecture Roadmap | `packages/core/docs/ARCHITECTURE-ROADMAP.md` |

---

## Commands

### Development

```bash
# Core (Amigo runtime)
cd packages/core/openclaw
npm install
npm run build
./amigo.mjs gateway start

# Mobile
cd packages/mobile
npm install
npx expo start

# Platform
cd packages/platform
npm install
npm run dev
```

### Verification

```bash
# Mobile
cd packages/mobile
npx tsc --noEmit && npx expo lint

# Platform
cd packages/platform
npm run typecheck && npm run lint
```

---

## Non-Negotiables

1. **Zero-knowledge security** — Server never sees plaintext
2. **E2E encryption** — All communications encrypted
3. **User-controlled keys** — Keys never leave device
4. **FORGE governance** — Human greenlight for all decisions

---

## FORGE Canon Reference

This project operates under **The FORGE Method™**.

**Gate artifact:** `abc/FORGE-ENTRY.md` (when created)

> **Rule:** Methodology questions → consult FORGE canon in `method/core/`

---

*Amigo: The heart, soul, brain, and operating system for organizations.*
