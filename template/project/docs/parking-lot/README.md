# Parking Lot

**Issues and ideas discovered during development that shouldn't derail current PR scope.**

---

## Purpose

During implementation, agents (CC, Cursor) often discover:
- Bugs unrelated to the current PR
- Missing features that would be nice but aren't in scope
- Technical debt worth addressing later
- Security concerns that need follow-up
- Optimization opportunities

Without a parking lot, these discoveries get lost in conversation history. The parking lot ensures nothing falls through the cracks.

---

## Files

| File | What Goes Here |
|------|----------------|
| `known-issues.md` | Bugs, broken things, security risks, technical debt |
| `future-work.md` | Feature ideas, enhancements, optimizations, nice-to-haves |

---

## Entry Format

```markdown
## [YYYY-MM-DD] Short Title

**Source:** PR-XX or context | **Severity:** Low/Medium/High | **Effort:** X hrs

One-paragraph description of the issue or idea.

**Workaround:** (if applicable for known-issues)

**Fix:** Proposed solution or next steps.
```

---

## Workflow

1. **Discover** an issue or idea during PR work
2. **Log immediately** to the appropriate parking-lot file
3. **Continue** with current PR scope
4. **Review** parking lot when planning future PRs
5. **Graduate** items to GitHub Issues when prioritized for a specific PR

---

## Governance

- **Authored by:** CC (during execution), or FAI (if adopted)
- **Reviewed by:** Human Lead (during planning)
- **Graduated:** Items move to GitHub Issues when prioritized

---

## FAI Integration (Optional)

If this project uses FORGE AI Interface (FAI), feedback captured through FAI conversations is automatically routed here:

- **Bugs** → `known-issues.md`
- **Feature requests** → `future-work.md`

FAI entries include the `**Source:** FAI Conversation` tag for traceability.

See `docs/constitution/FAI.md` for FAI configuration.

---

**Golden Rule:** Don't let discoveries get lost in conversation history. If it's not in scope, park it.

---

*This is part of The FORGE Method(TM) — theforgemethod.org*
