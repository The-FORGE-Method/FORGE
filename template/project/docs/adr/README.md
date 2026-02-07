# Architecture Decision Records (ADRs)

**Purpose:** Document significant architectural decisions made during the project.

---

## What is an ADR?

An Architecture Decision Record captures a decision that has architectural significance. ADRs are:

- **Immutable** — Once recorded, decisions are not edited (superseded instead)
- **Numbered** — Sequential numbering for easy reference
- **Contextual** — Captures the "why" not just the "what"

---

## When to Create an ADR

Create an ADR when:

1. Choosing between competing approaches with significant trade-offs
2. Making a decision that will be expensive to reverse
3. Establishing a pattern that future code should follow
4. Overriding a constitutional document recommendation (with approval)

**Do NOT create an ADR for:**
- Minor implementation choices
- Decisions already covered by constitutional documents
- Temporary workarounds (use code comments instead)

---

## ADR Index

| # | Title | Status | Date |
|---|-------|--------|------|
| 0001 | [TBD] | [Proposed/Accepted/Deprecated/Superseded] | [YYYY-MM-DD] |

---

## Status Definitions

| Status | Meaning |
|--------|---------|
| **Proposed** | Under discussion, not yet decided |
| **Accepted** | Decision made and in effect |
| **Deprecated** | No longer recommended but still in codebase |
| **Superseded** | Replaced by another ADR (link to new one) |

---

## How to Create an ADR

1. Copy `adr-template.md` to `NNNN-title-in-kebab-case.md`
2. Fill in all sections
3. Submit for review (PR or direct to Human Lead)
4. Update this index when accepted

---

*This project follows The FORGE Method(TM) — theforgemethod.org*
