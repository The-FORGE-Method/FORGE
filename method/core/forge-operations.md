# FORGE Operations Manual

**Execution-Grade Documentation for The FORGE Method™**

**Version:** 1.3  
**Steward:** FORGE Maintainers  
**Status:** Operational Reference  
**Prerequisite:** Read FORGE Core first

---

## Purpose

This manual answers one question:

> "If a new team member joined tomorrow, could they achieve similar velocity in week one?"

FORGE Core describes *what* the methodology is. This manual describes *how* it actually runs.

---

## Critical Understanding

> **This manual assumes constitutional documents are complete.**
>
> If execution feels slow, chaotic, or argumentative, the problem is almost always **Refine** — not Execute. Speed comes from locked specs, not faster agents.
>
> Before troubleshooting Execute, verify:
> - Are constitutional documents complete?
> - Are they internally consistent?
> - Do they answer 90% of implementation questions?
>
> If no, return to Refine. If yes, proceed.

---

## Part 1: The FORGE Cycle

### 1.1 What The FORGE Cycle Is

The FORGE Cycle is the tight loop that runs inside the Execute phase. While FORGE has five macro-steps (Frame, Orchestrate, Refine, Govern, Execute), the Execute step contains dozens of FORGE Cycle iterations.

**Characteristics:**
- **Duration:** 30-90 minutes per cycle
- **Frequency:** Multiple times per day during active development
- **Output:** One merged PR per cycle
- **Participants:** Quality Gate, Implementation Engine, Human Lead

The FORGE Cycle is where velocity lives or dies.

**[UNIVERSAL]**

### 1.2 The 16-Step Loop

Here is exactly what happens each cycle:

```
┌─────────────────────────────────────────────────────────────────┐
│  1. TRIGGER: Human says "start PR-N" or "next"                  │
│       ↓                                                          │
│  2. QUALITY GATE: Pull latest from main                         │
│       ↓                                                          │
│  3. QUALITY GATE: Create feature branch                         │
│       ↓                                                          │
│  4. QUALITY GATE: First commit - archive previous, update plan  │
│       ↓                                                          │
│  5. QUALITY GATE: Write task brief                              │
│       ↓                                                          │
│  6. QUALITY GATE: Second commit - task brief                    │
│       ↓                                                          │
│  7. QUALITY GATE: Push branch, notify Human "ready"             │
│       ↓                                                          │
│  8. HUMAN: Opens Implementation Engine, provides context        │
│       ↓                                                          │
│  9. IMPLEMENTATION ENGINE: Reads brief, implements, hands off   │
│       ↓                                                          │
│  10. HUMAN: Bridges handoff to Quality Gate                     │
│       ↓                                                          │
│  11. QUALITY GATE: Pull Implementation Engine's commits         │
│       ↓                                                          │
│  12. QUALITY GATE: VERIFY - run verification sequence           │
│       ↓                                                          │
│  13. QUALITY GATE: Fix minor issues OR escalate for rework      │
│       ↓                                                          │
│  14. QUALITY GATE: Create PR with description                   │
│       ↓                                                          │
│  15. HUMAN: Review PR, merge OR request changes                 │
│       ↓                                                          │
│  16. LOOP: Back to step 1 for next PR                           │
└─────────────────────────────────────────────────────────────────┘
```

**Critical Insight:** Steps 11-14 (verification and PR) take 5-10 minutes when clean. The bottleneck is never Quality Gate — it's waiting for Implementation Engine to implement or Human to merge.

**[UNIVERSAL]**

### 1.3 Cycle Timing

| Cycle Type | Duration | Characteristics |
|------------|----------|-----------------|
| Clean PR | 30-45 min | No issues, mechanical verification passes |
| Standard PR | 45-75 min | Minor fixes needed, one revision cycle |
| Complex PR | 75-120 min | Multiple issues, requires rework |
| Blocked PR | Variable | Escalation required, waiting for decision |

**Expectation:** 70% of cycles should be Clean or Standard. If Complex cycles dominate, constitutional documents may be incomplete.

**[UNIVERSAL]**

### 1.4 Structural Verification (@G Step)

After @C completes and before @F begins, @G performs an automatic structural verification step. This is NOT a new phase — it is a @G verification action that ensures the project scaffold is valid before FORGE execution begins.

**When it runs:** Immediately after @C produces `abc/FORGE-ENTRY.md`, before routing to @F.

**What @G verifies:**

```
Structure Gate Checklist:
[ ] Project exists under FORGE/projects/<slug>/ OR has `external_project: true` in FORGE-AUTONOMY.yml
[ ] abc/FORGE-ENTRY.md exists
[ ] docs/constitution/ directory exists
[ ] docs/adr/ directory exists
[ ] docs/ops/ directory exists with state.md
[ ] docs/router-events/ directory exists
[ ] inbox/00_drop/ directory exists
[ ] inbox/10_product-intent/ directory exists
[ ] inbox/20_architecture-plan/ directory exists
[ ] inbox/30_ops/handoffs/ directory exists
[ ] tests/ directory exists (for code projects)
[ ] CLAUDE.md exists at project root
[ ] FORGE-AUTONOMY.yml exists and is valid
```

**On success:** @G logs verification success to router events, auto-generates `docs/ops/preflight-checklist.md` with results, proceeds to route to @F (per autonomy tier).

**On failure:** @G logs verification failure, produces failure report at `docs/ops/preflight-failure-report.md`, STOPS. Human MUST address structural issues before FORGE execution can begin.

**Grandfathering:** Projects with `abc/FORGE-ENTRY.md` created before 2026-02-10 are exempt from structural verification. Verification applies only to new projects.

---

## Part 2: The Verification Sequence

### 2.1 The Sacred Four

Every PR runs this exact sequence before merge:

```bash
typecheck && lint && test && build
```

Specific commands vary by stack, but the pattern is invariant:

| Step | Purpose | Failure Meaning |
|------|---------|-----------------|
| **typecheck** | Type safety | Code has type errors |
| **lint** | Code standards | Style or pattern violations |
| **test** | Functionality | Logic errors or regressions |
| **build** | Production readiness | Bundle/compilation issues |

**Critical:** All four must pass. Tests passing does not mean build passes. Build catches route conflicts, missing exports, and bundle issues that tests miss.

**Zero-test enforcement:** The test step MUST execute at least one test. Zero tests is a Sacred Four FAILURE, not a pass. Test runner output showing "no tests found" is a gate failure. @E MUST verify that test files exist AND that the test runner executes tests before claiming Sacred Four success.

**[UNIVERSAL]**

### 2.2 Verification Output Handling

**On Success:**
```
✓ typecheck passed
✓ lint passed  
✓ test passed (N tests)
✓ build passed

→ Proceed to PR creation
```

**On Failure:**
```
✗ [step] failed

→ Diagnose failure
→ If <5 lines to fix: fix and re-verify
→ If >5 lines to fix: send back to Implementation Engine
→ If unclear: escalate to Human
```

**[UNIVERSAL]**

### 2.3 Efficiency Patterns

**Parallel Execution:**
Run independent checks simultaneously when possible. Typecheck and lint can run in parallel. Tests and build typically cannot.

**Output Truncation:**
Full verification output clutters context. Use tail to show pass/fail:
```bash
pnpm test:run 2>&1 | tail -20
```
Expand full output only on failure.

**Note on Parallel Work:**
Parallel PR execution (multiple Implementation Engine instances on different features) may occur in rare cases but is intentionally discouraged unless explicitly orchestrated. The sequential model is a feature — it prevents merge conflicts and context fragmentation.

**[UNIVERSAL]**

---

## Part 3: Decision Heuristics

### 3.1 Fix vs Escalate vs Abandon

These unwritten rules govern judgment during execution:

**When to fix yourself (proceed without asking):**
- Less than 5 lines of obvious fixes
- Import/export issues
- Missing TypeScript types
- Route path corrections
- Typos and naming errors

**When to escalate to Human:**
- Spec ambiguity ("should this do X or Y?")
- Security-adjacent decisions
- Scope expansion requests
- Build failures not diagnosed in 5 minutes
- Anything that feels like architecture, not implementation

**When to send back to Implementation Engine:**
- More than 5 files need changes
- Logic errors (not just syntax)
- Missing functionality from task brief
- Test failures indicating wrong implementation

**When to abandon current approach:**
- Same error 3 times after fixes
- Cascading failures (fix A breaks B)
- Implementation complexity exploding
- "This should be simple but isn't"

**[UNIVERSAL]**

### 3.2 Quality Threshold Definitions

| Threshold | Meaning | Action |
|-----------|---------|--------|
| **Good enough** | All 4 verification steps pass | Proceed to PR |
| **Needs work** | Any verification step fails | Fix or rework |
| **Needs rethink** | Implementation doesn't match spec intent | Escalate |
| **Wrong problem** | Scope misunderstanding discovered | Throw away, restart |

**[UNIVERSAL]**

### 3.3 The 5-Line Rule

This threshold drives velocity:
- **Less than 5 lines changed:** Quality Gate fixes directly
- **More than 5 lines changed:** Send back to Implementation Engine

Why this works:
- Small fixes are faster than round-trips
- Large fixes risk introducing new errors
- The threshold is mechanical, not judgmental

**[UNIVERSAL]**

### 3.4 Error Classification Heuristics

Common error patterns and typical responses:

| Error Pattern | Likely Action | Rationale |
|---------------|---------------|-----------|
| Missing module / import | Fix locally | Usually 1-2 lines |
| Typo in variable name | Fix locally | Obvious correction |
| Single type mismatch | Fix locally | Localized issue |
| Widespread type mismatches | Escalate / rebrief | Indicates misunderstanding |
| Security / auth failures | Immediate escalation | Never guess on security |
| Build succeeds, tests flaky | Investigate, don't patch | Flaky tests hide real issues |
| Route conflicts | Fix locally (if obvious) | Common in Next.js |
| Missing environment variable | Escalate | May indicate config issue |

Experience accelerates classification, but when uncertain, the 5-line rule is the tiebreaker.

**[UNIVERSAL]**

---

## Part 4: Kill Switches

### 4.1 Immediate Stop Triggers

Stop all work immediately if:
- Security vulnerability discovered
- Production data exposure risk
- Constitutional document violation detected
- Data integrity compromise possible

These are non-negotiable. Stop, document, escalate.

**[UNIVERSAL]**

### 4.2 Abandon Approach Triggers

Abandon current approach (not just fix) if:
- Same error persists after 3 fix attempts
- Fixing A breaks B (cascading failures)
- Implementation complexity is exploding
- Gut sense: "This should be simpler"

Abandoning an approach is not failure — it's recognition that the current path won't work.

**[UNIVERSAL]**

### 4.3 Throw Away and Restart Triggers

Throw away all work on current PR if:
- Architectural mistake at PR start
- Wrong abstraction chosen
- Scope misunderstanding discovered mid-PR

Sunk cost is not a reason to continue. Restart clean.

**[UNIVERSAL]**

### 4.4 The Difference

| Situation | Symptom | Response |
|-----------|---------|----------|
| **Needs fixing** | Error is localized, solution is clear | Fix it |
| **Needs different approach** | Error reveals design flaw | Abandon approach, try another |
| **Wrong problem** | Solving something not asked for | Throw away, restart |

**[UNIVERSAL]**

---

## Part 5: Context Integrity

### 5.1 The Context Problem

AI agents lose context between sessions. This is the silent killer of velocity. Without context recovery protocols, each session starts from zero.

**[UNIVERSAL]**

### 5.2 Context Anchors

**Primary Anchors (check every session):**

| File | Purpose | Check Frequency |
|------|---------|-----------------|
| Project identity file (README.md, CLAUDE.md, or equivalent) | Project identity, constraints, commands | Session start |
| Build plan | Current state, what's next | Session start |
| Active task brief | Current task specification | Before each cycle |
| Git log (recent) | What actually happened | Session start |

**Secondary Anchors (check on demand):**

| File | Purpose | When to Check |
|------|---------|---------------|
| Constitutional docs | Authoritative specifications | When implementation questions arise |
| PR descriptions | What changed and why | When reviewing history |
| Handoff notes | Implementation Engine's claims | Always verify, never trust blindly |

**[UNIVERSAL]**

### 5.3 Context Recovery Sequence

When starting a new session:

```
1. Read project README / identity file (30 seconds)
2. Check build plan for current status (10 seconds)
3. Run git log to see recent merges (10 seconds)
4. Read active task brief if exists (30 seconds)
5. Ready to proceed

Total: ~90 seconds
```

This sequence prevents:
- Starting work on already-merged PR
- Missing files that were changed
- Duplicate commits
- Orphaned branches

**[UNIVERSAL]**

### 5.4 Recovery from Interruption

If interrupted mid-cycle:

```
1. git status (what's uncommitted?)
2. git log (what's been merged?)
3. Re-read task brief (what was asked?)
4. Check if Implementation Engine has pushed (pull first)
5. Resume from last known state
```

**[UNIVERSAL]**

---

## Part 5.5: Parking Lot Protocol

### 5.5.1 Purpose

During execution, agents frequently discover issues and ideas that are valuable but out of scope for the current PR. Without a capture mechanism, these discoveries evaporate into conversation history — never to be recovered.

The Parking Lot Protocol prevents this context decay by providing durable, file-based storage for out-of-scope discoveries.

**Core Principle:** Conversation ≠ Storage. If it's not in a file, it doesn't exist.

**[UNIVERSAL]**

### 5.5.2 Required Structure

Every FORGE project includes:

```
docs/parking-lot/
├── README.md          # Protocol explanation
├── known-issues.md    # Bugs, tech debt, security concerns
└── future-work.md     # Feature ideas, enhancements, optimizations
```

**File Purposes:**

| File | What Goes Here |
|------|----------------|
| `known-issues.md` | Bugs, broken things, security risks, technical debt |
| `future-work.md` | Feature ideas, enhancements, optimizations, nice-to-haves |

**[UNIVERSAL]**

### 5.5.3 When to Log

Log to parking lot **immediately** when you discover:
- A bug unrelated to your current PR
- A missing feature that would be nice but isn't in scope
- Technical debt worth addressing later
- A security concern that needs follow-up
- An optimization opportunity
- Ideas from debugging that could improve the system

**Golden Rule:** Don't let discoveries get lost in conversation history. If it's not in scope, park it.

**[UNIVERSAL]**

### 5.5.4 Entry Format

```markdown
## [YYYY-MM-DD] Short Title

**Source:** PR-XX or context | **Severity:** Low/Medium/High | **Effort:** X hrs

One-paragraph description of the issue or idea.

**Workaround:** (if applicable for known-issues)

**Fix:** Proposed solution or next steps.
```

**[UNIVERSAL — entry schema may evolve]**

### 5.5.5 Parking Lot Lifecycle

```
Discover → Park → Continue → Review → Graduate
```

1. **Discover** — Find issue or idea during PR work
2. **Park** — Log immediately to appropriate file
3. **Continue** — Return to current PR scope without derailing
4. **Review** — Human reviews parking lot during planning
5. **Graduate** — Items move to GitHub Issues when prioritized

**[UNIVERSAL — graduation target is CONTEXTUAL]**

### 5.5.6 Governance

- **Authored by:** Quality Gate or Implementation Engine (during execution)
- **Reviewed by:** Human Lead (during sprint planning)
- **Graduated:** Items move to GitHub Issues or build plan when prioritized

Parking lot items do NOT automatically become work. They are candidates for future work, subject to Human approval.

**[UNIVERSAL]**

---

## Part 6: Canonical Truth Resolution

### 6.1 The Hierarchy

When sources disagree, higher sources win:

```
1. Human's explicit verbal instruction (real-time) — HIGHEST
2. Constitutional documents (docs/constitution/)
3. Build plan (current task context)
4. Task brief (specific PR scope)
5. Implementation Engine's output (verify, don't trust) — LOWEST
```

**[UNIVERSAL]**

### 6.2 Conflict Patterns

**Constitution vs Build Plan:**
- Constitution defines *what* is correct
- Build plan defines *when* to do it
- If conflict: Follow constitution, update build plan

**Human Verbal vs Written Spec:**
- Human can override written spec
- But ask: "This differs from spec — should I update the spec too?"
- Capture decision in commit message

**Implementation Output vs Expectation:**
- Verify against task brief, not intuition
- If Implementation Engine did something unexpected but brief didn't forbid it: probably fine
- If Implementation Engine violated explicit constraint: send back

**Ambiguity (no source is clear):**
- Check constitutional docs first
- If still unclear: STOP and ask Human
- Never guess on architecture or security

**[UNIVERSAL]**

---

## Part 7: Inbox-Driven Workflow

### 7.1 The Mechanism

FORGE uses an inbox-driven workflow for discovery and planning. Raw ideas flow through structured phases before reaching execution.

**Directory Structure:**
```
inbox/
├── 00_drop/              # Discovery input (human writes here)
├── 10_product-intent/    # Product Strategist outputs
└── 20_architecture-plan/ # Project Architect outputs
```

**[UNIVERSAL - directory names are CONTEXTUAL]**

### 7.2 The Workflow

```
Human drops discovery materials → inbox/00_drop/
Product Strategist processes → inbox/10_product-intent/
Human routes to Project Architect
Project Architect processes → inbox/20_architecture-plan/
Human routes to execution agents
```

**Key Insight:** Each phase produces a structured packet that the next phase consumes. Human Lead routes between phases.

**[UNIVERSAL]**

### 7.3 Packet Preservation

Both Product Intent Packets and Architecture Packets are preserved as historical records:
- They inform constitutional documents but don't replace them
- They provide audit trail for planning decisions
- They can be referenced during execution for context

**[UNIVERSAL]**

---

## Part 8: Task Brief Construction

### 8.1 What Makes a Good Brief

Task briefs are the primary communication to Implementation Engine. Quality directly affects output.

**Essential Elements:**
- Clear objective (one sentence)
- Pre-flight checklist (what must be true before starting)
- Implementation steps (numbered, specific)
- Acceptance criteria (checkboxes)
- Files to create/modify (explicit paths)
- "Do NOT" section (explicit constraints)

**[UNIVERSAL]**

### 8.2 The "Do NOT" Section

Implementation Engines respond to constraints. Without explicit boundaries, scope creeps.

**Example:**
```markdown
## Do NOT
- Do not modify existing authentication logic
- Do not add new dependencies without approval
- Do not implement features not listed above
- Do not refactor unrelated code
```

This section prevents 80% of scope creep issues.

**[UNIVERSAL]**

### 8.3 Context That Helps

What information helps Implementation Engine most:
- File paths for new files (explicit)
- Examples of similar existing code (reference)
- Acceptance criteria as checkboxes (verifiable)
- HAT (Human Acceptance Test) steps (testable)

What doesn't help:
- Vague descriptions
- Assumed knowledge
- References to conversation history (stateless)

**[UNIVERSAL]**

---

## Part 9: Build Plan as State Machine

### 9.1 Purpose

The build plan is the single source of truth for execution state. Quality Gate maintains it. Everyone references it.

**[UNIVERSAL]**

### 9.2 Status Markers

| Marker | Meaning |
|--------|---------|
| ✅ | Complete and merged |
| 🔄 | In progress (current PR) |
| ➡️ | Next up |
| ⏳ | Pending (not yet started) |
| 🔴 | Blocked |

At any moment, exactly one PR should be 🔄.

**[CONTEXTUAL - markers may vary]**

### 9.3 Update Discipline

Build plan is updated:
- At the start of each PR (previous → ✅, current → 🔄)
- When blockers are discovered (add 🔴 with reason)
- When scope changes (with Human approval)

Quality Gate owns this file. No one else modifies it.

**[UNIVERSAL]**

---

## Part 10: What New Team Members Must Know

### 10.1 Critical Knowledge Gaps

If someone took over tomorrow with only documentation, they would NOT know:

**1. The verification sequence is sacred**
```bash
typecheck && lint && test && build
```
A new person might skip `build` because tests pass. This causes production failures.

**2. Implementation Engine output requires verification**
Handoffs often claim "all tests pass" when they don't. Always verify.

**3. The archive-first pattern**
New PRs start by archiving previous PR's prompts. This isn't obvious but keeps active/ clean.

**4. Human's merge cadence**
Human merges quickly when available. Don't wait for formal review cycles — notify when ready.

**5. Build plan is maintained by Quality Gate**
Quality Gate maintains this file, not Human. Status markers must be accurate.

**6. Task briefs need "Do NOT" sections**
Implementation Engine responds to constraints. Without explicit boundaries, scope creeps.

**7. Constitutional docs are read-only during Execute**
Quality Gate never modifies constitution. Suggest changes, wait for approval.

**8. Small fixes are okay, large fixes go back**
<5 lines = fix it. >5 lines = Implementation Engine rework.

**[UNIVERSAL]**

### 10.2 First-Day Checklist

New Quality Gate agent first-day checklist:

- [ ] Read project README / CLAUDE.md completely
- [ ] Read all constitutional documents (skim, note locations)
- [ ] Read current build plan (know what's done, what's next)
- [ ] Read most recent 3 PR descriptions (understand patterns)
- [ ] Run verification sequence once (confirm it works)
- [ ] Read active task brief if one exists
- [ ] Confirm communication channel with Human

**[UNIVERSAL]**

---

## Part 11: Speed Secrets Summary

What makes FORGE fast:

**1. Constitutional docs eliminate decisions**
When writing a task brief, you're not deciding *what* to build — that's in the spec. Implementation Engine isn't deciding architecture — that's in the constitution. 90% of "should we..." questions are already answered.

**2. File-based handoffs create async capability**
Task briefs live in files. Handoffs live in files. No one waits for real-time conversation.

**3. The verification sequence is mechanical**
Same 4 steps every time. No judgment needed. Pass = proceed. Fail = fix.

**4. Build plan is the state machine**
Current PR is always visible. Next PR is always visible. No ambiguity about what to work on.

**5. Small PRs prevent compounding errors**
Each PR is bounded. Errors are caught within the same session. Context doesn't decay across days.

**[UNIVERSAL]**

---

## Part 12: Escalation Reality

### 12.1 Formal vs Informal

The FORGE Core document includes escalation templates. Reality: most escalations are informal.

**Typical escalation:**
> "Hey [Human], this is ambiguous — the spec says X but the build plan implies Y. Which should I follow?"

**When to use formal template:**
- Complex issue requiring written analysis
- Decision needs to be documented for audit
- Multiple stakeholders need to weigh in

**[SITUATIONAL]**

### 12.2 Escalation Speed

Escalations should resolve in minutes, not hours. If Human is unavailable:
- Document the blocker
- Move to a non-blocked task if possible
- Wait (do not guess on architecture or security)

**[UNIVERSAL]**

---

## Appendix A: Template — Task Brief

```markdown
# Task Brief: PR-[XX] — [Name]

## Objective
[One sentence: what this PR accomplishes]

## Pre-Flight Checklist
- [ ] Previous PR merged to main
- [ ] Branch created from latest main
- [ ] Dependencies available
- [ ] No blocking issues

## Implementation Steps
1. [Specific step]
2. [Specific step]
3. [Specific step]

## Acceptance Criteria
- [ ] [Verifiable criterion]
- [ ] [Verifiable criterion]
- [ ] All verification steps pass

## Files to Create/Modify
- `path/to/new/file.ts` — [purpose]
- `path/to/existing/file.ts` — [changes]

## Reference
- Similar implementation: `path/to/example.ts`
- Relevant spec: `docs/constitution/api-contract.md#section`

## Do NOT
- Do not [forbidden action]
- Do not [forbidden action]
- Do not implement features not listed above

## HAT (Human Acceptance Test)
1. [Step human will take to verify]
2. [Expected result]
```

**[UNIVERSAL]**

---

## Appendix B: Template — Build Plan

```markdown
# Build Plan — [Project Name]

**Last Updated:** [YYYY-MM-DD]
**Current PR:** PR-[XX]

## Changelog
| Date | PR | Status | Notes |
|------|-----|--------|-------|
| [Date] | PR-01 | ✅ | [Brief note] |
| [Date] | PR-02 | 🔄 | [Brief note] |

## PR Sequence

| PR | Name | Status | Dependencies | Notes |
|----|------|--------|--------------|-------|
| 01 | [Name] | ✅ | None | |
| 02 | [Name] | 🔄 | PR-01 | Current |
| 03 | [Name] | ➡️ | PR-02 | Next |
| 04 | [Name] | ⏳ | PR-03 | |

## Current Focus

**PR-02: [Name]**
- Objective: [What this PR accomplishes]
- Architecture Packet: `inbox/20_architecture-plan/[feature-slug]/`
- Blockers: None

## Blocked Items
[None currently, or list with reasons]

## Backlog
[Items not yet scheduled]
```

**[UNIVERSAL - markers are CONTEXTUAL]**

---

## Appendix C: Template — Handoff Note

Implementation Engine handoff notes vary in format. Essential elements:

```markdown
## Implementation Complete

### What Was Built
- [Feature/component 1]
- [Feature/component 2]

### Quality Checks Run
- TypeScript: [status]
- Tests: [count] passed
- Lint: [status]

### Files Created/Modified
- [file1.ts] — [purpose]
- [file2.ts] — [purpose]

### Notes for Quality Gate
- [Anything unusual]
- [Decisions made]
- [Potential issues]

### Ready for Review
[Confirmation that work is complete]
```

**[UNIVERSAL]**

---

## Appendix D: Verification Commands by Stack

Commands vary by technology stack. Pattern is invariant.

**Next.js / TypeScript / pnpm:**
```bash
pnpm typecheck && pnpm lint && pnpm test:run && pnpm build
```

**React / npm:**
```bash
npm run typecheck && npm run lint && npm test && npm run build
```

**Python / pytest:**
```bash
mypy . && ruff check . && pytest && python -m build
```

**Go:**
```bash
go vet ./... && golint ./... && go test ./... && go build ./...
```

Adapt commands to your stack. Preserve the four-step pattern.

**[CONTEXTUAL - commands vary, pattern is UNIVERSAL]**

---

## Appendix F: Router Operations (v1.3)

### @G Router Event Logging

All cross-lane transition requests are logged to `docs/router-events/YYYY-MM-DD.jsonl` in JSON Lines format. Events are append-only and never deleted.

**Event types:** `transition`, `error`, `fallback`, `gate_check`

**Required fields:** `timestamp`, `tier`, `source_role`, `target_role`, `request_type`, `action`, `event_id`

See `method/templates/forge-template-router-events.md` for full schema.

### FORGE-AUTONOMY.yml

Each project MAY include a `FORGE-AUTONOMY.yml` file at the project root to configure autonomy behavior. Key fields:

- `tier` — Active autonomy tier (0-3, default 0)
- `forge_entry.required_file` — Gate artifact for FORGE unlock
- `router.event_log_path` — Where events are logged
- `allowed_transitions` — Permitted transition pairs
- `human_gates` — Actions requiring human approval at all tiers
- `blast_radius` — Thresholds for auto-routing (Tier 2/3)

See `method/templates/forge-template-autonomy-policy.md` for full schema.

### Pre-FORGE Lifecycle (A.B.C)

Projects using FORGE v1.3+ include an `abc/` directory for pre-commitment intake:

```
abc/
├── INTAKE.md          ← @A output
├── BRIEF.md           ← @B output (optional)
├── FORGE-ENTRY.md     ← @C output (gate artifact)
├── inbox/             ← Raw inputs
└── context/           ← Supporting context
```

`abc/FORGE-ENTRY.md` is the gate artifact. F/O/R/G/E agents are blocked until it exists.

**[UNIVERSAL]**

---

## Part 13: Enforcement Matrix

This matrix defines what agent enforces what rule at what trigger point. It is the operational reference for FORGE enforcement mechanisms.

### Core Enforcement Rules

| Rule | Enforcing Agent | Trigger Point | Failure Mode | Bypass |
|------|----------------|---------------|--------------|--------|
| Project under FORGE/projects/ | ALL agents (startup) | Agent invocation | HARD STOP (unless waiver) | `external_project: true` in FORGE-AUTONOMY.yml (waives location only — all other enforcement still applies) |
| Template scaffold structure valid | @G | Structural verification step after @C | HARD STOP | None |
| Test framework installed | @E | Before first PR | HARD STOP | `is_test_setup: true` flag in handoff (PR-000 only) |
| At least one test exists | @E | Before every PR | HARD STOP | `is_test_setup: true` flag in handoff (PR-000 only) |
| Sacred Four passes with real tests | @E | Before every PR merge | HARD STOP | None |
| Auth architecture ADR exists | @G | Before first auth-related @E handoff | HARD STOP | N/A if no auth in scope |
| Stakeholder model defined | @F | Frame completion gate | HARD STOP | N/A if no stakeholders |
| Actor plane assignment explicit | @F | Frame completion gate | HARD STOP | None |
| Role scoping documented | @O | Orchestrate completion gate | HARD STOP | None |
| Handoff packet exists | @E | Before starting handoff work | HARD STOP | None |
| PR packet produced | @E | Before PR creation | HARD STOP | PR-000 (`is_test_setup: true`) and docs-only PRs (no code changes) |
| Router events logged | @G | Every transition | WARN (degraded governance) | None |
| Coverage delta >= 0 | @E + CI | Every PR | HARD STOP | None |
| FORGE-AUTONOMY.yml exists | ALL agents | Agent invocation | HARD STOP | None |

### Enforcement Timeline

```
Project Lifecycle with Enforcement Points:

  @A (Acquire)
  ├── CHECK: Project will be created under FORGE/projects/ ← NEW
  └── OUTPUT: abc/INTAKE.md

  @C (Commit)
  ├── CHECK: abc/INTAKE.md exists
  └── OUTPUT: abc/FORGE-ENTRY.md  [EXISTING GATE]

  ──── STRUCTURAL VERIFICATION (@G STEP) ──── [NEW]
  │
  │  @G verifies:
  │  ├── Project structure matches template
  │  ├── FORGE-AUTONOMY.yml exists
  │  ├── docs/ structure exists
  │  ├── inbox/ structure exists
  │  ├── tests/ directory exists
  │  └── OUTPUT: docs/ops/preflight-checklist.md [PASS or HARD STOP]
  │

  @F (Frame)
  ├── CHECK: Structural verification passed ← NEW
  ├── CHECK: Preflight checklist exists ← NEW
  ├── MANDATORY DECISION: Auth planes ← NEW
  ├── MANDATORY DECISION: Stakeholder model ← NEW
  └── OUTPUT: PRODUCT.md (enhanced)

  @O (Orchestrate)
  ├── CHECK: Actor planes assigned in PRODUCT.md ← NEW
  ├── MANDATORY OUTPUT: Auth architecture ADR ← NEW
  ├── MANDATORY OUTPUT: Test architecture spec ← NEW
  └── OUTPUT: TECH.md (enhanced)

  @G (Transition to Execute)
  ├── CHECK: Auth ADR exists (if auth in scope) ← NEW
  ├── CHECK: Test infrastructure configured ← NEW
  ├── CHECK: Handoff packet in inbox/30_ops/handoffs/ ← NEW
  └── APPROVE or HARD STOP

  @E (Execute)
  ├── PRE-FLIGHT: Structure check ← NEW
  ├── PRE-FLIGHT: Test infra check ← NEW
  ├── PRE-FLIGHT: Auth readiness check ← NEW
  ├── PRE-FLIGHT: Sacred Four dry run ← NEW
  ├── WORK: Tests-first implementation [EXISTING]
  ├── CHECK: Coverage gate [EXISTING, now verified]
  ├── CHECK: PR packet produced ← NEW enforcement
  └── OUTPUT: PR + Completion Packet
```

### Grandfathering Policy

**Effective date:** 2026-02-10

**Policy:** Projects with `abc/FORGE-ENTRY.md` created before 2026-02-10 are exempt from new enforcement gates introduced in this hardening release. New gates apply only to projects created after structural verification enforcement is implemented.

**What is grandfathered:**
- Structural verification step (@G after @C)
- @F auth plane decision gate
- @O auth architecture ADR requirement
- @E pre-flight checks (structure, test infra, auth readiness)
- Universal project location check

**What is NOT grandfathered (applies to all projects immediately):**
- Sacred Four zero-test enforcement: Zero tests is a FAILURE for all projects, all PRs, effective immediately. This is a clarification of existing Sacred Four semantics, not a new rule. There is no grace period. Projects with zero tests MUST add tests before their next PR.
- Enforcement matrix documentation (operational reference only)

**Migration:** Existing projects MAY voluntarily adopt new enforcement gates by:
1. Running structural verification manually via @G
2. Adding missing templates (STAKEHOLDER-MODEL, AUTH-ARCHITECTURE ADR, etc.)
3. Updating project CLAUDE.md to reflect new non-negotiables

Migration is optional. Grandfathered projects remain fully valid FORGE projects.

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-03 | Initial release (combined with Core) |
| 1.1 | 2026-01-04 | Extracted as Operations Manual; incorporated CC ground-truth review; added FORGE Cycle, decision heuristics, kill switches, context integrity |
| 1.1.1 | 2026-01-04 | CC validation passed; added error classification heuristics; generalized identity file reference; added parallel work note |
| 1.2 | 2026-02-06 | Added Appendix F: Router operations, event logging, FORGE-AUTONOMY.yml, pre-FORGE lifecycle (Decision-005) |
| 1.3 | 2026-02-11 | System hardening: Added @G structural verification step, Sacred Four zero-test enforcement, enforcement matrix, grandfathering policy |

---

**© 2026 FORGE Contributors. All rights reserved.**

**FORGE™** is a trademark of its contributors.
