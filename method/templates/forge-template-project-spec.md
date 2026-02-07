# FORGE Project Template Specification

**The Blueprint for Project Instantiation**

**Version:** 1.1
**Status:** Canonical Specification
**Implementer:** CC (Quality Gate)

---

## Purpose

This specification defines the **exact structure** CC must create when instantiating a new FORGE project. It is a spec, not a repo - CC implements this mechanically.

**This document answers:** "What does a FORGE project look like on disk before any code is written?"

---

## Intended Consumer

**CC (Claude Code / Quality Gate)** reads this specification and creates the directory structure, placeholder files, and configuration files exactly as defined.

CC does not interpret or extend this specification. If something is ambiguous, CC escalates to Human Lead.

---

## Assumptions

- Target environment: [Your development machine and projects directory]
- CC has access to create directories and files
- Constitutional documents arrive separately (from CP via Leo)
- This spec covers structure only, not content
- FORGE-SD profile is the default execution profile

---

## Directory Structure

```
[project-codename]/
|
+-- .cursor/
|   +-- rules/
|       +-- forge-sd.mdc           # Cursor rules (FORGE-SD profile)
|
+-- .github/
|   +-- PULL_REQUEST_TEMPLATE.md   # PR template
|
+-- inbox/
|   +-- active/                    # Current task briefs (one at a time)
|   |   +-- .gitkeep
|   +-- completed/                 # Archived briefs (one per merged PR)
|   |   +-- .gitkeep
|   +-- templates/                 # Reusable brief templates
|       +-- task-brief-template.md
|
+-- docs/
|   +-- constitution/              # Constitutional documents (READ-ONLY during Execute)
|   |   +-- north-star.md          # Product intent (Level 1)
|   |   +-- system-architecture.md # Technical structure (Level 2)
|   |   +-- data-model.md          # Schema and relationships (Level 3)
|   |   +-- api-contract.md        # All endpoints (Level 3)
|   |   +-- security-policies.md   # Auth, RLS, permissions (Level 3)
|   |   +-- engineering-playbook.md # Standards (Level 2)
|   +-- decisions/                 # ADRs and decision records
|   |   +-- .gitkeep
|   +-- build-plan.md              # Execution state (CC maintains)
|
+-- src/                           # Application source (stack-specific)
|   +-- .gitkeep
|
+-- supabase/                      # Database artifacts (if using Supabase)
|   +-- migrations/                # SQL migrations (CC generates from data-model.md)
|   |   +-- .gitkeep
|   +-- seed/                      # Development seed data
|       +-- .gitkeep
|
+-- tests/                         # Test files
|   +-- .gitkeep
|
+-- .env.example                   # Environment variable template
+-- .gitignore                     # Standard ignores
+-- CLAUDE.md                      # Project identity (CC's operating context)
+-- package.json                   # Dependencies (stack-specific)
+-- README.md                      # Public-facing readme
+-- tsconfig.json                  # TypeScript config (if applicable)
```

---

## Required Files

### Root Level

#### `CLAUDE.md`
**Purpose:** Project identity file. The first thing CC reads at session start.

**Content:** Derived from the Project Identity Template, populated with project-specific values from the Kickoff Brief and constitutional documents.

**Owner:** CC creates initially; Human Lead approves modifications.

**Authority Rule:** If `CLAUDE.md` conflicts with any document in `docs/constitution/`, the constitutional document is authoritative and `CLAUDE.md` must be updated.

**Template Reference:** See `forge-template-project-identity.md`

**Required Sections:**
- Project Identity (what/not/who)
- FORGE Context (phase, profile, key principles)
- Commands (especially verification sequence)
- Authority & Boundaries
- Current State
- Getting Oriented

---

#### `README.md`
**Purpose:** Public-facing project description.

**Content:**
```markdown
# [Project Name]

[One-line description from Kickoff Brief]

## Overview

[2-3 sentences from Intent Summary]

## Status

**Phase:** [Frame | Orchestrate | Refine | Govern | Execute]

## Quick Start

[Placeholder until Execute begins]

## Documentation

- [Constitutional Documents](docs/constitution/)
- [Build Plan](docs/build-plan.md)

---

*This project follows The FORGE Method(TM) - theforgemethod.org*
```

---

#### `.env.example`
**Purpose:** Template for environment variables.

**Content:**
```bash
# [Project Name] Environment Variables
# Copy to .env.local and fill in values

# Database (Supabase)
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Authentication
# [Add auth-specific vars]

# External Services
# [Add service-specific vars]

# Feature Flags
# [Add feature flags]
```

**Note:** Actual secrets are never committed. This file documents what's needed.

---

#### `.gitignore`
**Purpose:** Standard ignores for the stack.

**Content (Next.js/TypeScript baseline):**
```
# Dependencies
node_modules/
.pnpm-store/

# Build outputs
.next/
out/
dist/
build/

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*
pnpm-debug.log*

# Testing
coverage/
.nyc_output/

# Supabase
supabase/.branches/
supabase/.temp/
```

---

### Cursor Configuration

#### `.cursor/rules/forge-sd.mdc`
**Purpose:** Cursor's operating rules for FORGE-SD projects.

**Content:** See FORGE-SD Profile for full specification.

**Key behaviors:**
- Read `CLAUDE.md` before any work
- Follow task briefs in `inbox/active/`
- Never modify `docs/constitution/` without approval
- Run Sacred Four before claiming completion

---

### AI Prompts Directory

#### `inbox/templates/task-brief-template.md`
**Purpose:** Template for task briefs written by CC.

**Content:** Copy from FORGE Operations Manual or forge-templates.md.

---

### Documentation Directory

#### `docs/build-plan.md`
**Purpose:** Execution state machine. CC maintains this file.

**Initial Content:**
```markdown
# Build Plan - [Project Name]

**Last Updated:** [YYYY-MM-DD]
**Current Phase:** Refine
**Current PR:** N/A (not yet in Execute)

## Status

Project is in **Refine** phase. Constitutional documents are being authored.

## Constitutional Document Status

| Document | Status | Owner |
|----------|--------|-------|
| North Star | In Progress | CP |
| System Architecture | Pending | CP |
| Data Model | Pending | CP |
| API Contract | Pending | CP |
| Security Policies | Pending | CP |
| Engineering Playbook | Pending | CP |

## PR Sequence

*Will be populated when Execute begins.*

| PR | Name | Status | Dependencies | Notes |
|----|------|--------|--------------|-------|
| 01 | [TBD] | Pending | None | |

## Blocked Items

[None currently]

## Notes

[Any relevant context]
```

---

#### `docs/constitution/` Files

All constitutional documents start as **placeholders**. CP (Spec Author) populates them during Refine.

**Initial placeholder content:**

```markdown
# [Document Name]

**Status:** Placeholder
**Version:** 0.0
**Last Updated:** [YYYY-MM-DD]

---

## Purpose

[To be written by Spec Author during Refine]

---

## Content

*This document will be populated during the Refine phase.*

*Refer to the Kickoff Brief for current intent:*
- Project: [Project Name]
- Codename: [Codename]

---

**Placeholder - Do not implement against this document.**
```

---

### GitHub Directory

#### `.github/PULL_REQUEST_TEMPLATE.md`
**Purpose:** Standardize PR descriptions.

**Content:**
```markdown
## Summary

[One sentence: what this PR accomplishes]

## Task Brief

[Link to inbox/active/pr-XX-name.md or inbox/completed/pr-XX-name.md]

## Changes

- [Change 1]
- [Change 2]
- [Change 3]

## Verification

- [ ] `pnpm typecheck` passes
- [ ] `pnpm lint` passes
- [ ] `pnpm test:run` passes
- [ ] `pnpm build` passes

## HAT (Human Acceptance Test)

1. [Step to verify]
2. [Expected result]

## Notes

[Anything reviewer should know]

---

*PR follows The FORGE Method(TM)*
```

---

## Instantiation Sequence

When CC receives a Greenlight'd Kickoff Brief and constitutional documents:

### Step 1: Navigate to Projects Directory
```bash
cd ~/projects
```

### Step 2: Scaffold Framework (if applicable)
For Next.js projects:
```bash
pnpm create next-app@latest [project-codename] --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
cd [project-codename]
```

For non-Next.js or custom projects:
```bash
mkdir [project-codename]
cd [project-codename]
pnpm init
```

**Note:** Let the framework create its structure first. FORGE directories are layered on top.

### Step 3: Initialize Git (if not already done by framework)
```bash
git init  # Skip if framework already initialized git
git checkout -b main
```

### Step 4: Add FORGE Directory Structure
Layer FORGE-specific directories onto the framework scaffold:
```bash
mkdir -p .cursor/rules
mkdir -p .github
mkdir -p inbox/{active,completed,templates}
mkdir -p docs/{constitution,decisions}
mkdir -p supabase/{migrations,seed}
# Note: src/ and tests/ likely already exist from framework
```

### Step 5: Create Placeholder Files
```bash
touch inbox/active/.gitkeep
touch inbox/completed/.gitkeep
touch docs/decisions/.gitkeep
touch supabase/migrations/.gitkeep
touch supabase/seed/.gitkeep
```

### Step 6: Populate FORGE-Specific Files
- Write `CLAUDE.md` from Project Identity Template + Kickoff Brief
- Update `README.md` (merge FORGE template with framework-generated readme)
- Update `.env.example` (merge with framework-generated if exists)
- Update `.gitignore` (append FORGE-specific ignores if needed)
- Write `.cursor/rules/forge-sd.mdc` from FORGE-SD Profile
- Write `.github/PULL_REQUEST_TEMPLATE.md` from template above
- Write `docs/build-plan.md` from template above
- Write placeholder files in `docs/constitution/`
- Copy task brief template to `inbox/templates/`

### Step 7: Place Constitutional Documents
- Human provides constitutional documents (from CP)
- CC places them in `docs/constitution/`, replacing placeholders
- CC verifies all documents are present and consistent

### Step 8: Initial Commit
```bash
git add .
git commit -m "chore: initialize FORGE project structure

- Project: [Project Name]
- Codename: [codename]
- Profile: FORGE-SD
- Phase: Refine -> Govern transition

Constitutional documents in place. Ready for Execute phase.

Follows FORGE Method(TM) v1.1"
```

### Step 9: Report Status
CC reports to Human:
```
OK Project [codename] initialized
OK Directory structure created
OK Constitutional documents placed
OK CLAUDE.md configured
OK Cursor rules configured
OK Initial commit complete

Ready for Execute phase.
Next step: Human greenlight to begin PR-01.
```

---

## Validation Checklist

Before CC reports "ready," verify:

- [ ] All required directories exist
- [ ] `CLAUDE.md` contains project-specific values
- [ ] All constitutional documents are present (not placeholders)
- [ ] `.cursor/rules/forge-sd.mdc` exists and contains FORGE-SD rules
- [ ] `docs/build-plan.md` exists with initial state
- [ ] `.gitignore` is appropriate for stack
- [ ] `.env.example` documents required variables
- [ ] Initial commit is clean and complete
- [ ] Git is on `main` branch

---

## What This Specification Does NOT Cover

| Out of Scope | Why |
|--------------|-----|
| Package.json dependencies | Stack-specific; determined during scaffolding |
| Framework boilerplate | Created by framework CLI (e.g., create-next-app) |
| Database schema | Derived from data-model.md during Execute |
| Application code | Built during Execute phase |
| CI/CD configuration | Project-specific; optional addition |

### Stack Variance Handling

This specification assumes the default FORGE-SD stack (Next.js, TypeScript, pnpm, Supabase, Vercel). If the selected tech stack differs from these defaults:

1. CC mirrors this structure as closely as possible
2. CC documents all deviations in `docs/decisions/stack-variance.md`
3. CC adapts verification commands to match the actual stack (pattern stays; commands change)

The FORGE structure is the constant. The tooling is the variable.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-04 | Initial specification |
| 1.1 | 2026-01-07 | Consolidated from forge-project-template-spec.md and forge-project-template-specification.md; merged instantiation sequences, added stack variance handling |

---

**[UNIVERSAL]**

**(c) 2026 FORGE Contributors. All rights reserved.**

**FORGE(TM)** is a trademark of its contributors.
