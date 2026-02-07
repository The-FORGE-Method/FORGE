# FAI.md

**FORGE AI Interface Configuration**

**Status:** DISABLED
**Version:** 0.0
**Last Updated:** —

---

## Purpose

This document configures FORGE AI Interface (FAI) for this project. FAI provides a first-class AI interface layer for user-facing Q&A, action execution, feedback capture, and multimodal intake.

**FAI is an interface layer, not an autonomous agent.** FAI never autonomously modifies code, creates PRs, or merges changes.

---

## Adoption Status

> **DISABLED** — Set to **ENABLED** when adopting FAI.
>
> If your project does not need FAI capabilities, leave this file as-is.
> FAI is optional; projects function fully without it.

---

## Required Content (When ENABLED)

When adopting FAI, complete the following sections:

### 1. Knowledge Sources

Define what FAI can access for Q&A:

```yaml
knowledge_sources:
  - type: repository_docs
    paths:
      - docs/**/*.md
      - README.md
    refresh: on_push  # or: hourly, daily

  - type: api_spec
    path: openapi.yaml
    refresh: on_push

  - type: generated_summaries
    source: system_prompts
    refresh: weekly
```

### 2. Action Permissions

Define what actions FAI can execute on behalf of users:

```yaml
action_permissions:
  # Read-only tier (default)
  read:
    - documents:read
    - entities:read
    - user_profile:read

  # Write tier (requires confirm-before-act)
  write:
    - entities:update
    - settings:update
    # Explicitly excluded:
    # - entities:delete
    # - admin:*

  # Dangerous actions (always require explicit confirmation)
  dangerous:
    - entities:delete
    - bulk_operations:*
```

### 3. GitHub App Configuration

```yaml
github_app:
  name: "[PROJECT]-fai"

  permissions:
    # Read-only by default
    contents: read
    issues: read
    pull_requests: read

    # Write only if action execution enabled
    # issues: write  # Uncomment if FAI creates issues

  repositories:
    - [project-repo]  # Specific repos only, never "all"

  token_expiry: 8h  # Maximum allowed
```

### 4. Feedback Routing

```yaml
feedback_routing:
  # Where FAI deposits structured feedback
  bugs:
    destination: docs/parking-lot/known-issues.md
    format: parking-lot-entry

  features:
    destination: docs/parking-lot/future-work.md
    format: parking-lot-entry

  urgent:
    destination: docs/parking-lot/urgent-items.md
    format: parking-lot-entry
    notify: true
```

### 5. Security Configuration

```yaml
security:
  # RBAC mirroring - FAI inherits user's permissions
  rbac_mode: mirror_user

  # Confirm-before-act - always enabled for write actions
  confirm_before_act: true

  # Audit logging
  audit:
    enabled: true
    log_actions: true
    log_queries: false  # Optional for Q&A

  # Token isolation
  token_isolation: true  # FAI tokens separate from user tokens
```

### 6. Capability Tiers

Enable only the tiers this project needs:

```yaml
capabilities:
  tier_1_qa: true      # Read-only Q&A
  tier_2_actions: false # Action execution
  tier_3_feedback: true # Feedback capture
  tier_4_multimodal: false # Screenshots/recordings
```

---

## Hard Boundaries (Non-Negotiable)

These constraints apply regardless of configuration:

| Boundary | Enforcement |
|----------|-------------|
| No code modification | FAI has no write access to source files |
| No PR creation | PRs remain in Quality Gate lane |
| No auto-merge | All merges require Human Lead approval |
| No credential storage | Short-lived, scoped tokens only |
| No permission escalation | FAI token scope ⊆ user permission scope |
| Human greenlight required | Write actions require explicit user confirmation |

---

## How to Enable

1. Set Status to **ENABLED** at the top of this file
2. Complete all required sections above
3. Create GitHub App with specified permissions
4. Configure feedback routing
5. Update project's CLAUDE.md to reference this file
6. Add FAI to team onboarding documentation

---

## Integration Verification

Before going live, verify:

- [ ] GitHub App created with minimal permissions
- [ ] Knowledge sources accessible and up-to-date
- [ ] Action permissions match GOVERNANCE.md authorization model
- [ ] Feedback routing tested (creates parking-lot entries)
- [ ] Confirm-before-act working for write actions
- [ ] Audit logging enabled and accessible
- [ ] Team understands FAI boundaries

---

*This project follows The FORGE Method(TM) — theforgemethod.org*
