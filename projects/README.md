# FORGE Projects

This directory holds all FORGE-governed projects. Each project is a subdirectory scaffolded by `@A` (Acquire).

---

## How It Works

1. **Start a new project:** Run `/forge-a` or say "I want to build X"
2. **@A scaffolds** a project directory here with the A.B.C pre-FORGE structure
3. **Work through A.B.C** to define scope, brief, and commitment
4. **Produce FORGE-ENTRY.md** to unlock the F.O.R.G.E lifecycle agents

## Project Structure

Each project follows this layout:

```
projects/<slug>/
├── abc/                    # Pre-FORGE: Acquire, Brief, Commit
│   ├── INTAKE.md           # @A output
│   ├── BRIEF.md            # @B output (optional)
│   └── FORGE-ENTRY.md      # @C output (gate artifact)
├── docs/                   # Constitutional docs, ADRs, parking lot
│   └── constitution/
│       ├── PRODUCT.md
│       ├── TECH.md
│       └── GOVERNANCE.md
├── inbox/                  # Feature inbox for the project
├── src/                    # Source code
└── tests/                  # Tests
```

## Gate: A.B.C -> F.O.R.G.E

- **Before** `abc/FORGE-ENTRY.md` exists: Only `@A`, `@B`, `@C` agents are available
- **After** `abc/FORGE-ENTRY.md` exists: `@F`, `@O`, `@R`, `@G`, `@E` agents unlock

## Registry

`_registry.json` tracks active projects. It is updated automatically by `@A` when a new project is scaffolded.

---

*Each project is an independent FORGE-governed unit. The methodology lives in `method/`, the template lives in `template/`.*
