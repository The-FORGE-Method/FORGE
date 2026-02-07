# Constitutional Documents

**Status:** PLACEHOLDER - Awaiting inputs from Human Lead

---

## Required Inputs

Before Execute phase can begin, the following documents must exist:

| Document | Purpose | Status |
|----------|---------|--------|
| `PRODUCT.md` | Product intent, user value, success criteria | EMPTY |
| `TECH.md` | Technical architecture, stack decisions, constraints | EMPTY |
| `GOVERNANCE.md` | Security, permissions, policies, RLS rules | EMPTY |

---

## How to Populate

### Option 1: Human Lead provides content
Human Lead provides the constitutional documents from:
- Jordan's Frame Artifact
- CP's refined specifications
- Previous project templates

### Option 2: CP authors during Refine
During Refine phase, CP (Spec Author) produces these documents based on Frame output.

---

## Document Hierarchy

```
PRODUCT.md (Level 1 - Highest Authority)
├── TECH.md (Level 2 - Constrained by Product)
│   ├── Data Model (derived)
│   ├── API Contract (derived)
│   └── Engineering Standards (derived)
└── GOVERNANCE.md (Level 2 - Constrains All Implementation)
    ├── Security Policies
    ├── RLS Rules
    └── Permission Model
```

---

## Rules

1. **These documents are READ-ONLY during Execute phase**
2. **All implementation decisions must reference these docs**
3. **Changes require Human Lead approval**
4. **CC cannot modify; can only read and escalate ambiguities**

---

## When Empty

If these documents are empty:
- **CC must STOP** and request inputs
- **Cursor cannot begin implementation**
- **No scaffolding should occur**

The constitution must exist before work begins.

---

*This project follows The FORGE Method(TM) — theforgemethod.org*
