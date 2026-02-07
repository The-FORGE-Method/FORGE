# FORGE Template: Router Events

**Template ID:** forge-template-router-events
**Version:** 1.0
**Status:** [OPS]
**Introduced:** v1.3.0 (Decision-005)

---

## Purpose

Documents the format and usage of router event logs produced by @G (Govern) when processing cross-lane transition requests.

## Location

```
docs/router-events/
├── README.md              ← Usage documentation
├── 2026-02-06.jsonl       ← One file per day, append-only
├── 2026-02-07.jsonl
└── ...
```

## Format

**File format:** JSON Lines (`.jsonl`) — one JSON object per line, newline-delimited.

**File naming:** `YYYY-MM-DD.jsonl` (one file per calendar day)

**Retention:** Append-only. Events are never deleted or rotated.

## Event Schema

```json
{
  "timestamp": "2026-02-06T14:32:15Z",
  "tier": 0,
  "source_role": "F",
  "target_role": "O",
  "request_type": "transition",
  "action": "refused_tier0",
  "human_instruction": "Human must invoke @O directly",
  "payload_summary": "Product intent complete, architecture needed",
  "event_id": "evt_20260206_143215_f_o"
}
```

## Field Reference

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `timestamp` | ISO 8601 | Yes | When the event occurred |
| `tier` | integer | Yes | Active autonomy tier at time of event |
| `source_role` | string | Yes | Role that initiated the request (A/B/C/F/O/R/G/E) |
| `target_role` | string | Yes | Target role for the transition |
| `request_type` | string | Yes | Type of request (see Event Types) |
| `action` | string | Yes | Action taken by @G (see Actions) |
| `human_instruction` | string | Tier 0/1 | Instruction given to human |
| `payload_summary` | string | No | Brief description of the transition payload |
| `event_id` | string | Yes | Unique event identifier |
| `error` | string | No | Error details (for error/fallback events) |
| `approved_by` | string | Tier 1+ | Who approved the transition |

## Event Types

| Type | Description |
|------|-------------|
| `transition` | Role requests @G to route to another role |
| `error` | Routing failure, policy malformation |
| `fallback` | Error handler fell back to Tier 0 |
| `gate_check` | FORGE-ENTRY.md gate evaluation |

## Actions

| Action | Tier | Description |
|--------|------|-------------|
| `refused_tier0` | 0 | @G refused and instructed human |
| `approval_requested` | 1 | @G asked human for approval |
| `approved_dispatched` | 1+ | Human approved, @G dispatched |
| `rejected` | 1+ | Human rejected the transition |
| `auto_dispatched` | 2/3 | @G auto-dispatched per policy |
| `fallback_tier0` | Any | Error caused fallback to Tier 0 |
| `gate_blocked` | Any | FORGE-ENTRY.md gate blocked a FORGE agent |
| `gate_warned` | Any | Pre-FORGE agent invoked after FORGE unlock |

## Event ID Format

```
evt_YYYYMMDD_HHMMSS_<source>_<target>
```

Example: `evt_20260206_143215_f_o` — transition request from @F to @O on 2026-02-06 at 14:32:15.

## Querying Events (Phase 1)

Phase 1 uses manual inspection:

```bash
# View today's events
cat docs/router-events/$(date +%Y-%m-%d).jsonl | jq .

# Find all refused transitions
grep '"refused_tier0"' docs/router-events/*.jsonl

# Count events by source role
cat docs/router-events/*.jsonl | jq -r '.source_role' | sort | uniq -c

# Find errors
grep '"error"' docs/router-events/*.jsonl | jq .
```

Phase 2 may add dedicated query tools.

## Example Log

```jsonl
{"timestamp":"2026-02-06T09:15:00Z","tier":0,"source_role":"A","target_role":"C","request_type":"transition","action":"refused_tier0","human_instruction":"Human must invoke @C directly","payload_summary":"Intake complete, ready for commitment","event_id":"evt_20260206_091500_a_c"}
{"timestamp":"2026-02-06T10:30:45Z","tier":0,"source_role":"F","target_role":"O","request_type":"transition","action":"refused_tier0","human_instruction":"Human must invoke @O directly","payload_summary":"PRODUCT.md complete, architecture needed","event_id":"evt_20260206_103045_f_o"}
{"timestamp":"2026-02-06T14:22:10Z","tier":0,"source_role":"G","target_role":"E","request_type":"transition","action":"refused_tier0","human_instruction":"Human must invoke @E directly","payload_summary":"Handoff packet ready for execution","event_id":"evt_20260206_142210_g_e"}
```

---

*This template follows The FORGE Method™ — theforgemethod.org*
