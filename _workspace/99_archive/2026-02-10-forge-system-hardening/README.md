# FORGE System Hardening

## Summary

Post-project foundations reset revealed four systemic gaps in FORGE methodology — not execution mistakes, but missing guardrails in the method, templates, and agent defaults. This feature hardens FORGE so these failures cannot recur in future projects.

## Problem

FORGE currently has strong declarative rules (canon says what MUST happen) but weak procedural enforcement (no mechanism stops agents when rules are violated). Specifically:

1. **Stakeholder Portal Drift** — No template, checklist, or decision gate for auth plane separation. "Auth/RBAC" and "Stakeholder Interface" are listed as Required Extensions but are two words each with no actionable specification.

2. **Tests-First Canon Violation** — Sacred Four checks if tests *pass*, not if tests *exist*. Zero tests = zero failures = gate "passes." Multiple PRs shipped with no test infrastructure.

3. **Missing Structural Signals** — No agent validates project location, directory structure, or governance files. Only check is `FORGE-ENTRY.md` existence.

4. **Implicit vs Explicit Canon** — Agent constraints are prohibition-based (MUST NOT) not precondition-based (MUST VERIFY). Agents optimize for forward motion instead of canonical correctness.

## Proposed Approach

- Add pre-flight verification to agent startup sequences
- Create new Phase 0 (Scaffold Verification) between @C and @F
- Add mandatory auth architecture decision gates
- Fix Sacred Four to treat zero tests as failure
- Add structural integrity checks to @G transitions
- Create new templates (Stakeholder Model, Auth ADR, Test Infrastructure, Pre-Flight Checklist)
- Extend Law 5 with precondition verification language

## Materials Included

- `threads/system-review-analysis.md` — Full root cause analysis with findings, recommendations, draft canon language, enforcement matrix, and prioritized change list

## Submitter

Leo (Human Lead) — via system review session
