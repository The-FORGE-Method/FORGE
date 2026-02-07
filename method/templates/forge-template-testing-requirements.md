<!-- Audience: Public -->

# FORGE Template: Testing Requirements

**Version:** 1.0
**Status:** Operational Template
**For:** Enterprise-grade SaaS testing infrastructure
**Coverage:** 70% minimum, 100% for Sacred Four paths

---

## Overview

This template defines testing philosophy, infrastructure, and requirements for FORGE SaaS projects. Testing is **non-negotiable**—all code must be tested before PR merge.

**Key Principles:**
- **Tests are required** — No code ships without tests
- **70% minimum coverage** — Default threshold for all features
- **100% Sacred Four coverage** — Auth, billing, data integrity, security
- **TDD preferred** — Test-first workflow reduces bugs
- **Test pyramid** — Many unit, some integration, few E2E

---

## Table of Contents

1. [Testing Philosophy](#1-testing-philosophy)
2. [The Test Pyramid](#2-the-test-pyramid)
3. [Coverage Thresholds](#3-coverage-thresholds)
4. [Vitest Setup (Unit + Integration)](#4-vitest-setup-unit--integration)
5. [Playwright Setup (E2E)](#5-playwright-setup-e2e)
6. [TDD Workflow](#6-tdd-workflow)
7. [Sacred Four Paths](#7-sacred-four-paths)
8. [Testing Patterns](#8-testing-patterns)
9. [Continuous Integration](#9-continuous-integration)

---

## 1. Testing Philosophy

### 1.1 Core Beliefs

**Tests are documentation.**
- Tests describe how code should behave
- Future developers read tests to understand intent
- Tests are executable specifications

**Tests enable confidence.**
- Refactoring is safe when tests exist
- Bugs are caught before production
- Features ship faster with test safety net

**Tests are NOT optional.**
- No PR merges without tests
- Coverage thresholds enforced by CI
- Sacred Four paths require 100% coverage

### 1.2 Anti-Patterns (Forbidden)

**Tests-later approach:**
```
❌ Ship feature → Add tests later
- Tests are afterthought
- Harder to write (code not test-friendly)
- Often skipped due to time pressure
```

**This pattern is FORBIDDEN. @E must produce tests during implementation.**

**Manual testing only:**
```
❌ "I tested it manually, it works"
- Not repeatable
- Not automatable
- Not documented
- Breaks when code changes
```

**Manual testing is insufficient. Automated tests required.**

**Mock everything:**
```
❌ Mock database, mock API, mock everything
- Tests don't reflect reality
- Integration bugs slip through
- False confidence
```

**Use real database for integration tests. Mock only external APIs.**

### 1.3 When to Write Tests

**TDD (Test-Driven Development) — Preferred:**
1. Write failing test
2. Implement minimal code to pass
3. Refactor
4. Repeat

**Tests-Alongside — Minimum Acceptable:**
1. Implement feature
2. Write tests immediately after
3. Verify coverage ≥70%

**Tests-Later — Forbidden:**
1. ❌ Ship feature without tests
2. ❌ Add tests "when we have time"

---

## 2. The Test Pyramid

### 2.1 Pyramid Visualization

```
           /\
          /  \
         / E2E \        ← Few (slow, brittle, high-value)
        /--------\
       /          \
      / Integration \   ← Some (medium speed, API + DB)
     /--------------\
    /                \
   /   Unit Tests     \ ← Many (fast, isolated, focused)
  /--------------------\
```

### 2.2 Pyramid Breakdown

| Layer | Count | Speed | Scope | Example |
|-------|-------|-------|-------|---------|
| **Unit** | Many (70%) | <1ms | Single function/component | `formatCurrency(100)` → `"$100.00"` |
| **Integration** | Some (25%) | <100ms | API + database | POST `/api/users` creates user in DB |
| **E2E** | Few (5%) | <5s | Full user flow | Sign up → log in → access dashboard |

### 2.3 When to Use Each Layer

**Unit Tests:**
- Utility functions (formatters, validators, parsers)
- React components (props, rendering, events)
- Business logic (calculations, transformations)
- Edge cases (null, undefined, empty arrays)

**Integration Tests:**
- API routes (request → database → response)
- Database queries (CRUD operations)
- Authentication flows (Supabase Auth)
- RLS policy enforcement

**E2E Tests:**
- Critical user journeys (sign up → onboarding → dashboard)
- Payment flows (checkout → webhook → success)
- Multi-step workflows (create → edit → publish)

### 2.4 Coverage Distribution

**Target distribution (by line count):**
- Unit: 70% of test coverage comes from unit tests
- Integration: 25% from integration tests
- E2E: 5% from E2E tests

**Example project with 1000 lines of code:**
- Unit tests: ~700 lines covered (70%)
- Integration tests: ~250 lines covered (25%)
- E2E tests: ~50 lines covered (5%)
- Total coverage: 100% (overlapping coverage is OK)

---

## 3. Coverage Thresholds

### 3.1 Default Coverage Requirements

**All features: 70% line coverage minimum**

This is enforced by CI:
```bash
pnpm test --coverage
# Vitest will fail if coverage < 70%
```

**Coverage report must show:**
- **Lines:** ≥70%
- **Functions:** ≥70%
- **Branches:** ≥70%
- **Statements:** ≥70%

### 3.2 Sacred Four Paths: 100% Coverage Required

**Sacred Four paths** are security-sensitive, business-critical paths that require **100% test coverage**:

1. **Authentication flows**
   - Sign up, log in, log out
   - Password reset, email verification
   - OAuth flows (Google, GitHub, etc.)
   - Session management, token refresh

2. **Payment processing (Stripe)**
   - Checkout flow
   - Webhook handling
   - Subscription management
   - Refund processing

3. **Data integrity operations**
   - Create/update/delete with validation
   - Database migrations
   - Batch operations
   - Cascade deletes

4. **Security-sensitive paths**
   - Authorization checks (RLS policies)
   - Admin-only actions
   - User data access
   - API key validation

### 3.3 Coverage Enforcement

**Pre-commit hook:**
- Lints and formats staged files
- Does NOT run full test suite (too slow)

**PR validation (CI):**
- Runs full Sacred Four
- Includes `pnpm test --coverage`
- Fails if coverage < 70%
- Posts coverage report to PR

**Merge requirements:**
- Sacred Four must pass
- Coverage threshold must be met
- No exceptions

### 3.4 Coverage Exclusions

**Allowed exclusions (add `/* istanbul ignore next */`):**
- Unreachable error handlers (safety nets)
- Debug-only code paths
- Type guards for third-party libraries
- Development-only utilities

**Not allowed exclusions:**
- Business logic
- API routes
- Database queries
- Component rendering logic

**Example:**

```typescript
// ✅ ALLOWED: Unreachable safety net
async function fetchUser(id: string) {
  const user = await db.users.findUnique({ where: { id } })

  /* istanbul ignore next */
  if (!user) {
    // This should never happen due to foreign key constraints
    throw new Error('User not found (DB integrity issue)')
  }

  return user
}

// ❌ NOT ALLOWED: Business logic
async function createUser(email: string) {
  /* istanbul ignore next */
  if (!isValidEmail(email)) {
    throw new Error('Invalid email')
  }

  return db.users.create({ data: { email } })
}
```

---

## 4. Vitest Setup (Unit + Integration)

### 4.1 Vitest Configuration

**File:** `vitest.config.ts`

```typescript
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./tests/setup.ts'],
    include: ['tests/**/*.{test,spec}.{ts,tsx}'],
    exclude: ['tests/e2e/**/*', 'node_modules', '.next'],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html', 'lcov'],
      include: ['src/**/*.{ts,tsx}'],
      exclude: [
        'src/**/*.d.ts',
        'src/**/*.config.{ts,js}',
        'src/app/layout.tsx',
        'src/app/globals.css',
      ],
      thresholds: {
        lines: 70,
        functions: 70,
        branches: 70,
        statements: 70,
      },
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
})
```

### 4.2 Vitest Setup File

**File:** `tests/setup.ts`

```typescript
import { beforeAll, afterAll, afterEach } from 'vitest'
import { cleanup } from '@testing-library/react'
import '@testing-library/jest-dom/vitest'

// Cleanup after each test
afterEach(() => {
  cleanup()
})

// Mock Next.js router
vi.mock('next/navigation', () => ({
  useRouter() {
    return {
      push: vi.fn(),
      replace: vi.fn(),
      prefetch: vi.fn(),
      back: vi.fn(),
      pathname: '/',
      query: {},
      asPath: '/',
    }
  },
  useSearchParams() {
    return new URLSearchParams()
  },
  usePathname() {
    return '/'
  },
}))

// Mock environment variables
process.env.NEXT_PUBLIC_SUPABASE_URL = 'http://localhost:54321'
process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = 'test-anon-key'
```

### 4.3 Unit Test Example

**File:** `tests/unit/lib/utils.test.ts`

```typescript
import { describe, it, expect } from 'vitest'
import { formatCurrency, cn } from '@/lib/utils'

describe('formatCurrency', () => {
  it('formats positive numbers correctly', () => {
    expect(formatCurrency(1000)).toBe('$1,000.00')
    expect(formatCurrency(100.5)).toBe('$100.50')
    expect(formatCurrency(0)).toBe('$0.00')
  })

  it('handles negative numbers', () => {
    expect(formatCurrency(-500)).toBe('-$500.00')
  })

  it('rounds to two decimal places', () => {
    expect(formatCurrency(10.999)).toBe('$11.00')
    expect(formatCurrency(10.001)).toBe('$10.00')
  })

  it('handles very large numbers', () => {
    expect(formatCurrency(1000000)).toBe('$1,000,000.00')
  })
})

describe('cn (className utility)', () => {
  it('merges class names', () => {
    expect(cn('foo', 'bar')).toBe('foo bar')
  })

  it('handles conditional classes', () => {
    expect(cn('foo', false && 'bar', 'baz')).toBe('foo baz')
    expect(cn('foo', true && 'bar')).toBe('foo bar')
  })

  it('deduplicates Tailwind classes', () => {
    expect(cn('px-4', 'px-2')).toBe('px-2') // Later class wins
    expect(cn('text-red-500', 'text-blue-500')).toBe('text-blue-500')
  })

  it('handles arrays', () => {
    expect(cn(['foo', 'bar'], 'baz')).toBe('foo bar baz')
  })

  it('handles objects', () => {
    expect(cn({ foo: true, bar: false, baz: true })).toBe('foo baz')
  })
})
```

### 4.4 Component Test Example

**File:** `tests/unit/components/Button.test.tsx`

```typescript
import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { Button } from '@/components/ui/button'

describe('Button', () => {
  it('renders children correctly', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByRole('button')).toHaveTextContent('Click me')
  })

  it('calls onClick when clicked', async () => {
    const handleClick = vi.fn()
    const user = userEvent.setup()

    render(<Button onClick={handleClick}>Click me</Button>)
    await user.click(screen.getByRole('button'))

    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('does not call onClick when disabled', async () => {
    const handleClick = vi.fn()
    const user = userEvent.setup()

    render(<Button onClick={handleClick} disabled>Click me</Button>)
    await user.click(screen.getByRole('button'))

    expect(handleClick).not.toHaveBeenCalled()
  })

  it('disables button when disabled prop is true', () => {
    render(<Button disabled>Click me</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })

  it('applies variant classes correctly', () => {
    const { container } = render(<Button variant="destructive">Delete</Button>)
    const button = container.querySelector('button')
    expect(button).toHaveClass('bg-destructive')
  })

  it('applies size classes correctly', () => {
    const { container } = render(<Button size="sm">Small</Button>)
    const button = container.querySelector('button')
    expect(button).toHaveClass('h-9')
  })

  it('renders as child component when asChild is true', () => {
    render(
      <Button asChild>
        <a href="/test">Link</a>
      </Button>
    )
    expect(screen.getByRole('link')).toHaveAttribute('href', '/test')
  })
})
```

### 4.5 Integration Test Example

**File:** `tests/integration/api/auth.test.ts`

```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest'
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY! // Service role for testing
)

describe('Auth API Integration', () => {
  let testUserId: string | null = null

  afterEach(async () => {
    // Cleanup: Delete test user
    if (testUserId) {
      await supabase.auth.admin.deleteUser(testUserId)
      testUserId = null
    }
  })

  it('creates user with valid email and password', async () => {
    const { data, error } = await supabase.auth.signUp({
      email: `test-${Date.now()}@example.com`,
      password: 'SecurePassword123!',
    })

    expect(error).toBeNull()
    expect(data.user).toBeDefined()
    expect(data.user!.email).toMatch(/test-.*@example.com/)

    testUserId = data.user!.id
  })

  it('rejects weak password', async () => {
    const { error } = await supabase.auth.signUp({
      email: `test-${Date.now()}@example.com`,
      password: '123', // Too short
    })

    expect(error).toBeDefined()
    expect(error!.message).toMatch(/password/i)
  })

  it('rejects duplicate email', async () => {
    const email = `test-${Date.now()}@example.com`

    // First signup succeeds
    const { data: user1 } = await supabase.auth.signUp({
      email,
      password: 'SecurePassword123!',
    })
    testUserId = user1.user!.id

    // Second signup with same email fails
    const { error } = await supabase.auth.signUp({
      email,
      password: 'DifferentPassword456!',
    })

    expect(error).toBeDefined()
    expect(error!.message).toMatch(/already registered/i)
  })

  it('enforces RLS policy (users can only read own data)', async () => {
    // Create two users
    const { data: user1 } = await supabase.auth.signUp({
      email: `user1-${Date.now()}@example.com`,
      password: 'Password123!',
    })

    const { data: user2 } = await supabase.auth.signUp({
      email: `user2-${Date.now()}@example.com`,
      password: 'Password123!',
    })

    // User 1 creates a property
    const supabaseUser1 = createClient(
      process.env.SUPABASE_URL!,
      process.env.SUPABASE_ANON_KEY!,
      {
        global: {
          headers: {
            Authorization: `Bearer ${user1.session!.access_token}`,
          },
        },
      }
    )

    const { data: property } = await supabaseUser1
      .from('properties')
      .insert({ title: 'User 1 Property', price: 100000 })
      .select()
      .single()

    // User 2 tries to read User 1's property (should fail due to RLS)
    const supabaseUser2 = createClient(
      process.env.SUPABASE_URL!,
      process.env.SUPABASE_ANON_KEY!,
      {
        global: {
          headers: {
            Authorization: `Bearer ${user2.session!.access_token}`,
          },
        },
      }
    )

    const { data: fetchedProperty } = await supabaseUser2
      .from('properties')
      .select('*')
      .eq('id', property!.id)
      .single()

    expect(fetchedProperty).toBeNull() // RLS blocks access

    // Cleanup
    testUserId = user1.user!.id
    await supabase.auth.admin.deleteUser(user2.user!.id)
  })
})
```

---

## 5. Playwright Setup (E2E)

### 5.1 Playwright Configuration

**File:** `playwright.config.ts`

```typescript
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ['list'],
    ['junit', { outputFile: 'test-results/junit.xml' }],
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'mobile-chrome',
      use: { ...devices['Pixel 5'] },
    },
  ],
  webServer: {
    command: 'pnpm dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
})
```

### 5.2 E2E Test Example

**File:** `tests/e2e/auth-flow.spec.ts`

```typescript
import { test, expect } from '@playwright/test'

test.describe('Authentication Flow', () => {
  test('user can sign up, log in, and access dashboard', async ({ page }) => {
    const email = `test-${Date.now()}@example.com`
    const password = 'SecurePassword123!'

    // Navigate to signup page
    await page.goto('/signup')

    // Fill signup form
    await page.fill('input[name="email"]', email)
    await page.fill('input[name="password"]', password)
    await page.fill('input[name="confirmPassword"]', password)
    await page.click('button[type="submit"]')

    // Should redirect to dashboard after signup
    await expect(page).toHaveURL('/dashboard')
    await expect(page.locator('h1')).toContainText('Dashboard')

    // Log out
    await page.click('button:has-text("Log out")')
    await expect(page).toHaveURL('/')

    // Log back in
    await page.goto('/login')
    await page.fill('input[name="email"]', email)
    await page.fill('input[name="password"]', password)
    await page.click('button[type="submit"]')

    // Should be back at dashboard
    await expect(page).toHaveURL('/dashboard')
    await expect(page.locator('h1')).toContainText('Dashboard')
  })

  test('user cannot access dashboard without authentication', async ({ page }) => {
    await page.goto('/dashboard')

    // Should redirect to login
    await expect(page).toHaveURL('/login')
  })

  test('displays error for invalid credentials', async ({ page }) => {
    await page.goto('/login')

    await page.fill('input[name="email"]', 'nonexistent@example.com')
    await page.fill('input[name="password"]', 'WrongPassword123!')
    await page.click('button[type="submit"]')

    // Should show error message
    await expect(page.locator('text=Invalid credentials')).toBeVisible()

    // Should still be on login page
    await expect(page).toHaveURL('/login')
  })

  test('validates email format', async ({ page }) => {
    await page.goto('/signup')

    await page.fill('input[name="email"]', 'not-an-email')
    await page.fill('input[name="password"]', 'Password123!')
    await page.fill('input[name="confirmPassword"]', 'Password123!')
    await page.click('button[type="submit"]')

    // Should show validation error
    await expect(page.locator('text=Invalid email')).toBeVisible()
  })

  test('validates password strength', async ({ page }) => {
    await page.goto('/signup')

    await page.fill('input[name="email"]', 'test@example.com')
    await page.fill('input[name="password"]', '123') // Too weak
    await page.fill('input[name="confirmPassword"]', '123')
    await page.click('button[type="submit"]')

    // Should show validation error
    await expect(page.locator('text=Password must be at least 8 characters')).toBeVisible()
  })
})
```

---

## 6. TDD Workflow

### 6.1 Red-Green-Refactor Cycle

**Step 1: Red (Write failing test)**

```typescript
// tests/unit/lib/slugify.test.ts
import { describe, it, expect } from 'vitest'
import { slugify } from '@/lib/utils/slugify'

describe('slugify', () => {
  it('converts text to URL-safe slug', () => {
    expect(slugify('Hello World')).toBe('hello-world')
  })
})

// ❌ Test fails: slugify function doesn't exist yet
```

**Step 2: Green (Implement minimal code to pass)**

```typescript
// src/lib/utils/slugify.ts
export function slugify(text: string): string {
  return text.toLowerCase().replace(/\s+/g, '-')
}

// ✅ Test passes
```

**Step 3: Refactor (Improve code quality)**

```typescript
// Add more test cases
describe('slugify', () => {
  it('converts text to URL-safe slug', () => {
    expect(slugify('Hello World')).toBe('hello-world')
  })

  it('handles multiple spaces', () => {
    expect(slugify('Hello   World')).toBe('hello-world')
  })

  it('removes special characters', () => {
    expect(slugify('Hello, World!')).toBe('hello-world')
  })

  it('handles empty string', () => {
    expect(slugify('')).toBe('')
  })
})

// Refactor implementation
export function slugify(text: string): string {
  return text
    .toLowerCase()
    .trim()
    .replace(/[^\w\s-]/g, '') // Remove special chars
    .replace(/\s+/g, '-')      // Replace spaces with hyphens
    .replace(/-+/g, '-')       // Replace multiple hyphens with single
}

// ✅ All tests pass
```

### 6.2 TDD Benefits

**Benefit 1: Better API design**
- Writing tests first forces you to think about API usability
- Results in cleaner, more intuitive interfaces

**Benefit 2: Higher coverage**
- Code is test-friendly by design
- All paths covered because tests written first

**Benefit 3: Faster debugging**
- When test fails, you know exactly what broke
- No need to reproduce bugs manually

**Benefit 4: Refactoring confidence**
- Tests ensure behavior stays consistent
- Safe to improve code structure

---

## 7. Sacred Four Paths

### 7.1 What Are Sacred Four Paths?

**Sacred Four paths** are security-sensitive, business-critical code paths that require **100% test coverage**.

### 7.2 Authentication Flows

**All auth flows must have 100% coverage:**

```typescript
// ✅ REQUIRED: Test every auth path
describe('Authentication', () => {
  it('allows valid sign up', async () => { /* ... */ })
  it('rejects invalid email', async () => { /* ... */ })
  it('rejects weak password', async () => { /* ... */ })
  it('rejects duplicate email', async () => { /* ... */ })
  it('sends verification email', async () => { /* ... */ })
  it('allows valid login', async () => { /* ... */ })
  it('rejects invalid credentials', async () => { /* ... */ })
  it('logs out user', async () => { /* ... */ })
  it('refreshes expired token', async () => { /* ... */ })
  it('prevents session hijacking', async () => { /* ... */ })
})
```

### 7.3 Payment Processing

**All Stripe flows must have 100% coverage:**

```typescript
describe('Stripe Checkout', () => {
  it('creates checkout session', async () => { /* ... */ })
  it('validates webhook signature', async () => { /* ... */ })
  it('handles successful payment', async () => { /* ... */ })
  it('handles failed payment', async () => { /* ... */ })
  it('handles refund', async () => { /* ... */ })
  it('prevents duplicate charges (idempotency)', async () => { /* ... */ })
  it('updates subscription status', async () => { /* ... */ })
})
```

### 7.4 Data Integrity

**All CRUD with validation must have 100% coverage:**

```typescript
describe('User CRUD', () => {
  it('creates user with valid data', async () => { /* ... */ })
  it('rejects user with invalid email', async () => { /* ... */ })
  it('updates user data', async () => { /* ... */ })
  it('prevents unauthorized updates (RLS)', async () => { /* ... */ })
  it('deletes user and cascades', async () => { /* ... */ })
  it('prevents unauthorized deletes (RLS)', async () => { /* ... */ })
})
```

### 7.5 Security-Sensitive Paths

**All authorization checks must have 100% coverage:**

```typescript
describe('RLS Policies', () => {
  it('allows user to read own data', async () => { /* ... */ })
  it('prevents user from reading others data', async () => { /* ... */ })
  it('allows admin to read all data', async () => { /* ... */ })
  it('prevents non-admin from admin actions', async () => { /* ... */ })
})
```

---

## 8. Testing Patterns

### 8.1 Arrange-Act-Assert (AAA)

```typescript
it('creates user with valid data', async () => {
  // ARRANGE: Set up test data and dependencies
  const userData = {
    email: 'test@example.com',
    name: 'Test User',
  }

  // ACT: Execute the code under test
  const user = await createUser(userData)

  // ASSERT: Verify the outcome
  expect(user.email).toBe('test@example.com')
  expect(user.name).toBe('Test User')
  expect(user.id).toBeDefined()
})
```

### 8.2 Test Fixtures

```typescript
// tests/fixtures/users.ts
export const validUser = {
  email: 'valid@example.com',
  password: 'SecurePassword123!',
  name: 'Valid User',
}

export const invalidUser = {
  email: 'not-an-email',
  password: '123',
  name: '',
}

// Use in tests
import { validUser, invalidUser } from '../fixtures/users'

it('creates user with valid data', async () => {
  const user = await createUser(validUser)
  expect(user.email).toBe(validUser.email)
})
```

### 8.3 Test Utilities

```typescript
// tests/utils/db.ts
export async function createTestUser(overrides = {}) {
  return supabase.auth.signUp({
    email: `test-${Date.now()}@example.com`,
    password: 'TestPassword123!',
    ...overrides,
  })
}

export async function cleanupTestUser(userId: string) {
  await supabase.auth.admin.deleteUser(userId)
}

// Use in tests
import { createTestUser, cleanupTestUser } from '../utils/db'

it('allows user to update own profile', async () => {
  const { data: { user } } = await createTestUser()

  // Test logic...

  await cleanupTestUser(user!.id)
})
```

---

## 9. Continuous Integration

### 9.1 CI Test Workflow

**File:** `.github/workflows/pr-validation.yml`

```yaml
name: PR Validation (Sacred Four)

on:
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    timeout-minutes: 15

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 8

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Type check
        run: pnpm typecheck

      - name: Lint
        run: pnpm lint

      - name: Test with coverage
        run: pnpm test --coverage
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_TEST_URL }}
          SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_TEST_ANON_KEY }}
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_TEST_SERVICE_ROLE_KEY }}

      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json
          fail_ci_if_error: true

      - name: Build
        run: pnpm build
```

### 9.2 Coverage Reporting

**CI posts coverage report to PR:**

```markdown
## Test Coverage Report

**Overall:** 86.6% (+8.3% from base)

| Category | Coverage | Threshold | Status |
|----------|----------|-----------|--------|
| Lines | 86.6% | 70% | ✅ PASS |
| Functions | 88.2% | 70% | ✅ PASS |
| Branches | 82.1% | 70% | ✅ PASS |
| Statements | 86.3% | 70% | ✅ PASS |

**Sacred Four Paths:** 100% coverage ✅

**Files below threshold:** None
```

---

## Appendix: Quick Reference

### A.1 Test Commands

```bash
# Run all tests
pnpm test

# Run tests with coverage
pnpm test --coverage

# Run tests in watch mode
pnpm test --watch

# Run tests with UI
pnpm test --ui

# Run E2E tests
pnpm playwright test

# Run E2E tests with UI
pnpm playwright test --ui
```

### A.2 Coverage Thresholds

| Path Type | Threshold | Enforcement |
|-----------|-----------|-------------|
| Default | 70% | CI fails if below |
| Sacred Four (Auth) | 100% | CI fails if below |
| Sacred Four (Billing) | 100% | CI fails if below |
| Sacred Four (Data Integrity) | 100% | CI fails if below |
| Sacred Four (Security) | 100% | CI fails if below |

### A.3 Test Pyramid Ratios

| Layer | Percentage | Speed | Scope |
|-------|------------|-------|-------|
| Unit | 70% | <1ms | Function |
| Integration | 25% | <100ms | API + DB |
| E2E | 5% | <5s | User flow |

---

*This template defines enterprise-grade testing requirements for FORGE SaaS projects. 70% minimum coverage, 100% for Sacred Four paths.*

**Last Updated:** 2026-02-06
**Version:** 1.0
**Status:** Operational Template
