/**
 * FORGE Auth/RBAC Type Definitions
 *
 * See FORGE method documentation for the Auth/RBAC extension.
 */

// =============================================================================
// ROLES
// =============================================================================

/**
 * Standard FORGE roles
 */
export type Role = 'owner' | 'admin' | 'member' | 'stakeholder';

/**
 * All available roles for type checking
 */
export const ROLES: readonly Role[] = ['owner', 'admin', 'member', 'stakeholder'] as const;

// =============================================================================
// ENTITIES
// =============================================================================

export interface User {
  id: string;
  email: string;
  display_name: string | null;
  avatar_url: string | null;
  created_at: string;
  updated_at: string;
}

export interface Organization {
  id: string;
  name: string;
  slug: string;
  created_at: string;
  updated_at: string;
}

export interface Membership {
  id: string;
  user_id: string;
  organization_id: string;
  roles: Role[];
  created_at: string;
  updated_at: string;
}

// =============================================================================
// AUTH CONTEXT
// =============================================================================

/**
 * Current auth context after two-phase authentication
 */
export interface AuthContext {
  /** Current user (from identity phase) */
  user: User | null;

  /** Current organization (from context phase) */
  organization: Organization | null;

  /** User's roles in current organization */
  roles: Role[];

  /** Whether identity phase is complete */
  isAuthenticated: boolean;

  /** Whether context phase is complete (org selected) */
  hasOrgContext: boolean;
}

// =============================================================================
// ROLE CHECKING
// =============================================================================

/**
 * Role hierarchy for permission checks
 * Higher index = more authority
 */
export const ROLE_HIERARCHY: Record<Role, number> = {
  stakeholder: 0,
  member: 1,
  admin: 2,
  owner: 3,
};

/**
 * Check if a role has authority over another
 */
export function roleHasAuthority(userRole: Role, requiredRole: Role): boolean {
  return ROLE_HIERARCHY[userRole] >= ROLE_HIERARCHY[requiredRole];
}
