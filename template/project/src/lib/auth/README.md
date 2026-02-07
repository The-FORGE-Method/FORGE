# Auth Utilities

**FORGE Auth/RBAC client-side utilities.**

---

## Overview

This folder contains auth utilities implementing the FORGE Auth/RBAC extension.

See FORGE method documentation for the Auth/RBAC extension.

---

## Key Concepts

### Org-Centric Identity

Users belong to Organizations via Memberships. All data access is scoped to the current organization context.

### Four Roles

| Role | Capabilities |
|------|-------------|
| **Owner** | Full authority, org deletion, ownership transfer |
| **Admin** | User management, role assignment, settings |
| **Member** | Standard access, create/edit resources |
| **Stakeholder** | Portal access, feedback, voting |

### Multi-Role Users

Users can hold multiple roles simultaneously (e.g., Member + Stakeholder). Roles are additive capability grants.

---

## Files

| File | Purpose |
|------|---------|
| `types.ts` | Auth-related TypeScript types |
| `client.ts` | Client-side auth utilities |
| `middleware.ts` | Route protection middleware |

---

## Usage

```typescript
// Check if user has a role
import { hasRole, hasAnyRole } from '@/lib/auth/client';

if (hasRole('admin')) {
  // Admin-only logic
}

if (hasAnyRole(['owner', 'admin'])) {
  // Owner or Admin logic
}
```

---

## Two-Phase Authentication

1. **Identity Phase:** User authenticates (Supabase Auth)
2. **Context Phase:** User selects organization, org_id set in session

Most views require both phases complete before rendering org-scoped content.

---

*Implements FORGE Auth/RBAC extension*
