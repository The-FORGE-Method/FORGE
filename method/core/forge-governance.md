# FORGE Versioning & Governance

**Change Management for The FORGE Method™**

**Version:** 1.0  
**Steward:** FORGE Maintainers  
**Status:** Governance Reference

---

## Purpose

FORGE should feel *alive*, not brittle. This document establishes how FORGE evolves while maintaining coherence.

---

## Versioning Rules

### Version Format

FORGE uses semantic versioning: `MAJOR.MINOR.PATCH`

```
FORGE v1.2.3
        │ │ │
        │ │ └── Patch: corrections, clarifications
        │ └──── Minor: new capabilities, significant clarifications
        └────── Major: fundamental changes to principles or structure
```

### What Constitutes Each Level

**Major Version (2.0, 3.0)**
- Changes to the Five Laws
- Changes to the macro-step sequence (F-O-R-G-E)
- Fundamental restructuring of agent roles
- Breaking changes to core concepts

**Minor Version (1.1, 1.2)**
- New sections added to Operations Manual
- New templates added
- Significant clarifications that change behavior
- New decision heuristics documented
- The FORGE Cycle modifications

**Patch Version (1.1.1)**
- Typo corrections
- Minor clarifications that don't change behavior
- Example updates
- Formatting improvements

### Version History Location

Each FORGE document maintains its own version history in an appendix. The canonical version is tracked in FORGE Core.

---

## Document Hierarchy

### Canonical Documents

| Document | Stability | Update Frequency |
|----------|-----------|------------------|
| **FORGE Core** | High | Rarely (major insights only) |
| **FORGE Operations Manual** | Medium | As execution patterns evolve |
| **FORGE Templates** | Medium | As better patterns emerge |
| **FORGE Governance** | High | Rarely |

### Change Authority

| Change Type | Authority |
|-------------|-----------|
| Core principles | FORGE maintainers only |
| Operations content | FORGE maintainers + vetted contributors |
| Templates | Community contribution welcome |
| Contextual adaptations | Individual teams |

---

## Feedback Integration

### Sources of Feedback

1. **Internal execution** — Our own projects using FORGE
2. **CC/Quality Gate reports** — Ground-truth from execution agents
3. **Community adoption** — External teams using FORGE
4. **Formal proposals** — Structured improvement suggestions

### Ground Truth Inputs

The most valuable feedback comes from execution reality:

| Source | Value |
|--------|-------|
| CC execution reviews | What actually happens vs. what we documented |
| Failed cycles / abandoned PRs | Where the method breaks down |
| Community misuse patterns | Where documentation is unclear |
| Onboarding friction | What new agents struggle with |

Execution failures are as valuable as successes. Document both.

### Feedback Flow

```
Feedback Source
      ↓
Triage (Universal? Contextual? Situational?)
      ↓
If Universal → Propose for Operations Manual
If Contextual → Document as example, not rule
If Situational → Note in guidance, not requirement
      ↓
Review by Steward
      ↓
If Approved → Version bump + changelog
If Rejected → Document rationale
```

### Classification Requirement

All feedback must be classified before integration:

| Label | Meaning | Integration Path |
|-------|---------|------------------|
| **[UNIVERSAL]** | Applies to any FORGE project | Add to Operations Manual |
| **[CONTEXTUAL]** | Project or stack specific | Add as example with context |
| **[SITUATIONAL]** | Depends on maturity or risk | Add as guidance with conditions |

---

## Change Process

### For Minor Changes (Patches)

1. Identify the correction
2. Verify it doesn't change behavior
3. Update document
4. Bump patch version
5. Note in document changelog

**No formal review required.**

### For Moderate Changes (Minor Versions)

1. Document the proposed change
2. Classify as Universal/Contextual/Situational
3. Review against existing content for conflicts
4. Steward approval required
5. Update document(s)
6. Bump minor version
7. Note in all affected document changelogs

### For Significant Changes (Major Versions)

1. Write formal proposal with:
   - What's changing
   - Why it's necessary
   - Impact on existing users
   - Migration guidance
2. Review period (community input if public)
3. Steward final decision
4. Update all affected documents
5. Bump major version
6. Publish migration guide if needed

---

## What Stays Closed vs Open

### Stewarded (Maintainer Controlled)

- FORGE Core principles and laws
- The FORGE Cycle definition
- Agent role boundaries
- Canonical document hierarchy
- Trademark and branding

### Open for Contribution

- Templates (improvements welcome)
- Stack-specific examples
- Case studies
- Contextual adaptations
- Tooling and automation

### Community Adaptation Rights

Teams using FORGE may:
- Adapt templates to their needs
- Create stack-specific variations
- Extend with additional practices
- Create derivative methodologies (with attribution)

Teams using FORGE may NOT:
- Claim ownership of FORGE
- Remove attribution
- Use FORGE trademark for competing methodologies
- Represent adaptations as canonical FORGE

### Governance Anti-Goals

What FORGE governance explicitly avoids:

| Anti-Goal | Why |
|-----------|-----|
| Consensus-driven dilution | Coherence requires stewardship, not voting |
| Framework bloat | Simplicity is a feature; complexity is debt |
| Tooling dependency lock-in | FORGE is methodology, not software |
| Prescriptive rigidity | Principles are fixed; practices adapt |
| Academic abstraction | If it doesn't run, it doesn't belong |

---

## Quality Standards

### For Operations Manual Content

Content added to the Operations Manual must:
- Be grounded in real execution experience
- Include classification labels
- Specify failure modes where applicable
- Be written for execution fidelity, not elegance

### For Templates

Templates must include:
- When to use
- What problem it prevents
- Common failure modes
- Adaptation guidance

### For Examples

Examples must:
- Be real (not hypothetical)
- Include context (what project, what conditions)
- Note what's Universal vs Contextual

---

## Autonomy Model Governance (v1.3)

FORGE v1.3 introduces a configurable autonomy model via `FORGE-AUTONOMY.yml`. This section governs how autonomy tiers are managed.

### Tier Definitions

| Tier | Behavior | Governance Level | Version |
|------|----------|-----------------|---------|
| **0** | @G refuses all transitions; instructs human | Fully human-mediated | v1.3 (default) |
| **1** | @G proposes transitions; human approves | Human-approved routing | v1.3 (schema only) |
| **2** | @G auto-dispatches within policy constraints | Policy-governed routing | Future MAJOR |
| **3** | Full autonomous F→O→R→G→E pipeline | Autonomous with human gates | Future MAJOR |

### Governance Rules

1. **Tier changes require decision records** — Upgrading from Tier 0 to Tier 1 requires a project-level decision. Upgrading to Tier 2/3 requires a FORGE MAJOR version decision.
2. **Pre-FORGE agents (A/B/C) are always Tier 0** — The pre-commitment lifecycle always requires human mediation.
3. **Human gates are enforced at all tiers** — Constitution changes, scope changes, architecture changes, and production deploys always require human approval.
4. **@G is the only router** — No direct role-to-role transitions at any tier. All routing through @G.
5. **Fallback to Tier 0 on error** — Any routing failure degrades gracefully to human-mediated mode.

### Decision History

| Decision | Tier Impact | Version |
|----------|-------------|---------|
| Decision-003 | Established F/O/R/G/E lanes with human-mediated routing | v1.2 |
| Decision-004 | Formalized Ops Agent as G phase owner | v1.2 |
| Decision-005 | Added @role addressing, Tier 0-1, AMENDED Decision-003 | v1.3 |

See `_workspace/05_decisions/` for full decision records.

---

## Review Cadence

| Review Type | Frequency | Purpose |
|-------------|-----------|---------|
| Patch review | As needed | Corrections |
| Minor review | Quarterly | Incorporate learnings |
| Major review | Annually | Structural assessment |
| Community sync | Biannually | Gather external feedback |

---

## Extensions

### What Are Extensions?

Extensions are optional capabilities that projects may adopt. They are documented in `docs/extensions/` and follow these rules:

1. **Always Optional** — No extension is required for FORGE compliance
2. **Self-Contained** — Each extension has clear boundaries and adoption criteria
3. **Additive Only** — Extensions enhance FORGE; they never override core principles
4. **Versioned Independently** — Extensions have their own version history

### Extension Governance

| Aspect | Rule |
|--------|------|
| Creation | Requires demonstrated need across multiple projects |
| Approval | FORGE maintainer approval required |
| Documentation | Must include: overview, boundaries, adoption criteria, security model |
| Classification | Extensions are always **[CONTEXTUAL]** — not universal requirements |

### Current Extensions

| Extension | Status | Added |
|-----------|--------|-------|
| [FORGE AI Interface (FAI)](../docs/extensions/fai-overview.md) | Available | 2026-01-16 |

---

## Deprecation Policy

When content becomes outdated:

1. Mark as deprecated with date
2. Provide replacement reference
3. Maintain for 2 minor versions
4. Remove in subsequent minor version

**Example:**
```markdown
> ⚠️ **DEPRECATED (v1.2):** This section is superseded by [Section X].
> Will be removed in v1.4.
```

---

## Conflict Resolution

When FORGE documents conflict:

1. **Core vs Operations:** Core wins
2. **Operations vs Templates:** Operations wins
3. **Any document vs Human instruction:** Human wins (document the override)

When community interpretations conflict:

1. Refer to canonical documents
2. If still unclear, Steward provides clarification
3. Clarification becomes patch update

---

## Metrics for Success

FORGE governance is successful if:

- [ ] New projects can adopt FORGE without confusion
- [ ] CC/Quality Gate agents recognize Operations Manual as accurate
- [ ] Community can contribute without breaking coherence
- [ ] Improvements integrate cleanly
- [ ] Version history tells a clear evolution story

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-01-04 | Initial governance framework |
| 1.1 | 2026-01-16 | Added Extensions section; documented FORGE AI Interface (FAI) as first extension |

---

**© 2026 FORGE Contributors. All rights reserved.**

**FORGE™** is a trademark of its contributors.
