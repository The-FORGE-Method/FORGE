# FORGE Template: Project Identity

**Template 0 - The First Anchor File**

**Version:** 1.2
**Status:** First-Class Artifact

---

## Purpose

Every FORGE project needs a single identity file that answers: "What is this project and how do I work in it?"

This file is the **first thing any agent reads** at session start. It establishes context before any other work happens.

**Common Names:**
- `CLAUDE.md` (for Claude Code projects)
- `README.md` (if doubling as repo readme)
- `PROJECT.md` (stack-agnostic)

---

## When to Create

Create this file **during Orchestrate**, before Refine begins. It should exist before any constitutional documents are written.

---

## What Problem It Prevents

- Agents assuming wrong project context
- Repeated "what is this project?" questions
- Inconsistent command usage
- Authority confusion
- Scope drift from unclear boundaries

---

## Template

```markdown
# [Project Name]

**One-line description:** [What this project does in <=15 words]

---

## Project Identity

### What This Is
[2-3 sentences describing the project's purpose and core function]

### What This Is NOT
- [Explicit non-goal 1]
- [Explicit non-goal 2]
- [Explicit non-goal 3]

### Who This Is For
- **Primary users:** [Who uses this directly]
- **Stakeholders:** [Who cares about outcomes]

---

## Technical Context

### Stack
| Layer | Technology |
|-------|------------|
| Framework | [e.g., Next.js 15] |
| Language | [e.g., TypeScript 5.x] |
| Database | [e.g., Supabase/Postgres] |
| Auth | [e.g., Supabase Auth] |
| Hosting | [e.g., Vercel] |
| Styling | [e.g., Tailwind + shadcn/ui] |

### Key Dependencies
- [Dependency 1] - [why it's used]
- [Dependency 2] - [why it's used]

---

## Commands

### Development
```bash
pnpm dev          # Start development server
pnpm build        # Production build
pnpm start        # Start production server
```

### Quality Checks
```bash
pnpm typecheck    # TypeScript validation
pnpm lint         # ESLint
pnpm test:run     # Run tests
pnpm build        # Verify production build
```

### Verification Sequence (Sacred)
```bash
pnpm typecheck && pnpm lint && pnpm test:run && pnpm build
```

### Database
```bash
pnpm db:generate  # Generate migrations
pnpm db:migrate   # Apply migrations
pnpm db:seed      # Seed development data
```

---

## Project Structure

```
[project-root]/
+-- src/
|   +-- app/              # [Framework-specific routing]
|   +-- components/       # [UI components]
|   +-- lib/              # [Utilities and helpers]
|   +-- types/            # [TypeScript types]
+-- docs/
|   +-- constitution/     # [Authoritative specs - READ ONLY]
|   +-- build-plan.md     # [Execution state - CC maintains]
+-- inbox/
|   +-- active/           # [Current task briefs]
|   +-- completed/        # [Archived briefs]
|   +-- templates/        # [Reusable templates]
+-- supabase/
|   +-- migrations/       # [Database migrations]
|   +-- seed/             # [Seed data]
+-- tests/                # [Test files]
```

---

## Authority & Boundaries

### Human Lead
**[Name]** - Final decision-maker. Greenlights phases, reviews PRs, merges code, resolves disputes.

### Agent Roles
| Role | Agent | Authority |
|------|-------|-----------|
| Strategist | [e.g., Jordan/ChatGPT] | Business strategy, feature ideation |
| Spec Author | [e.g., CP/Claude Project] | Constitutional documents, prompts |
| Quality Gate | [e.g., CC/Claude Code] | Verification, PRs, build-plan |
| Implementation | [e.g., Cursor] | Code per task briefs |

### Key Boundaries
- **Constitutional docs are read-only during Execute** - Suggest changes, don't modify
- **Quality Gate owns build-plan.md** - No one else updates status
- **Implementation Engine output requires verification** - Never trust without checking

---

## Current State

### Phase
[Frame | Orchestrate | Refine | Govern | Execute]

### If in Execute
- **Current PR:** [PR-XX]
- **Build Plan:** `docs/build-plan.md`
- **Active Brief:** `inbox/active/[current-brief].md`

---

## Non-Negotiables

1. **Verification sequence runs before every PR** - No exceptions
2. **Constitutional docs are authoritative** - When in doubt, check the spec
3. **Small fixes (<5 lines) are okay; large fixes go back** - The 5-line rule
4. **Inbox-driven workflow** - Everything through `inbox/`, not conversation
5. **Archive before starting** - Each PR archives the previous brief first

---

## Getting Oriented (New Session)

```
1. Read this file (you're doing it)
2. Check docs/build-plan.md for current state
3. Run: git log --oneline -5
4. Check inbox/active/ for current brief
5. Ready to proceed (~90 seconds total)
```

---

## Links

- **Constitutional Docs:** `docs/constitution/`
- **Build Plan:** `docs/build-plan.md`
- **Active Briefs:** `inbox/active/`

---

*This project follows The FORGE Method(TM) - theforgemethod.org*
```

---

## Customization Notes

### Required Sections
- Project Identity (what/not/who)
- Commands (especially verification sequence)
- Authority & Boundaries
- Current State
- Getting Oriented

### Optional Sections
- Technical Context (if complex stack)
- Project Structure (if non-standard)
- Links (if many resources)

### Adaptation
- Rename file to match your tooling (`CLAUDE.md`, `PROJECT.md`, etc.)
- Adjust commands for your package manager
- Add stack-specific sections as needed
- Keep "Getting Oriented" sequence intact

---

## Common Failure Modes

| Failure | Symptom | Prevention |
|---------|---------|------------|
| Missing verification sequence | Agents skip steps | Always include Sacred 4 |
| Vague "What This Is NOT" | Scope creep | Force 3+ explicit non-goals |
| No current state | Agents start wrong work | Always show phase and PR |
| Missing authority boundaries | Role confusion | Explicit role table |
| Stale content | Wrong commands/paths | Update when structure changes |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-04 | Initial template |
| 1.1 | 2026-01-04 | Added "Getting Oriented" sequence, failure modes |
| 1.2 | 2026-01-07 | Fixed UTF-8 encoding issues, standardized ASCII-safe characters |

---

**[UNIVERSAL]**

**(c) 2026 FORGE Contributors. All rights reserved.**

**FORGE(TM)** is a trademark of its contributors.
