# FORGE Project Template

**A drop-in template for FORGE-governed software development projects.**

---

## Start Here If...

| You want to... | Go to... |
|----------------|----------|
| **Learn the FORGE methodology** | [FORGE Method](../../method/) (the canon) |
| **Start a new FORGE project** | Copy **this template** |

---

## What This Is (and Isn't)

**This IS:**
- The template you clone to start a new FORGE-governed project
- A pre-wired structure that *consumes* the FORGE methodology

**This is NOT:**
- The FORGE methodology itself (that's in the [method/](../../method/) directory)
- A place to redefine or extend FORGE concepts

> For FORGE methodology: [theforgemethod.org](https://theforgemethod.org)
> For FORGE canon: [method/](../../method/)

---

> **PROJECT SHELL** — Structure only. Awaiting constitutional documents before Execute is authorized.

---

## What You Get

When you clone this template:

- **CLAUDE.md** — Pre-wired for FORGE execution
- **Cursor rules** — SD (Implementation) and CC (Quality Gate) roles configured
- **Folder structure** — Matches FORGE rhythm exactly
- **Placeholders** — Constitutional docs ready for your inputs

**CC can scaffold immediately once you provide the constitution.**

---

## Quick Start

### 1. Clone the template

```bash
cp -r template/project/ [your-project]
cd [your-project]
git init
```

### 2. Customize CLAUDE.md

Replace `[CUSTOMIZE]` markers with your project values.

### 3. Provide constitutional documents

Populate these files in `docs/constitution/`:

| Document | Purpose |
|----------|---------|
| `PRODUCT.md` | Product intent, user value, success criteria |
| `TECH.md` | Technical architecture, stack decisions |
| `GOVERNANCE.md` | Security, permissions, policies |

### 4. Remove the PROJECT SHELL banner

Once constitution exists and Execute is authorized, remove the banner from this README.

### 5. Begin execution

CC can now scaffold and begin The FORGE Cycle.

---

## Project Structure

```
[project]/
├── CLAUDE.md                 # Project identity (pre-wired for FORGE)
├── .cursor/rules/
│   ├── forge-sd.mdc          # Implementation Engine rules
│   └── forge-cc.mdc          # Quality Gate rules
├── docs/
│   ├── constitution/         # REQUIRED inputs (read-only during Execute)
│   │   ├── PRODUCT.md
│   │   ├── TECH.md
│   │   └── GOVERNANCE.md
│   ├── parking-lot/          # Issues/ideas discovered but out of scope
│   ├── adr/                  # Architecture Decision Records
│   ├── ops/                  # Operational state
│   └── build-plan.md         # Execution state
├── inbox/                    # Inbox-driven workflow
│   ├── 00_drop/              # Discovery input (you write here)
│   ├── 10_product-intent/    # Product Strategist outputs
│   └── 20_architecture-plan/ # Project Architect outputs
├── src/                      # Application source
└── tests/                    # Test files
```

---

## What This Template Expects

### Inputs (you provide)

1. **Constitutional documents** — PRODUCT.md, TECH.md, GOVERNANCE.md
2. **Project identity** — Fill CLAUDE.md [CUSTOMIZE] sections
3. **Human Lead greenlight** — Authorize Execute phase

### Already configured

- Cursor rules for SD and CC roles
- File-based handoff structure
- Build plan template
- Task brief templates

---

## Agent Roles

| Role | Agent | What They Do |
|------|-------|--------------|
| Human Lead | You | Greenlight, merge, decide |
| Strategist | Jordan (ChatGPT) | Business strategy |
| Spec Author | CP (Claude Project) | Constitutional docs |
| Quality Gate | CC (Claude Code) | Verification, PRs |
| Implementation | Cursor | Code per briefs |

---

## Key Commands

```bash
# Verification Sequence (Sacred Four)
pnpm typecheck && pnpm lint && pnpm test:run && pnpm build

# Development
pnpm dev
pnpm build
```

---

## Links

- [FORGE Method](https://theforgemethod.org) — The methodology
- [FORGE Canon](../../method/) — Authoritative docs
- [Constitutional Docs](docs/constitution/) — Project specs

---

*This project follows The FORGE Method(TM) — theforgemethod.org*

**FORGE Contributors**
