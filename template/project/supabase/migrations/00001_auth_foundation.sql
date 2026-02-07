-- FORGE Auth/RBAC Foundation
-- Org-centric identity model per FORGE method Auth/RBAC extension
--
-- This migration establishes the core auth schema. Customize as needed.

-- =============================================================================
-- USERS (extends Supabase auth.users)
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.users IS 'Extended user profile, linked to Supabase auth.users';

-- =============================================================================
-- ORGANIZATIONS
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.organizations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.organizations IS 'Organizations are the top-level tenants';

-- =============================================================================
-- MEMBERSHIPS (users <-> organizations with roles)
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.memberships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  organization_id UUID NOT NULL REFERENCES public.organizations(id) ON DELETE CASCADE,
  roles TEXT[] NOT NULL DEFAULT ARRAY['member'],
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  UNIQUE(user_id, organization_id)
);

COMMENT ON TABLE public.memberships IS 'Links users to organizations with role array';
COMMENT ON COLUMN public.memberships.roles IS 'Array of roles: owner, admin, member, stakeholder';

-- =============================================================================
-- INDEXES
-- =============================================================================

CREATE INDEX IF NOT EXISTS idx_memberships_user_id ON public.memberships(user_id);
CREATE INDEX IF NOT EXISTS idx_memberships_org_id ON public.memberships(organization_id);
CREATE INDEX IF NOT EXISTS idx_organizations_slug ON public.organizations(slug);

-- =============================================================================
-- RLS HELPER FUNCTIONS
-- =============================================================================

-- Get current org_id from JWT
CREATE OR REPLACE FUNCTION public.current_org_id()
RETURNS UUID
LANGUAGE sql
STABLE
AS $$
  SELECT NULLIF(current_setting('request.jwt.claims', true)::json->>'org_id', '')::UUID;
$$;

COMMENT ON FUNCTION public.current_org_id() IS 'Extract org_id from JWT claims';

-- Get current user roles for current org
CREATE OR REPLACE FUNCTION public.current_roles()
RETURNS TEXT[]
LANGUAGE sql
STABLE
AS $$
  SELECT COALESCE(
    (SELECT roles FROM public.memberships
     WHERE user_id = auth.uid()
     AND organization_id = public.current_org_id()),
    ARRAY[]::TEXT[]
  );
$$;

COMMENT ON FUNCTION public.current_roles() IS 'Get roles for current user in current org';

-- Check if user has a specific role
CREATE OR REPLACE FUNCTION public.has_role(required_role TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT required_role = ANY(public.current_roles());
$$;

COMMENT ON FUNCTION public.has_role(TEXT) IS 'Check if current user has specific role';

-- Check if user has any of the specified roles
CREATE OR REPLACE FUNCTION public.has_any_role(required_roles TEXT[])
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
  SELECT public.current_roles() && required_roles;
$$;

COMMENT ON FUNCTION public.has_any_role(TEXT[]) IS 'Check if current user has any of the roles';

-- =============================================================================
-- ROW LEVEL SECURITY
-- =============================================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.memberships ENABLE ROW LEVEL SECURITY;

-- Users: can view own profile
CREATE POLICY "users_select_own" ON public.users
  FOR SELECT USING (id = auth.uid());

CREATE POLICY "users_update_own" ON public.users
  FOR UPDATE USING (id = auth.uid());

-- Organizations: members can view their org
CREATE POLICY "orgs_select_member" ON public.organizations
  FOR SELECT USING (
    id IN (
      SELECT organization_id FROM public.memberships
      WHERE user_id = auth.uid()
    )
  );

-- Organizations: only owners/admins can update
CREATE POLICY "orgs_update_admin" ON public.organizations
  FOR UPDATE USING (
    id = public.current_org_id()
    AND public.has_any_role(ARRAY['owner', 'admin'])
  );

-- Memberships: can view memberships in your orgs
CREATE POLICY "memberships_select" ON public.memberships
  FOR SELECT USING (
    organization_id IN (
      SELECT organization_id FROM public.memberships
      WHERE user_id = auth.uid()
    )
  );

-- Memberships: only owners/admins can modify
CREATE POLICY "memberships_insert_admin" ON public.memberships
  FOR INSERT WITH CHECK (
    organization_id = public.current_org_id()
    AND public.has_any_role(ARRAY['owner', 'admin'])
  );

CREATE POLICY "memberships_update_admin" ON public.memberships
  FOR UPDATE USING (
    organization_id = public.current_org_id()
    AND public.has_any_role(ARRAY['owner', 'admin'])
  );

CREATE POLICY "memberships_delete_admin" ON public.memberships
  FOR DELETE USING (
    organization_id = public.current_org_id()
    AND public.has_any_role(ARRAY['owner', 'admin'])
  );

-- =============================================================================
-- UPDATED_AT TRIGGER
-- =============================================================================

CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER organizations_updated_at
  BEFORE UPDATE ON public.organizations
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

CREATE TRIGGER memberships_updated_at
  BEFORE UPDATE ON public.memberships
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
