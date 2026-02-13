# GOVERNANCE.md

**Status:** EMPTY - Awaiting input from Human Lead
**Version:** 0.0
**Last Updated:** —

---

## Purpose

This document defines the **governance rules** — security, permissions, and policies that constrain all implementation.

---

## Required Content

When populated, this document should include:

### 1. Authentication
- Auth provider and method
- Session management
- Token handling
- OAuth providers (if any)

### 2. Authorization
- Role definitions
- Permission model
- Access control rules

### 2a. Platform vs Tenant Authorization
- Platform memberships (stakeholder access)
- Session plane isolation
- Dual-plane human identity handling (if applicable)

### 3. Row Level Security (RLS)
- Table-level policies
- User isolation rules
- Admin overrides

### 4. Data Protection
- Sensitive data handling
- Encryption requirements
- PII considerations

### 5. API Security
- Rate limiting
- Input validation rules
- CORS configuration

### 6. Audit & Logging
- What to log
- What NOT to log
- Retention policies

---

## How to Populate

1. Human Lead provides security requirements
2. Or CP authors during Refine based on product/regulatory needs
3. Human Lead approves before Execute

---

### 7. Autonomy Policy (v1.3)

- Autonomy tier (see `FORGE-AUTONOMY.yml`)
- Human gates (actions requiring human approval at all tiers)
- Blast radius thresholds
- Router event logging configuration

See `FORGE-AUTONOMY.yml` in project root and `method/templates/forge-template-autonomy-policy.md` for schema reference.

---

## Until Populated

**CC must not scaffold or begin execution.**

---

## Execution Governance (v2.0)

### Lane Separation
- @G plans and routes. @G does not write code.
- @E executes and tests. @E does not plan or expand scope.
- Human Lead approves and merges. Human Lead is the only authority.

### Human Gating
- No execution begins without `approved: true` in packet.yml
- No PR merges without Human Lead review
- No constitution changes without Human Lead approval
- Agents produce artifacts and STOP. They do not continue autonomously.

### Tests-First
- @E writes tests before implementation
- Sacred Four must pass before PR is ready for review:
  1. typecheck
  2. lint
  3. test
  4. build

### Constitution Immutability
- docs/constitution/ is read-only during execution
- Changes require a separate packet with Human Lead approval
- All constitution changes are logged as ADRs in docs/adr/

---

*This project follows The FORGE Method(TM) — theforgemethod.org*
