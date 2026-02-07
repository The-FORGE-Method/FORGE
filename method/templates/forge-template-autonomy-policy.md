# FORGE Template: Autonomy Policy (FORGE-AUTONOMY.yml)

**Template ID:** forge-template-autonomy-policy
**Version:** 1.0
**Status:** [OPS]
**Introduced:** v1.3.0 (Decision-005)

---

## Purpose

This template documents the schema and usage of `FORGE-AUTONOMY.yml`, the per-project autonomy policy file that configures how @G (Govern) routes cross-lane transitions.

## Schema Version

**Current:** 0.1
**Location:** Project root (`FORGE-AUTONOMY.yml`)

## Default Template

```yaml
# FORGE Autonomy Policy
# Schema version: 0.1
# Documentation: method/templates/forge-template-autonomy-policy.md

version: 0.1

# Autonomy tier determines routing behavior
# Tier 0: @G refuses transitions, instructs human (default)
# Tier 1: @G asks human approval before dispatching
# Tier 2: Auto-dispatch with guardrails (Phase 2)
# Tier 3: Full autonomous pipeline (Phase 2)
tier: 0

# Pre-FORGE gate: file that must exist to unlock F/O/R/G/E agents
forge_entry:
  required_file: "abc/FORGE-ENTRY.md"
  unlock_on_approval: true

# Router behavior constraints
router:
  # All transitions must route through @G (no direct role-to-role)
  allow_direct_role_to_role: false
  # Where transition events are logged
  event_log_path: "docs/router-events/"

# Allowed transitions when @G is permitted to route (Tier 1+)
# Tier 0 ignores this and refuses all transitions
allowed_transitions:
  - from: F
    to: O
  - from: O
    to: R
  - from: R
    to: G
  - from: G
    to: E

# Actions that always require human approval regardless of tier
human_gates:
  - constitution_change
  - scope_change
  - architecture_change
  - production_deploy
  - billing_or_payments
  - secrets_or_credentials
  - data_migration_destructive

# Blast radius thresholds for automatic routing (Tier 2/3 only)
# Tier 0/1 ignores these (no auto-dispatch)
blast_radius:
  max_files_changed_auto: 20
  max_loc_changed_auto: 800
  forbid_paths:
    - "docs/constitution/**"
    - "infra/prod/**"

# Notifications
notifications:
  on_checkpoint: true
  on_exception: true
  on_autoroute: false  # Not applicable in Tier 0/1
```

## Field Reference

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `version` | string | Yes | `"0.1"` | Schema version |
| `tier` | integer | Yes | `0` | Autonomy tier (0-3) |
| `forge_entry.required_file` | string | Yes | `"abc/FORGE-ENTRY.md"` | Gate artifact path |
| `forge_entry.unlock_on_approval` | boolean | Yes | `true` | Auto-unlock on human approval |
| `router.allow_direct_role_to_role` | boolean | Yes | `false` | Must be `false` (all transitions via @G) |
| `router.event_log_path` | string | Yes | `"docs/router-events/"` | Event log directory |
| `allowed_transitions` | array | Yes | F→O→R→G→E | Permitted transition pairs |
| `human_gates` | array | Yes | See template | Actions requiring human approval at all tiers |
| `blast_radius.max_files_changed_auto` | integer | No | `20` | Max files for auto-routing (Tier 2/3) |
| `blast_radius.max_loc_changed_auto` | integer | No | `800` | Max LOC for auto-routing (Tier 2/3) |
| `blast_radius.forbid_paths` | array | No | See template | Paths that always require human approval |
| `notifications.on_checkpoint` | boolean | No | `true` | Notify on governance checkpoints |
| `notifications.on_exception` | boolean | No | `true` | Notify on routing errors |
| `notifications.on_autoroute` | boolean | No | `false` | Notify on auto-dispatch (Tier 2/3) |

## Tier Behavior Summary

| Tier | Phase | @G Behavior |
|------|-------|-------------|
| **0** | Phase 1 (default) | Refuses all transitions; instructs human to invoke target role directly |
| **1** | Phase 1 (schema only) | Presents transition proposal to human; dispatches on approval |
| **2** | Phase 2 | Auto-dispatches within policy constraints; human gates still enforced |
| **3** | Phase 2 | Full autonomous F→O→R→G→E pipeline; human gates still enforced |

## Constraints

- Pre-FORGE agents (A/B/C) are always capped at Tier 0 regardless of this file's `tier` setting
- `allow_direct_role_to_role` must be `false` — @G is the only valid router
- `human_gates` are enforced at ALL tiers, including Tier 3
- Tier 0 behavior is enforced regardless of schema content in Phase 1
- The autonomy engine is stubbed in Phase 1 — the schema documents intent for future upgrades

## Migration Guide

**Existing projects** are grandfathered and do not require this file. Adding `FORGE-AUTONOMY.yml` to an existing project is opt-in.

**New projects** created from `template/project` include this file with `tier: 0` by default.

---

*This template follows The FORGE Method™ — theforgemethod.org*
