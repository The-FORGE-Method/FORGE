# FORGE Projects

This directory contains all FORGE-governed projects for Mi Amigos AI.

## Active Projects

| Project | Description | Status |
|---------|-------------|--------|
| **amigo** | AI Teammate Platform (core + mobile + web) | 🔨 In Development |
| **recalltech** | RecallTech BOLO Platform (MVP) | 🔨 In Development |

## Project Structure

Each project follows the FORGE lifecycle:

```
projects/<slug>/
├── abc/                    # Pre-FORGE: Acquire, Brief, Commit
│   ├── INTAKE.md          # @A output
│   ├── BRIEF.md           # @B output (optional)
│   └── FORGE-ENTRY.md     # @C output (gate artifact)
├── docs/
│   └── constitution/
│       ├── PRODUCT.md     # Product intent
│       ├── TECH.md        # Technical architecture
│       └── GOVERNANCE.md  # Project governance
├── inbox/                  # Feature requests
├── packages/               # Source code (for monorepos)
│   └── <package>/
├── src/                    # Source code (for single-package projects)
└── tests/                  # Tests
```

## Monorepo vs Single-Repo

- **amigo**: Monorepo with `packages/` (core, mobile, platform)
- **recalltech**: Single-repo with `src/`

---

*All projects governed by The FORGE Method™*
