<!-- Audience: Public -->

# FORGE Template: SaaS Development Standards

**Version:** 1.0
**Status:** Operational Template
**For:** Enterprise-grade SaaS application development
**Stack:** Next.js + Supabase + TypeScript strict

---

## Overview

This template defines the technology stack, project structure, and coding standards for enterprise SaaS applications built using FORGE. These defaults ensure consistency, quality, and maintainability across projects.

**Key Principles:**
- **Defaults provide consistency** — Standard stack reduces cognitive load
- **Alternatives require justification** — Deviations must be documented
- **Strict mode enforced** — TypeScript strict mode is non-negotiable
- **Tests are required** — 70% coverage minimum, 100% for Sacred Four paths

---

## Table of Contents

1. [Technology Stack Defaults](#1-technology-stack-defaults)
2. [Stack Alternatives Policy](#2-stack-alternatives-policy)
3. [Project Structure Convention](#3-project-structure-convention)
4. [TypeScript Configuration](#4-typescript-configuration)
5. [API Route Patterns](#5-api-route-patterns)
6. [Component Patterns](#6-component-patterns)
7. [Database Patterns](#7-database-patterns)
8. [Authentication Patterns](#8-authentication-patterns)
9. [Environment Configuration](#9-environment-configuration)
10. [Documentation Requirements](#10-documentation-requirements)

---

## 1. Technology Stack Defaults

### 1.1 Frontend Stack

| Component | Default | Version | Justification |
|-----------|---------|---------|---------------|
| **Framework** | Next.js | 15+ | App Router, Server Components, built-in API routes, streaming SSR |
| **React** | React | 19+ | Server Components, Suspense, transitions, concurrent rendering |
| **Language** | TypeScript | 5+ | Type safety, strict mode required for enterprise-grade reliability |
| **Styling** | Tailwind CSS | v4+ | Utility-first, design system friendly, excellent DX |
| **UI Primitives** | Radix UI | Latest | Accessibility built-in, unstyled primitives, composable |
| **Component Library** | shadcn/ui | Latest | Copy-paste components, fully customizable, no vendor lock-in |

### 1.2 Backend Stack

| Component | Default | Justification |
|-----------|---------|---------------|
| **Database** | Supabase Postgres | Postgres + Row-Level Security + real-time + auth + storage unified |
| **Auth** | Supabase Auth | OAuth + email/password, JWT tokens, RLS integration, magic links |
| **Storage** | Supabase Storage | File uploads with CDN, RLS-protected buckets, image transformations |
| **Serverless Functions** | Supabase Edge Functions | Deno runtime, auto-deploy, close to database, low latency |
| **Payments** | Stripe | Industry standard, webhook support, SCA compliance, global coverage |

### 1.3 Development Tools

| Component | Default | Justification |
|-----------|---------|---------------|
| **Package Manager** | pnpm | Fast, disk-efficient, strict dependency resolution, monorepo support |
| **Build Tool** | Turbopack | Next.js built-in, faster than Webpack, incremental compilation |
| **TypeScript Config** | Strict mode | `noImplicitAny`, `strictNullChecks`, all strict flags enabled |
| **Testing (Unit/Integration)** | Vitest | Fast, Vite-native, Jest-compatible API, excellent TypeScript support |
| **Testing (E2E)** | Playwright | Cross-browser, reliable, good DX, visual regression testing |
| **Linting** | ESLint | TypeScript-aware, Next.js rules, import ordering |
| **Formatting** | Prettier | Opinionated, consistent code style, integrates with ESLint |
| **Git Hooks** | Husky + lint-staged | Pre-commit linting and formatting, fails fast |

---

## 2. Stack Alternatives Policy

### 2.1 Default Behavior

**@E uses the technology stack defaults listed above unless explicitly allowed to deviate.**

### 2.2 When Alternatives Are Permitted

**1. Handoff packet explicitly allows it**

Example handoff packet with stack allowance:

```yaml
---
handoff_id: HO-2026-001-graphql-api
stack_allowances:
  - May use Prisma instead of Supabase client for complex queries
  - May use Apollo Server for GraphQL endpoint
  - Reason: Feature requires GraphQL subscriptions not supported by Next.js API routes
---
```

**2. @E escalates and receives approval**

Process:
1. @E documents reason for alternative (e.g., "Feature X requires GraphQL, Next.js API routes insufficient")
2. @G + Human Lead review and approve deviation
3. Alternative is documented in ADR (Architecture Decision Record)
4. ADR filed in `docs/adr/ADR-NNN-use-graphql.md`

**3. Project GOVERNANCE.md overrides defaults**

Example GOVERNANCE.md override:

```markdown
## Technology Stack Overrides

**Database:** PostgreSQL (direct connection via pg library)
**Reason:** Client requires on-premise deployment; Supabase cloud not permitted
**Documented in:** ADR-002-use-direct-postgres.md
```

### 2.3 Documented Alternatives

These alternatives are **approved for use with justification**:

| Component | Alternative | When to Use |
|-----------|-------------|-------------|
| **Database** | Raw PostgreSQL | When Supabase features (auth, storage, real-time) not needed |
| **Auth** | NextAuth.js | When Supabase Auth insufficient (e.g., SAML, LDAP required) |
| **Serverless** | Vercel Edge Functions | When Supabase Edge Functions unavailable or incompatible |
| **Styling** | CSS Modules | When Tailwind CSS is restricted by design team policy |
| **UI Library** | Material-UI (MUI) | When design system requires Material Design compliance |
| **Testing (Unit)** | Jest | When Vitest compatibility issues arise (rare) |
| **Testing (E2E)** | Cypress | When Playwright incompatible with existing setup (rare) |
| **State Management** | Zustand, Jotai | When React Context insufficient for global state |
| **Forms** | React Hook Form | When complex form validation requires library support |
| **Validation** | Yup | When Zod integration issues arise (prefer Zod) |

### 2.4 Principle

**Defaults provide consistency. Alternatives require justification and documentation.**

---

## 3. Project Structure Convention

### 3.1 Standard Directory Structure

```
project-root/
├── src/
│   ├── app/                          # Next.js App Router (routes)
│   │   ├── (auth)/                  # Route group: auth-required routes
│   │   │   ├── dashboard/           # /dashboard route
│   │   │   │   └── page.tsx
│   │   │   └── settings/            # /settings route
│   │   │       └── page.tsx
│   │   ├── (public)/                # Route group: public routes
│   │   │   ├── about/
│   │   │   │   └── page.tsx
│   │   │   └── pricing/
│   │   │       └── page.tsx
│   │   ├── api/                     # API routes
│   │   │   ├── auth/
│   │   │   │   └── route.ts
│   │   │   └── webhook/
│   │   │       └── route.ts
│   │   ├── layout.tsx               # Root layout (providers, fonts)
│   │   ├── page.tsx                 # Home page (/)
│   │   └── globals.css              # Global styles
│   ├── components/
│   │   ├── ui/                      # Primitives (shadcn/radix)
│   │   │   ├── button.tsx
│   │   │   ├── card.tsx
│   │   │   └── input.tsx
│   │   └── features/                # Feature-specific components
│   │       ├── auth/
│   │       │   ├── LoginForm.tsx
│   │       │   └── SignupForm.tsx
│   │       └── dashboard/
│   │           └── PropertyCard.tsx
│   ├── lib/
│   │   ├── supabase/                # Supabase integration
│   │   │   ├── client.ts            # Browser client
│   │   │   ├── server.ts            # Server client (SSR)
│   │   │   ├── types.ts             # Generated types
│   │   │   └── auth.ts              # Auth helpers
│   │   ├── stripe/                  # Stripe integration
│   │   │   ├── client.ts
│   │   │   └── webhooks.ts
│   │   └── utils/                   # Shared utilities
│   │       ├── cn.ts                # classNames utility
│   │       └── formatters.ts        # Date, currency, etc.
│   ├── hooks/                       # Custom React hooks
│   │   ├── useAuth.ts
│   │   └── useDebounce.ts
│   ├── types/                       # TypeScript definitions
│   │   ├── database.ts              # Supabase database types
│   │   └── api.ts                   # API request/response types
│   └── styles/                      # Global styles
│       └── globals.css
├── tests/
│   ├── unit/                        # Vitest unit tests (fast, isolated)
│   │   ├── lib/
│   │   │   └── utils.test.ts
│   │   └── components/
│   │       └── Button.test.tsx
│   ├── integration/                 # API + database integration tests
│   │   ├── api/
│   │   │   └── auth.test.ts
│   │   └── database/
│   │       └── users.test.ts
│   └── e2e/                         # Playwright E2E tests (few, critical)
│       ├── auth-flow.spec.ts
│       └── checkout-flow.spec.ts
├── supabase/
│   ├── migrations/                  # SQL migration files
│   │   └── 20260206_initial_schema.sql
│   ├── functions/                   # Edge functions
│   │   └── send-email/
│   │       └── index.ts
│   └── config.toml                  # Supabase project config
├── docs/
│   ├── adr/                         # Architecture Decision Records
│   │   └── ADR-001-use-nextjs.md
│   ├── ARCHITECTURE.md              # System design overview
│   └── ONBOARDING.md                # Human team onboarding guide
├── .github/
│   └── workflows/                   # CI/CD pipelines
│       ├── pr-validation.yml        # Sacred Four on PRs
│       ├── deploy-preview.yml       # Preview deployments
│       └── production-deploy.yml    # Production deployments
├── public/                          # Static assets
│   ├── images/
│   └── fonts/
├── .husky/                          # Git hooks
│   └── pre-commit                   # Lint-staged on commit
├── CLAUDE.md                        # Claude Code project instructions
├── GOVERNANCE.md                    # Team roles, decision process
├── README.md                        # Quick start, tech stack
├── package.json
├── pnpm-lock.yaml
├── tsconfig.json
├── next.config.js
├── tailwind.config.js
├── postcss.config.js
├── vitest.config.ts
├── playwright.config.ts
├── .eslintrc.json
├── .prettierrc.json
├── .env.local                       # Environment variables (not committed)
├── .env.example                     # Environment variable template
└── .gitignore
```

### 3.2 Key Conventions

**Route groups** — Use `(auth)` and `(public)` to organize routes without affecting URLs:
- `/dashboard` → `app/(auth)/dashboard/page.tsx`
- `/about` → `app/(public)/about/page.tsx`

**Feature-based components** — Organize by feature in `components/features/`, not flat structure:
- ✅ `components/features/auth/LoginForm.tsx`
- ❌ `components/LoginForm.tsx` (avoid flat structure)

**Colocated tests** — Mirror `src/` structure in `tests/`:
- `src/lib/utils.ts` → `tests/unit/lib/utils.test.ts`

**Supabase folder** — Contains migrations and edge functions:
- Migrations: `supabase/migrations/YYYYMMDD_description.sql`
- Edge functions: `supabase/functions/<function-name>/index.ts`

**Docs folder** — Human-readable architecture and ADRs:
- Architecture overview: `docs/ARCHITECTURE.md`
- Decision records: `docs/adr/ADR-NNN-title.md`

---

## 4. TypeScript Configuration

### 4.1 Strict Mode Configuration

**File:** `tsconfig.json`

```json
{
  "compilerOptions": {
    // Strict mode flags (all enabled)
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,

    // Additional type checking
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,

    // Module resolution
    "target": "ES2022",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "resolveJsonModule": true,
    "allowImportingTsExtensions": false,
    "isolatedModules": true,
    "jsx": "preserve",

    // Emit
    "noEmit": true,
    "incremental": true,

    // Path mapping
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    },

    // Next.js specific
    "plugins": [
      {
        "name": "next"
      }
    ]
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### 4.2 Type Safety Requirements

**All code must:**
- [ ] Use TypeScript strict mode
- [ ] Have no `any` types (use `unknown` for truly dynamic values)
- [ ] Define explicit return types for all functions
- [ ] Use type guards for runtime validation
- [ ] Avoid type assertions (`as`) unless absolutely necessary

**Example: Proper type safety**

```typescript
// ✅ GOOD: Explicit types, no any
interface User {
  id: string
  email: string
  name: string | null
}

async function getUser(id: string): Promise<User | null> {
  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('id', id)
    .single()

  if (error) return null
  return data as User // Type assertion justified: Supabase types match
}

// ❌ BAD: Implicit any, no return type
async function getUser(id) {
  const { data } = await supabase
    .from('users')
    .select('*')
    .eq('id', id)
    .single()

  return data // What type is this?
}
```

---

## 5. API Route Patterns

### 5.1 Standard API Route Structure

**File:** `app/api/<endpoint>/route.ts`

```typescript
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'
import { createClient } from '@/lib/supabase/server'

// Define request schema with Zod
const requestSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
})

// Define response type
interface CreateUserResponse {
  id: string
  email: string
  name: string
}

// POST handler
export async function POST(request: NextRequest) {
  try {
    // Parse and validate request body
    const body = await request.json()
    const validatedData = requestSchema.parse(body)

    // Get authenticated user from session
    const supabase = createClient()
    const { data: { user }, error: authError } = await supabase.auth.getUser()

    if (authError || !user) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      )
    }

    // Perform database operation
    const { data, error } = await supabase
      .from('users')
      .insert({
        email: validatedData.email,
        name: validatedData.name,
        owner_id: user.id,
      })
      .select()
      .single()

    if (error) {
      console.error('Database error:', error)
      return NextResponse.json(
        { error: 'Failed to create user' },
        { status: 500 }
      )
    }

    // Return success response
    return NextResponse.json<CreateUserResponse>(
      {
        id: data.id,
        email: data.email,
        name: data.name,
      },
      { status: 201 }
    )
  } catch (error) {
    // Handle validation errors
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid request data', details: error.errors },
        { status: 400 }
      )
    }

    // Handle unexpected errors
    console.error('Unexpected error:', error)
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    )
  }
}

// GET handler
export async function GET(request: NextRequest) {
  const supabase = createClient()
  const { data: { user }, error: authError } = await supabase.auth.getUser()

  if (authError || !user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('owner_id', user.id)

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }

  return NextResponse.json(data)
}
```

### 5.2 API Route Checklist

All API routes must:
- [ ] Validate request body with Zod schemas
- [ ] Verify authentication (except public endpoints)
- [ ] Use proper HTTP status codes (200, 201, 400, 401, 403, 404, 500)
- [ ] Return typed JSON responses
- [ ] Handle errors gracefully (try-catch)
- [ ] Log errors to console (production: use logging service)
- [ ] Use parameterized queries (no raw SQL concatenation)
- [ ] Enforce RLS policies via Supabase client

---

## 6. Component Patterns

### 6.1 Server Component (Default)

**File:** `app/dashboard/page.tsx`

```typescript
import { createClient } from '@/lib/supabase/server'
import { PropertyCard } from '@/components/features/dashboard/PropertyCard'

export default async function DashboardPage() {
  const supabase = createClient()

  // Fetch data on server (no loading state needed)
  const { data: properties } = await supabase
    .from('properties')
    .select('*')
    .order('created_at', { ascending: false })

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-3xl font-bold mb-6">Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {properties?.map((property) => (
          <PropertyCard key={property.id} property={property} />
        ))}
      </div>
    </div>
  )
}
```

### 6.2 Client Component (Use `'use client'`)

**File:** `components/features/auth/LoginForm.tsx`

```typescript
'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { z } from 'zod'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { createClient } from '@/lib/supabase/client'

const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
})

type LoginFormData = z.infer<typeof loginSchema>

export function LoginForm() {
  const router = useRouter()
  const [error, setError] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(false)

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
  })

  const onSubmit = async (data: LoginFormData) => {
    setIsLoading(true)
    setError(null)

    const supabase = createClient()
    const { error } = await supabase.auth.signInWithPassword({
      email: data.email,
      password: data.password,
    })

    if (error) {
      setError(error.message)
      setIsLoading(false)
      return
    }

    router.push('/dashboard')
    router.refresh()
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div>
        <Input
          {...register('email')}
          type="email"
          placeholder="Email"
          disabled={isLoading}
        />
        {errors.email && (
          <p className="text-sm text-red-500 mt-1">{errors.email.message}</p>
        )}
      </div>

      <div>
        <Input
          {...register('password')}
          type="password"
          placeholder="Password"
          disabled={isLoading}
        />
        {errors.password && (
          <p className="text-sm text-red-500 mt-1">{errors.password.message}</p>
        )}
      </div>

      {error && (
        <p className="text-sm text-red-500">{error}</p>
      )}

      <Button type="submit" disabled={isLoading} className="w-full">
        {isLoading ? 'Logging in...' : 'Log in'}
      </Button>
    </form>
  )
}
```

### 6.3 Component Checklist

All components must:
- [ ] Use TypeScript with explicit prop types
- [ ] Use Server Components by default (add `'use client'` only when needed)
- [ ] Follow single responsibility principle (one component, one purpose)
- [ ] Include JSDoc comments for complex logic
- [ ] Use Tailwind CSS for styling (no inline styles)
- [ ] Handle loading and error states
- [ ] Be accessible (ARIA labels, keyboard navigation)

---

## 7. Database Patterns

### 7.1 Supabase Client Creation

**Browser client:** `lib/supabase/client.ts`

```typescript
import { createBrowserClient } from '@supabase/ssr'
import { Database } from '@/types/database'

export function createClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

**Server client (SSR):** `lib/supabase/server.ts`

```typescript
import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { cookies } from 'next/headers'
import { Database } from '@/types/database'

export function createClient() {
  const cookieStore = cookies()

  return createServerClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value
        },
        set(name: string, value: string, options: CookieOptions) {
          cookieStore.set({ name, value, ...options })
        },
        remove(name: string, options: CookieOptions) {
          cookieStore.set({ name, value: '', ...options })
        },
      },
    }
  )
}
```

### 7.2 Migration Pattern

**File:** `supabase/migrations/20260206_create_properties.sql`

```sql
-- Create properties table
CREATE TABLE IF NOT EXISTS public.properties (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  price INTEGER NOT NULL,
  location TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view own properties"
  ON public.properties
  FOR SELECT
  USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own properties"
  ON public.properties
  FOR INSERT
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own properties"
  ON public.properties
  FOR UPDATE
  USING (auth.uid() = owner_id)
  WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can delete own properties"
  ON public.properties
  FOR DELETE
  USING (auth.uid() = owner_id);

-- Indexes
CREATE INDEX properties_owner_id_idx ON public.properties(owner_id);
CREATE INDEX properties_created_at_idx ON public.properties(created_at DESC);

-- Updated_at trigger
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_properties_updated_at
  BEFORE UPDATE ON public.properties
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- ROLLBACK (for reference)
-- DROP TABLE IF EXISTS public.properties CASCADE;
-- DROP FUNCTION IF EXISTS public.update_updated_at_column() CASCADE;
```

### 7.3 Database Checklist

All database operations must:
- [ ] Use RLS policies (never disable RLS in production)
- [ ] Use migrations for schema changes (never modify schema manually)
- [ ] Include rollback instructions in migration comments
- [ ] Use indexes on foreign keys and frequently queried columns
- [ ] Use `created_at` and `updated_at` timestamps on all tables
- [ ] Use UUID for primary keys
- [ ] Use `ON DELETE CASCADE` for foreign keys where appropriate

---

## 8. Authentication Patterns

### 8.1 Auth Helpers

**File:** `lib/supabase/auth.ts`

```typescript
import { createClient } from '@/lib/supabase/server'

export async function getUser() {
  const supabase = createClient()
  const { data: { user }, error } = await supabase.auth.getUser()

  if (error || !user) {
    return null
  }

  return user
}

export async function requireAuth() {
  const user = await getUser()

  if (!user) {
    throw new Error('Unauthorized')
  }

  return user
}
```

### 8.2 Protected Route Pattern

**File:** `app/(auth)/dashboard/page.tsx`

```typescript
import { redirect } from 'next/navigation'
import { getUser } from '@/lib/supabase/auth'

export default async function DashboardPage() {
  const user = await getUser()

  if (!user) {
    redirect('/login')
  }

  return (
    <div>
      <h1>Welcome, {user.email}</h1>
    </div>
  )
}
```

### 8.3 Middleware for Auth Protection

**File:** `middleware.ts`

```typescript
import { createServerClient, type CookieOptions } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let response = NextResponse.next({
    request: {
      headers: request.headers,
    },
  })

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return request.cookies.get(name)?.value
        },
        set(name: string, value: string, options: CookieOptions) {
          request.cookies.set({
            name,
            value,
            ...options,
          })
          response = NextResponse.next({
            request: {
              headers: request.headers,
            },
          })
          response.cookies.set({
            name,
            value,
            ...options,
          })
        },
        remove(name: string, options: CookieOptions) {
          request.cookies.set({
            name,
            value: '',
            ...options,
          })
          response = NextResponse.next({
            request: {
              headers: request.headers,
            },
          })
          response.cookies.set({
            name,
            value: '',
            ...options,
          })
        },
      },
    }
  )

  const { data: { user } } = await supabase.auth.getUser()

  // Protect /dashboard routes
  if (request.nextUrl.pathname.startsWith('/dashboard') && !user) {
    return NextResponse.redirect(new URL('/login', request.url))
  }

  return response
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
}
```

---

## 9. Environment Configuration

### 9.1 Environment Variables

**File:** `.env.example`

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_xxx
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx

# Site URL
NEXT_PUBLIC_SITE_URL=http://localhost:3000
```

**File:** `.env.local` (not committed)

```bash
# Copy from .env.example and fill in real values
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJxxx
SUPABASE_SERVICE_ROLE_KEY=eyJxxx

NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_xxx
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_WEBHOOK_SECRET=whsec_xxx

NEXT_PUBLIC_SITE_URL=http://localhost:3000
```

### 9.2 Environment Variable Validation

**File:** `lib/env.ts`

```typescript
import { z } from 'zod'

const envSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(1),
  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY: z.string().startsWith('pk_'),
  STRIPE_SECRET_KEY: z.string().startsWith('sk_'),
  STRIPE_WEBHOOK_SECRET: z.string().startsWith('whsec_'),
  NEXT_PUBLIC_SITE_URL: z.string().url(),
})

export const env = envSchema.parse(process.env)
```

---

## 10. Documentation Requirements

### 10.1 Required Documentation Files

All projects must include:

1. **README.md** — Quick start, tech stack, Sacred Four commands
2. **ARCHITECTURE.md** — System design, data flow, key patterns
3. **ONBOARDING.md** — Human team onboarding checklist
4. **ADRs** — Architecture Decision Records in `docs/adr/`

### 10.2 README.md Template

```markdown
# Project Name

Brief description of the project.

## Tech Stack

- **Framework:** Next.js 15 (App Router)
- **Database:** Supabase (Postgres + Auth + Storage)
- **Styling:** Tailwind CSS v4
- **Testing:** Vitest + Playwright
- **Deployment:** Vercel

## Quick Start

```bash
# Install dependencies
pnpm install

# Copy environment variables
cp .env.example .env.local

# Run development server
pnpm dev

# Run tests
pnpm test

# Run Sacred Four
pnpm typecheck && pnpm lint && pnpm test && pnpm build
```

## Sacred Four

All PRs must pass the Sacred Four before merge:

```bash
pnpm typecheck  # TypeScript type checking
pnpm lint       # ESLint + Prettier
pnpm test       # Vitest with coverage (≥70%)
pnpm build      # Next.js production build
```

## Documentation

- **Architecture:** See `docs/ARCHITECTURE.md`
- **Onboarding:** See `docs/ONBOARDING.md`
- **ADRs:** See `docs/adr/`
```

---

## Appendix: Quick Reference

### A.1 Stack Summary

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 15 + React 19 + TypeScript strict |
| Styling | Tailwind CSS v4 + Radix UI + shadcn/ui |
| Database | Supabase Postgres + RLS |
| Auth | Supabase Auth |
| Storage | Supabase Storage |
| Payments | Stripe |
| Testing | Vitest + Playwright |
| CI/CD | GitHub Actions |

### A.2 File Naming Conventions

| File Type | Pattern | Example |
|-----------|---------|---------|
| Page | `page.tsx` | `app/dashboard/page.tsx` |
| Layout | `layout.tsx` | `app/layout.tsx` |
| API Route | `route.ts` | `app/api/users/route.ts` |
| Component | `PascalCase.tsx` | `LoginForm.tsx` |
| Utility | `camelCase.ts` | `formatCurrency.ts` |
| Hook | `use*.ts` | `useAuth.ts` |
| Test | `*.test.ts(x)` | `utils.test.ts` |
| E2E Test | `*.spec.ts` | `auth-flow.spec.ts` |
| Migration | `YYYYMMDD_description.sql` | `20260206_create_users.sql` |

### A.3 Import Order

```typescript
// 1. React
import { useState, useEffect } from 'react'

// 2. Next.js
import { useRouter } from 'next/navigation'
import Image from 'next/image'

// 3. Third-party
import { z } from 'zod'
import { createClient } from '@supabase/supabase-js'

// 4. Internal (aliased)
import { Button } from '@/components/ui/button'
import { createClient as createSupabaseClient } from '@/lib/supabase/client'
import { formatCurrency } from '@/lib/utils/formatters'

// 5. Relative
import { LoginForm } from './LoginForm'
import styles from './styles.module.css'
```

---

*This template defines enterprise-grade SaaS development standards for FORGE projects. Deviations require justification and documentation in ADRs.*

**Last Updated:** 2026-02-06
**Version:** 1.0
**Status:** Operational Template
