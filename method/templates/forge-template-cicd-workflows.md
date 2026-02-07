<!-- Audience: Public -->

# FORGE Template: CI/CD Workflows

**Version:** 1.0
**Status:** Operational Template
**For:** GitHub Actions CI/CD pipelines
**Platform:** Vercel deployment + Supabase

---

## Overview

This template defines CI/CD workflows for FORGE SaaS projects using GitHub Actions, Vercel deployment, and Supabase migrations.

**Key Principles:**
- **Sacred Four enforced on PRs** — typecheck, lint, test, build must pass
- **Preview deployments automatic** — Every PR gets preview URL
- **Production deploys on main** — Merge to main triggers deployment
- **Database migrations automated** — Supabase migrations run on deploy

---

## Table of Contents

1. [PR Validation Workflow](#1-pr-validation-workflow)
2. [Deploy Preview Workflow](#2-deploy-preview-workflow)
3. [Production Deployment Workflow](#3-production-deployment-workflow)
4. [Environment Configuration](#4-environment-configuration)
5. [Merge Requirements](#5-merge-requirements)
6. [Rollback Procedures](#6-rollback-procedures)

---

## 1. PR Validation Workflow

### 1.1 Overview

**Triggers:** Pull request to `main` or `develop` branches
**Purpose:** Enforce Sacred Four before merge
**Timeout:** 15 minutes

### 1.2 Workflow File

**File:** `.github/workflows/pr-validation.yml`

```yaml
name: PR Validation (Sacred Four)

on:
  pull_request:
    branches: [main, develop]

jobs:
  validate:
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
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.SUPABASE_TEST_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_TEST_ANON_KEY }}

      - name: Comment PR with results
        if: always()
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const coveragePath = './coverage/coverage-summary.json';

            let comment = '## Sacred Four Results\n\n';

            // Check if coverage file exists
            if (fs.existsSync(coveragePath)) {
              const coverage = JSON.parse(fs.readFileSync(coveragePath, 'utf8'));
              const total = coverage.total;

              comment += `✅ **Type check**: PASS\n`;
              comment += `✅ **Lint**: PASS\n`;
              comment += `✅ **Test**: PASS\n`;
              comment += `✅ **Build**: PASS\n\n`;
              comment += `### Coverage\n`;
              comment += `- Lines: ${total.lines.pct}%\n`;
              comment += `- Functions: ${total.functions.pct}%\n`;
              comment += `- Branches: ${total.branches.pct}%\n`;
              comment += `- Statements: ${total.statements.pct}%\n`;
            } else {
              comment += `⚠️ Coverage report not found\n`;
            }

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: comment
            });
```

### 1.3 Required Secrets

Configure these secrets in GitHub repository settings:

| Secret | Description | Example |
|--------|-------------|---------|
| `SUPABASE_TEST_URL` | Supabase project URL (test environment) | `https://xxx.supabase.co` |
| `SUPABASE_TEST_ANON_KEY` | Supabase anon key (test) | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |
| `SUPABASE_TEST_SERVICE_ROLE_KEY` | Supabase service role key (test) | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |

---

## 2. Deploy Preview Workflow

### 2.1 Overview

**Triggers:** Pull request to `main` or `develop` branches
**Purpose:** Deploy preview to Vercel for QA
**Timeout:** 10 minutes
**Result:** Preview URL posted to PR

### 2.2 Workflow File

**File:** `.github/workflows/deploy-preview.yml`

```yaml
name: Deploy Preview

on:
  pull_request:
    branches: [main, develop]

jobs:
  deploy-preview:
    runs-on: ubuntu-latest
    timeout-minutes: 10

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

      - name: Build
        run: pnpm build
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.SUPABASE_STAGING_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_STAGING_ANON_KEY }}

      - name: Deploy to Vercel (Preview)
        uses: amondnet/vercel-action@v25
        id: vercel-deploy
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          scope: ${{ secrets.VERCEL_ORG_ID }}
          alias-domains: |
            pr-${{ github.event.pull_request.number }}.staging.example.com

      - name: Comment PR with preview URL
        uses: actions/github-script@v7
        with:
          script: |
            const comment = `## Preview Deployment

            🚀 **Preview URL**: ${{ steps.vercel-deploy.outputs.preview-url }}
            🔗 **Alias**: https://pr-${{ github.event.pull_request.number }}.staging.example.com

            Your changes are live for review!
            `;

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: comment
            });
```

### 2.3 Required Secrets

| Secret | Description | Example |
|--------|-------------|---------|
| `SUPABASE_STAGING_URL` | Supabase project URL (staging) | `https://staging.supabase.co` |
| `SUPABASE_STAGING_ANON_KEY` | Supabase anon key (staging) | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |
| `VERCEL_TOKEN` | Vercel API token | `xxx...` |
| `VERCEL_ORG_ID` | Vercel organization ID | `team_xxx` |
| `VERCEL_PROJECT_ID` | Vercel project ID | `prj_xxx` |

---

## 3. Production Deployment Workflow

### 3.1 Overview

**Triggers:** Push to `main` branch
**Purpose:** Deploy to production
**Timeout:** 20 minutes
**Includes:** Supabase migrations

### 3.2 Workflow File

**File:** `.github/workflows/production-deploy.yml`

```yaml
name: Production Deploy

on:
  push:
    branches: [main]

jobs:
  deploy-production:
    runs-on: ubuntu-latest
    timeout-minutes: 20
    environment: production

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

      - name: Run Sacred Four
        run: pnpm typecheck && pnpm lint && pnpm test && pnpm build
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.SUPABASE_PROD_URL }}
          NEXT_PUBLIC_SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_PROD_ANON_KEY }}
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_PROD_SERVICE_ROLE_KEY }}

      - name: Deploy to Vercel (Production)
        uses: amondnet/vercel-action@v25
        id: vercel-deploy
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
          scope: ${{ secrets.VERCEL_ORG_ID }}

      - name: Run Supabase migrations
        run: pnpm supabase db push --project-ref ${{ secrets.SUPABASE_PROJECT_REF }}
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}

      - name: Notify deployment success
        if: success()
        uses: actions/github-script@v7
        with:
          script: |
            console.log('Production deployment successful!');
            console.log('URL: ${{ steps.vercel-deploy.outputs.preview-url }}');

      - name: Rollback on failure
        if: failure()
        run: |
          echo "Deployment failed. Rolling back..."
          # Vercel automatic rollback on failure
          # Supabase migrations require manual rollback (run down migrations)
```

### 3.3 Required Secrets

| Secret | Description | Example |
|--------|-------------|---------|
| `SUPABASE_PROD_URL` | Supabase project URL (production) | `https://prod.supabase.co` |
| `SUPABASE_PROD_ANON_KEY` | Supabase anon key (production) | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |
| `SUPABASE_PROD_SERVICE_ROLE_KEY` | Supabase service role key (prod) | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |
| `SUPABASE_PROJECT_REF` | Supabase project reference | `abc123xyz` |
| `SUPABASE_ACCESS_TOKEN` | Supabase CLI access token | `sbp_xxx...` |
| `VERCEL_TOKEN` | Vercel API token | `xxx...` |
| `VERCEL_ORG_ID` | Vercel organization ID | `team_xxx` |
| `VERCEL_PROJECT_ID` | Vercel project ID | `prj_xxx` |

---

## 4. Environment Configuration

### 4.1 Environment Overview

| Environment | Branch | Supabase Project | Vercel Deployment |
|-------------|--------|------------------|-------------------|
| **Development** | Local | Local (Docker) | `localhost:3000` |
| **Test** | PR | Test project | — |
| **Staging** | PR | Staging project | Preview URL |
| **Production** | `main` | Production project | `example.com` |

### 4.2 Environment-Specific Variables

**Development (`.env.local`):**
```bash
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ... (local key)
SUPABASE_SERVICE_ROLE_KEY=eyJ... (local key)
```

**Test (CI secrets):**
```bash
SUPABASE_TEST_URL=https://test.supabase.co
SUPABASE_TEST_ANON_KEY=eyJ... (test key)
SUPABASE_TEST_SERVICE_ROLE_KEY=eyJ... (test key)
```

**Staging (CI secrets):**
```bash
SUPABASE_STAGING_URL=https://staging.supabase.co
SUPABASE_STAGING_ANON_KEY=eyJ... (staging key)
```

**Production (CI secrets + GitHub environment protection):**
```bash
SUPABASE_PROD_URL=https://prod.supabase.co
SUPABASE_PROD_ANON_KEY=eyJ... (prod key)
SUPABASE_PROD_SERVICE_ROLE_KEY=eyJ... (prod key)
```

---

## 5. Merge Requirements

### 5.1 Branch Protection Rules

**`main` branch:**
- [ ] Require pull request before merging
- [ ] Require approvals: 1 (Human Lead)
- [ ] Require status checks to pass before merging:
  - [ ] `validate` (Sacred Four)
  - [ ] `deploy-preview` (Preview deployment)
- [ ] Require branches to be up to date before merging
- [ ] Do not allow bypassing the above settings

**`develop` branch (optional):**
- [ ] Require pull request before merging
- [ ] Require status checks to pass before merging:
  - [ ] `validate` (Sacred Four)
- [ ] Require branches to be up to date before merging

### 5.2 Status Checks

| Check | Workflow | Purpose | Failure Action |
|-------|----------|---------|----------------|
| **typecheck** | `pr-validation.yml` | TypeScript type safety | Fix type errors |
| **lint** | `pr-validation.yml` | Code style (ESLint + Prettier) | Fix linting errors |
| **test** | `pr-validation.yml` | Correctness + coverage | Fix failing tests |
| **build** | `pr-validation.yml` | Deployability | Fix build errors |
| **deploy-preview** | `deploy-preview.yml` | Preview deployment | Fix deployment issues |

### 5.3 Merge Checklist

Before merging PR to `main`:

- [ ] Sacred Four passes (typecheck, lint, test, build)
- [ ] Coverage ≥70% (100% for Sacred Four paths)
- [ ] Preview deployment successful
- [ ] Manual QA completed on preview URL
- [ ] Human Lead approval obtained
- [ ] Branch up to date with `main`

---

## 6. Rollback Procedures

### 6.1 Application Rollback (Vercel)

**Automatic rollback:**
- Vercel automatically rolls back to previous deployment on failure
- No manual intervention required for application code

**Manual rollback:**

```bash
# 1. List recent deployments
vercel ls <project-name>

# 2. Promote previous deployment to production
vercel promote <deployment-url> --scope <team-name>

# 3. Verify rollback
curl https://example.com
```

### 6.2 Database Rollback (Supabase)

**Manual rollback procedure:**

```bash
# 1. Identify failed migration
pnpm supabase migration list

# 2. Create down migration
pnpm supabase migration new rollback_<original_migration_name>

# 3. Write rollback SQL
# Example: supabase/migrations/20260206_rollback_add_properties.sql
DROP TABLE IF EXISTS public.properties CASCADE;

# 4. Run rollback migration
pnpm supabase db push --project-ref <PROJECT_REF>

# 5. Verify database state
pnpm supabase db diff --project-ref <PROJECT_REF>
```

### 6.3 Rollback Checklist

- [ ] Identify failure point (application vs database)
- [ ] Verify previous deployment is stable
- [ ] Roll back application (Vercel promote)
- [ ] Roll back database (down migration)
- [ ] Verify rollback in production
- [ ] Notify team of rollback
- [ ] Post-mortem: Document failure cause
- [ ] Create fix in new PR

---

## Appendix A: CI/CD Ownership Model

### A.1 Ownership Matrix

| Responsibility | Owner | Backup |
|----------------|-------|--------|
| **Workflow maintenance** | @G (Ops Agent) | Human Lead |
| **Secret management** | Human Lead | — |
| **Environment config** | @G + Human Lead | — |
| **Deployment approval** | Human Lead | — |
| **Rollback execution** | Human Lead | @G |

### A.2 Workflow Modification Protocol

**To modify CI/CD workflows:**

1. **Propose change** — Create issue describing need
2. **Review** — @G + Human Lead review
3. **Test** — Test in fork or feature branch
4. **Approve** — Human Lead approves
5. **Merge** — Merge to `main` via PR
6. **Verify** — Verify workflow runs successfully

**Workflow changes are code changes** — same review process applies.

---

## Appendix B: Secrets Setup Guide

### B.1 GitHub Secrets Setup

**Navigate to:** `https://github.com/<org>/<repo>/settings/secrets/actions`

**Add secrets:**

```bash
# Supabase (Test)
SUPABASE_TEST_URL
SUPABASE_TEST_ANON_KEY
SUPABASE_TEST_SERVICE_ROLE_KEY

# Supabase (Staging)
SUPABASE_STAGING_URL
SUPABASE_STAGING_ANON_KEY

# Supabase (Production)
SUPABASE_PROD_URL
SUPABASE_PROD_ANON_KEY
SUPABASE_PROD_SERVICE_ROLE_KEY
SUPABASE_PROJECT_REF
SUPABASE_ACCESS_TOKEN

# Vercel
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID
```

### B.2 Vercel Secrets Retrieval

```bash
# Install Vercel CLI
pnpm add -g vercel

# Login
vercel login

# Get org ID and project ID
vercel link

# Generate token
# Navigate to: https://vercel.com/account/tokens
```

### B.3 Supabase Secrets Retrieval

```bash
# Install Supabase CLI
brew install supabase/tap/supabase

# Login
supabase login

# Get project details
supabase projects list

# Get project ref
supabase link --project-ref <PROJECT_REF>

# Get access token
# Navigate to: https://supabase.com/dashboard/account/tokens
```

---

*This template defines CI/CD workflows for FORGE SaaS projects using GitHub Actions, Vercel, and Supabase.*

**Last Updated:** 2026-02-06
**Version:** 1.0
**Status:** Operational Template
