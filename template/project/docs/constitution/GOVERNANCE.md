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

*This project follows The FORGE Method(TM) — theforgemethod.org*
