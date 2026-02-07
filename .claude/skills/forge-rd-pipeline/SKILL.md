---
name: forge-rd
description: Orchestrates FORGE R&D workflow from raw inbox material to implemented features. Invoke with "/forge-rd start <slug>" or "process forge feature". Handles recon, synthesis, proposal refinement (Ralph), governance checkpoints, and implementation coordination.
allowed-tools: Bash, Read, Write, Edit, Task, Glob, Grep, WebFetch, WebSearch
---

# FORGE R&D Pipeline Skill

## Purpose

Automates the FORGE R&D workflow while preserving human authority at governance checkpoints. Transforms raw material (transcripts, notes, sketches) into implemented FORGE features through a disciplined, verifiable pipeline.

**This skill automates motion, not authority.**

---

## Pipeline Flow

```
INBOX
  │
  ▼
INTAKE SANITY CHECKS
  ├── Viability (one feature or multiple?)
  ├── Inventory (manifest.json + inventory.md)
  ├── Duplication detection
  └── Canon detection → require --canon if true
  │
  ▼
RECON (forge-recon-runner sub-agent)
  │
  ▼
CLARIFYING QUESTIONS (conditional)
  ├── Max 10 questions
  ├── Closed-form preferred
  └── Default: PAUSE (no guessing)
  │
  ▼
SYNTHESIS (spec-writer FORGE mode)
  │
  ▼
PROPOSAL + QUALITY GATE
  ├── Ralph refines (max 10 iterations)
  ├── Quality scan blocks if TBD/???/maybe/should/consider
  └── Generates proposal_sha256
  │
  ▼
GOVERNANCE CHECKPOINT
  ├── "Governance checkpoint reached: human authority required"
  ├── Validates proposal hash on approve
  ├── Standard: /forge-rd approve
  └── Canon: /forge-rd approve --canon → /forge-rd confirm
  │
  ▼
BLAST RADIUS CHECK
  ├── Cross-repo? → second confirmation
  └── Same-repo >10 files? → second confirmation
  │
  ▼
IMPLEMENT (forge-maintainer sub-agent)
  │
  ▼
VERIFICATION
  ├── Docs: lint + consistency + changelog candidate
  ├── Code: Sacred Four + smoke instantiation
  └── verification-report.md must say PASS
  │
  ▼
ARCHIVE + CLEANUP
  └── Only if verification PASS
```

---

## Commands

### /forge-rd start <slug> [--canon]

Start a new R&D pipeline for the given feature slug.

**Arguments:**
- `<slug>` — Short identifier for the feature (e.g., `auth-extension`, `fai-phase-2`)
- `--canon` — Required if the feature touches `method/core/**`

**Behavior:**
1. Scans `_workspace/00_inbox/` for material
2. Creates work-item at `_workspace/04_proposals/work-items/<date>-<slug>/`
3. Moves inbox material to work-item
4. Initializes `state.json` and `audit-log.md`
5. Begins INTAKE phase

**Example:**
```bash
/forge-rd start stakeholder-ai-upgrade
/forge-rd start governance-rewrite --canon
```

---

### /forge-rd status

Show current pipeline state and next action.

**Output:**
- Current work-item
- Current phase
- Pending actions
- Blockers (if any)

---

### /forge-rd approve [--canon]

Approve the current proposal and proceed to implementation.

**Behavior:**
1. Validates proposal hash matches `state.json.proposal_sha256`
2. If mismatch → hard stop: "Proposal changed since approval request"
3. If `--canon` required but not provided → hard stop
4. Logs approval to `audit-log.md`
5. Proceeds to BLAST_RADIUS_CHECK

**For canon changes:** Requires two-step approval:
```bash
/forge-rd approve --canon
/forge-rd confirm
```

---

### /forge-rd reject "<feedback>"

Reject the current proposal with feedback.

**Behavior:**
1. Logs rejection + feedback to `audit-log.md`
2. Appends feedback to `artifacts/questions.md`
3. Returns to SYNTHESIS phase
4. Re-runs proposal generation with feedback context

---

### /forge-rd confirm

Second confirmation for canon changes or blast-radius warnings.

**Required after:**
- `/forge-rd approve --canon`
- Blast radius threshold exceeded

---

### /forge-rd hold

Pause the pipeline, preserving all state.

---

### /forge-rd resume

Resume a held pipeline from current state.

---

### /forge-rd cancel

Cancel the current pipeline. Archives partial work to `99_archive/`.

---

### /forge-rd handoff <target> [--copy-to <path>] [--target-pr-start N]

Hand off the current proposal to an external project.

**Arguments:**
- `<target>` — Identifier for destination (e.g., `my-app`, `my-service`)
- `--copy-to <path>` — Optional: Copy proposal artifacts to specified directory
- `--target-pr-start N` — Optional: Pre-fill PR translation table starting at PR-N

**Behavior:**
1. Validates pipeline is at AWAITING_APPROVAL or HELD phase
2. Generates `handoff-manifest.md` from template with:
   - PR translation table (empty or pre-filled based on `--target-pr-start`)
   - Integration checklist for receiving architect
   - Extracted constraints, tech stack, and scope from proposal
   - Proposal SHA-256 hash for verification
3. If `--copy-to` specified: copies proposal.md, synthesis.md, recon-report.md, handoff-manifest.md
4. Logs handoff to audit-log.md with target and copy path
5. Updates state.json with handoff_target field
6. Archives work-item with `--HANDED_OFF` suffix
7. Resets global state to IDLE

**Example:**
```bash
/forge-rd handoff my-app
/forge-rd handoff my-app --copy-to ~/my-app/ai_prompts/active/feature-x/ --target-pr-start 20
```

**Use Case:** When forge-rd is used as a "proposal factory" and implementation happens in a different project's workflow.

---

### Receiving a Handoff

When your project receives a forge-rd handoff:

1. **Review handoff-manifest.md first**
   - Check PR number translation table
   - Verify tech stack compatibility
   - Note key constraints and scope boundaries

2. **Complete the Integration Checklist**
   - Update your project's build-plan.md with new roadmap entries
   - Create detailed feature plan in `docs/features/` if needed
   - Fill in PR translation table as you create branches

3. **Translate proposal to task brief**
   - Use proposal.md as specification
   - Write task brief in your project's format (e.g., `ai_prompts/active/`)
   - Reference manifest for constraints and scope

4. **Follow your project's normal PR rhythm**
   - Manifest provides guidance but does NOT replace your project's workflow
   - Your project maintains autonomous execution rhythm

**Important:** The manifest is an integration aid, not a workflow override.

---

### /forge-rd answer "<question-id>" "<answer>"

Answer a clarifying question.

**Example:**
```bash
/forge-rd answer Q1 "Option A - use Supabase RLS"
```

---

## Pipeline Phases

### INTAKE

**Entry:** `/forge-rd start` invoked
**Exit:** All sanity checks pass

**Actions:**
1. Scan `00_inbox/` for files
2. Validate viability (one feature or multiple)
3. Generate `manifest.json` (file hashes, sizes, types)
4. Generate `inventory.md` (human-readable)
5. Check for duplicates in `_workspace/`
6. Detect canon paths → require `--canon` if found

**Artifacts:**
- `artifacts/manifest.json`
- `artifacts/inventory.md`

**Failure modes:**
- Multiple features detected → AWAITING_INPUT (ask to split)
- Canon detected without `--canon` → hard stop

---

### RECON

**Entry:** INTAKE complete
**Exit:** Recon report generated

**Actions:**
1. Invoke `forge-recon-runner` sub-agent
2. Analyze all material in work-item
3. Cross-reference FORGE canon
4. Identify gaps, conflicts, dependencies

**Artifacts:**
- `artifacts/recon-report.md`

---

### CLARIFYING_QUESTIONS

**Entry:** RECON identifies ambiguities (conditional)
**Exit:** All questions answered OR skipped (no ambiguities)

**Actions:**
1. Generate up to 10 closed-form questions
2. Write to `artifacts/questions.md`
3. Set state to AWAITING_INPUT
4. Wait for `/forge-rd answer` commands

**Constraints:**
- Max 10 questions
- Prefer closed-form (A/B/C options)
- Default behavior: PAUSE (no guessing)

**Artifacts:**
- `artifacts/questions.md`

---

### SYNTHESIS

**Entry:** Questions answered (or none needed)
**Exit:** Synthesis document generated

**Actions:**
1. Invoke `spec-writer` in FORGE mode
2. Extract requirements, constraints
3. Identify affected repos and files
4. Produce structured synthesis

**Artifacts:**
- `artifacts/synthesis.md`

---

### PROPOSAL

**Entry:** SYNTHESIS complete
**Exit:** Proposal passes quality gate

**Actions:**
1. Generate initial proposal from synthesis
2. Invoke Ralph loop for refinement (max 10 iterations)
3. Run quality scan after each iteration
4. Block if scan finds: `TBD`, `???`, `maybe`, `should`, `consider`
5. Generate SHA-256 hash of final proposal
6. Store hash in `state.json.proposal_sha256`

**Artifacts:**
- `artifacts/proposal.md`
- `artifacts/proposal-quality-report.md`

**Ralph exit criteria:**
- Quality scan passes (no forbidden terms)
- All sections complete
- Acceptance criteria are binary (pass/fail)
- Risks have mitigations

---

### AWAITING_APPROVAL

**Entry:** Proposal passes quality gate
**Exit:** Human Lead approves or rejects

**Actions:**
1. Display: "Governance checkpoint reached: human authority required"
2. Show proposal summary
3. Wait for `/forge-rd approve` or `/forge-rd reject`

**Validation on approve:**
- Current proposal hash must match `state.json.proposal_sha256`
- If canon change: `--canon` flag required
- Canon changes require second `/forge-rd confirm`

---

### BLAST_RADIUS_CHECK

**Entry:** Approval received
**Exit:** Blast radius acknowledged (if triggered)

**Triggers:**
- Any cross-repo change → second confirmation required
- Same-repo >10 files → second confirmation required

**Actions:**
1. Analyze proposal for affected files/repos
2. If threshold exceeded: display warning, require `/forge-rd confirm`
3. Log to `audit-log.md`

---

### IMPLEMENT

**Entry:** All approvals received
**Exit:** Implementation complete

**Actions:**
1. Invoke `forge-maintainer` sub-agent
2. Execute changes per proposal
3. Commit changes (local only, no push)
4. Generate `artifacts/implementation.md`

**Constraints:**
- Never pushes without explicit instruction
- Never deletes files outside `_workspace/99_archive/`
- Never restructures repos without approval

---

### VERIFICATION

**Entry:** Implementation complete
**Exit:** Verification passes

**Actions (docs changes):**
1. Markdown lint
2. Internal consistency scan (FORGE terminology)
3. Generate CHANGELOG candidate

**Actions (code changes):**
1. Run Sacred Four: `typecheck && lint && test && build`
2. Smoke instantiation (for template changes):
   - Create temp dir: `_workspace/.tmp/smoke/<timestamp>/`
   - Copy template, run install + Sacred Four
   - Capture to `artifacts/smoke-test.log`
   - Delete on success, preserve on failure

**Artifacts:**
- `artifacts/verification-report.md`
- `artifacts/smoke-test.log` (if applicable)
- `artifacts/changed-files.md`

**Exit criteria:**
- `verification-report.md` says PASS
- All checks green

---

### ARCHIVE

**Entry:** Verification PASS
**Exit:** Workspace clean, changes committed

**Actions:**
1. Move work-item to `_workspace/99_archive/`
2. Update CHANGELOG if method/ touched
3. **Commit workspace changes to git** (only `_workspace/` directory)
4. **Optional: Push to remote** if `FORGE_RD_AUTO_PUSH=1`
5. Reset `references/pipeline-state.json` to idle
6. Display: "Feature complete: <slug>"

**Git Commit:**
- Only stages `_workspace/` directory (method/ changes remain separate)
- Standard commit message format includes work-item slug
- Logs commit SHA to audit log and state.json
- Graceful failure: pipeline completes even if git fails

**Constraints:**
- Never archive unless verification PASS
- Never pushes unless `FORGE_RD_AUTO_PUSH=1` environment variable is set

---

## State Management

### state.json (Minimal State Machine)

```json
{
  "version": 1,
  "work_item": "2026-01-24-feature-slug",
  "phase": "AWAITING_APPROVAL",
  "status": "waiting",
  "status_display": "Governance checkpoint reached: human authority required",
  "canon_mode": false,
  "proposal_sha256": "abc123...",
  "blast_radius": {
    "cross_repo": false,
    "files_affected": 5
  },
  "started_at": "2026-01-24T10:00:00Z",
  "updated_at": "2026-01-24T14:30:00Z"
}
```

**Fields:**
- `version` — Schema version
- `work_item` — Current work-item slug
- `phase` — Current pipeline phase
- `status` — Machine-readable status
- `status_display` — Human-readable status
- `canon_mode` — Whether `--canon` was specified
- `proposal_sha256` — Hash for approval validation
- `commit_sha` — Git commit SHA (added after successful archive commit)
- `blast_radius` — Impact metrics
- `started_at` / `updated_at` — Timestamps

---

### audit-log.md (Append-Only)

```markdown
# Audit Log: 2026-01-24-feature-slug

## Events

| Timestamp | Phase | Event | Details |
|-----------|-------|-------|---------|
| 2026-01-24T10:00:00Z | INTAKE | Pipeline started | slug: feature-slug |
| 2026-01-24T10:05:00Z | INTAKE | Inventory complete | 5 files, 12KB total |
| 2026-01-24T10:30:00Z | RECON | Recon complete | No ambiguities |
| 2026-01-24T11:00:00Z | PROPOSAL | Ralph iteration 1 | Quality: FAIL (TBD found) |
| 2026-01-24T11:15:00Z | PROPOSAL | Ralph iteration 5 | Quality: PASS |
| 2026-01-24T11:16:00Z | AWAITING_APPROVAL | Approval requested | sha256: abc123... |
| 2026-01-24T12:00:00Z | AWAITING_APPROVAL | Approved | by: Leo |
| 2026-01-24T12:30:00Z | ARCHIVE | git_commit | sha: def456 |
| 2026-01-24T12:30:01Z | ARCHIVE | git_push | SKIPPED (not enabled) |
```

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `FORGE_ROOT` | Auto-detected from repo root | Path to FORGE umbrella repo |
| `FORGE_RD_AUTO_PUSH` | unset | Set to `1` or `true` to auto-push after archive |

To enable auto-push, add to your shell profile:
```bash
export FORGE_RD_AUTO_PUSH=1
```

---

## Constraints (Hard-Coded)

| Constraint | Value |
|------------|-------|
| Ralph max iterations | 10 |
| Clarifying questions cap | 10 |
| Blast radius (same-repo) | >10 files |
| Blast radius (cross-repo) | Always triggers |
| Canon paths | `method/core/**` |
| Unanswered questions | PAUSE (no guessing) |

---

## Never Automated (Explicit Exclusions)

These actions are NEVER executed by this pipeline:

1. **Version bumps + releases** — Tags, CHANGELOG publish, announcements
2. **method/core/** edits — Without `--canon` + confirm
3. **File deletion** — Outside `_workspace/99_archive/`
4. **Repo restructuring** — Moving folders, renaming repos
5. **Credentials/secrets** — No agent-managed secret handling

---

## Error Handling

### Hash Mismatch
```
ERROR: Proposal changed since approval request.
Stored hash: abc123...
Current hash: def456...
Action: Re-enter approval gate with /forge-rd status
```

### Canon Without Flag
```
ERROR: Canon change detected but --canon flag not provided.
Affected paths: method/core/forge-core.md
Action: Restart with /forge-rd start <slug> --canon
```

### Quality Gate Failure (Max Iterations)
```
WARNING: Ralph reached max iterations (10) without passing quality gate.
Blocking terms found: TBD (line 45), maybe (line 78)
Action: Manual review required. Edit proposal.md and run /forge-rd resume
```

### Verification Failure
```
ERROR: Verification failed. Cannot archive.
Sacred Four: FAIL (lint errors)
Action: Fix issues and run /forge-rd resume
```

---

## File Structure

```
~/.claude/skills/forge-rd-pipeline/
├── SKILL.md                          ← This file
├── resources/
│   ├── process-inbox.sh              ← Intake processing
│   ├── run-recon.sh                  ← Invoke recon-runner
│   ├── run-synthesis.sh              ← Invoke spec-writer
│   ├── run-ralph-proposal.sh         ← Ralph refinement loop
│   ├── quality-scan.sh               ← Proposal quality check
│   ├── compute-hash.sh               ← SHA-256 computation
│   ├── run-verification.sh           ← Verification suite
│   ├── smoke-test.sh                 ← Template instantiation test
│   └── archive-workitem.sh           ← Archive and cleanup
├── templates/
│   ├── work-item-readme.md           ← Work-item index template
│   ├── recon-report.md               ← Recon output template
│   ├── synthesis.md                  ← Synthesis output template
│   ├── proposal.md                   ← Proposal output template
│   ├── questions.md                  ← Clarifying questions template
│   ├── verification-report.md        ← Verification output template
│   ├── audit-log.md                  ← Audit log template
│   └── handoff-manifest.md           ← Handoff manifest template
├── references/
│   └── pipeline-state.json           ← Current pipeline state
└── hooks/
    └── (reserved for Phase 3+)
```

---

## Integration Points

### Sub-Agents Used
- `forge-recon-runner` — Specialized FORGE recon
- `spec-writer` — Synthesis and proposal generation (FORGE mode)
- `forge-maintainer` — Implementation execution

### Plugins Used
- `ralph-wiggum` — Proposal refinement iteration

### MCP Tools Used
- `perplexity_search` — Research phase (Phase 2+)
- `mcp__memory__*` — Context persistence (optional)

---

## Success Metrics

Pipeline run is successful when:
- [ ] Work-item created with complete inventory
- [ ] Recon report generated
- [ ] Proposal passes quality gate
- [ ] Human Lead approval received (with valid hash)
- [ ] Implementation complete
- [ ] Verification PASS
- [ ] Work-item archived
- [ ] State reset to idle

---

## Execution Instructions (For Claude)

When this skill is invoked, Claude should follow this operating sequence:

### On `/forge-rd start <slug> [--canon]`

1. Run `resources/process-inbox.sh <slug> [--canon]` to create work-item
2. Immediately proceed to RECON phase
3. Invoke `forge-recon-runner` sub-agent via Task tool with the prompt from `run-recon.sh`
4. Write recon report to `artifacts/recon-report.md`
5. If recon identifies open questions:
   - Create `artifacts/questions.md`
   - Set state to CLARIFYING_QUESTIONS
   - Wait for `/forge-rd answer` commands
6. If no questions, proceed directly to SYNTHESIS

### On SYNTHESIS Phase

1. Run `resources/run-synthesis.sh <work-item-path>`
2. Invoke `spec-writer` sub-agent via Task tool
3. Write synthesis to `artifacts/synthesis.md`
4. Proceed to PROPOSAL phase

### On PROPOSAL Phase (Ralph Loop)

1. Run `resources/run-ralph-proposal.sh <work-item-path> --iteration N`
2. Generate/refine proposal
3. Run `resources/quality-scan.sh artifacts/proposal.md`
4. If FAIL and iterations < 10: increment iteration, repeat
5. If FAIL and iterations >= 10: STOP, require manual intervention
6. If PASS:
   - Compute SHA-256 hash with `resources/compute-hash.sh`
   - Store hash in state.json
   - Set state to AWAITING_APPROVAL
   - Display: "Governance checkpoint reached: human authority required."

### On `/forge-rd approve`

1. Validate proposal hash matches stored hash
2. Check canon mode and --canon flag
3. Check blast radius thresholds
4. If confirmations needed, wait for `/forge-rd confirm`
5. Once all confirmations received, proceed to IMPLEMENT

### On IMPLEMENT Phase

1. Run `resources/run-implement.sh <work-item-path>`
2. Invoke `forge-maintainer` sub-agent via Task tool
3. Execute changes per proposal
4. Create local commits (never push)
5. Write implementation report to `artifacts/implementation.md`
6. Proceed to VERIFICATION

### On VERIFICATION Phase

1. Run `resources/run-verification.sh <work-item-path>`
2. Run Sacred Four if code changes
3. Run doc checks if doc changes
4. Run smoke test if template changes
5. Write report to `artifacts/verification-report.md`
6. If PASS, proceed to ARCHIVE
7. If FAIL, stop and require fixes

### On ARCHIVE Phase

1. Run `resources/archive-workitem.sh <work-item-path>`
2. Move work-item to `_workspace/99_archive/`
3. Reset global state to IDLE
4. Display: "Feature complete: <slug>"

### Sub-Agent Invocation Pattern

When invoking sub-agents, use the Task tool with:

```
Task(
  subagent_type="<agent-name>",
  prompt="<prompt from run-*.sh script>",
  description="<phase> phase for <work-item>"
)
```

Sub-agents to use:
- `forge-recon-runner` → Explore agent with recon-runner instructions
- `spec-writer` → spec-writer agent
- `forge-maintainer` → forge-maintainer agent

### State Transitions

```
IDLE → INTAKE → RECON → [CLARIFYING_QUESTIONS] → SYNTHESIS → PROPOSAL →
AWAITING_APPROVAL → [BLAST_RADIUS_CHECK] → IMPLEMENT → VERIFICATION → ARCHIVE → IDLE
```

Brackets indicate conditional phases.

### Error Recovery

- Hash mismatch: Display error, require re-review
- Max Ralph iterations: Stop, require manual edit
- Verification fail: Stop, require fixes
- Any failure: Log to audit, update state, wait for `/forge-rd resume`

---

*FORGE R&D Pipeline — Automating motion, not authority.*
