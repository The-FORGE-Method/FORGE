# Router Events

This directory contains append-only event logs produced by @G (Govern) when processing cross-lane transition requests.

## Format

- **File format:** JSON Lines (`.jsonl`) — one JSON object per line
- **File naming:** `YYYY-MM-DD.jsonl` (one file per calendar day)
- **Retention:** Append-only. Events are never deleted.

## Querying

```bash
# View today's events
cat docs/router-events/$(date +%Y-%m-%d).jsonl | jq .

# Find all refused transitions
grep '"refused_tier0"' docs/router-events/*.jsonl

# Count events by source role
cat docs/router-events/*.jsonl | jq -r '.source_role' | sort | uniq -c
```

## Schema

See `method/templates/forge-template-router-events.md` for full event schema documentation.

---

*Part of The FORGE Method™ — theforgemethod.org*
