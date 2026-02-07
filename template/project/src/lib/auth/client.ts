/**
 * FORGE Auth/RBAC Client Utilities
 *
 * Client-side helpers for role checking and auth context.
 * See FORGE method documentation for the Auth/RBAC extension.
 */

import type { Role, AuthContext } from './types';

// =============================================================================
// ROLE CHECKING
// =============================================================================

/**
 * Check if the current user has a specific role
 */
export function hasRole(roles: Role[], requiredRole: Role): boolean {
  return roles.includes(requiredRole);
}

/**
 * Check if the current user has any of the specified roles
 */
export function hasAnyRole(roles: Role[], requiredRoles: Role[]): boolean {
  return requiredRoles.some((role) => roles.includes(role));
}

/**
 * Check if user has all specified roles
 */
export function hasAllRoles(roles: Role[], requiredRoles: Role[]): boolean {
  return requiredRoles.every((role) => roles.includes(role));
}

// =============================================================================
// PERMISSION CHECKS
// =============================================================================

/**
 * Check if user can manage users (owner or admin)
 */
export function canManageUsers(roles: Role[]): boolean {
  return hasAnyRole(roles, ['owner', 'admin']);
}

/**
 * Check if user can manage org settings (owner or admin)
 */
export function canManageSettings(roles: Role[]): boolean {
  return hasAnyRole(roles, ['owner', 'admin']);
}

/**
 * Check if user can create/edit content (owner, admin, or member)
 */
export function canEditContent(roles: Role[]): boolean {
  return hasAnyRole(roles, ['owner', 'admin', 'member']);
}

/**
 * Check if user has portal access (any role)
 */
export function hasPortalAccess(roles: Role[]): boolean {
  return roles.length > 0;
}

/**
 * Check if user is org owner
 */
export function isOwner(roles: Role[]): boolean {
  return hasRole(roles, 'owner');
}

// =============================================================================
// AUTH CONTEXT HELPERS
// =============================================================================

/**
 * Create an empty auth context (unauthenticated)
 */
export function createEmptyAuthContext(): AuthContext {
  return {
    user: null,
    organization: null,
    roles: [],
    isAuthenticated: false,
    hasOrgContext: false,
  };
}

/**
 * Check if auth context is fully established (both phases complete)
 */
export function isFullyAuthenticated(context: AuthContext): boolean {
  return context.isAuthenticated && context.hasOrgContext;
}
