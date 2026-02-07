# FORGE Project Template

This directory contains the scaffold for new FORGE-governed projects.

---

## Usage

### Quick Start

```bash
# From the FORGE repo root:
cp -r template/project/ projects/<your-project-name>/
cd projects/<your-project-name>/

# Or let @A handle it:
/forge-a
```

### After Copying

1. **Edit `CLAUDE.md`** — Replace `[CUSTOMIZE]` markers with your project values
2. **Fill constitutional docs** — `docs/constitution/PRODUCT.md`, `TECH.md`, `GOVERNANCE.md`
3. **Install dependencies** — `pnpm install`
4. **Run Sacred Four** — `pnpm typecheck && pnpm lint && pnpm test && pnpm build`

---

## What's Included

| Directory | Purpose |
|-----------|---------|
| `abc/` | A.B.C pre-FORGE scaffold (Acquire, Brief, Commit) |
| `docs/constitution/` | Product, Tech, and Governance documents |
| `docs/adr/` | Architecture Decision Records |
| `docs/parking-lot/` | Future work and known issues |
| `inbox/` | Feature request queue for the project |
| `src/` | Source code skeleton |
| `tests/` | Test skeleton |
| `.github/` | CI/CD workflow templates |

## Configuration Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project-level agent governance |
| `FORGE-AUTONOMY.yml` | Autonomy tier configuration |
| `package.json` | Dependencies and scripts |
| `tsconfig.json` | TypeScript configuration |
| `vitest.config.ts` | Unit test configuration |
| `playwright.config.ts` | E2E test configuration |

---

*For methodology documentation, see `method/`. For active projects, see `projects/`.*
