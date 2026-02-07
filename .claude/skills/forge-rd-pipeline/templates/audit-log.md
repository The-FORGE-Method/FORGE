# Audit Log: {{SLUG}}

**Work-Item:** {{WORK_ITEM_PATH}}
**Created:** {{CREATED_AT}}
**Canon Mode:** {{CANON_MODE}}

---

## Events

| Timestamp | Phase | Event | Details |
|-----------|-------|-------|---------|
| {{TIMESTAMP}} | {{PHASE}} | {{EVENT}} | {{DETAILS}} |

---

## Event Reference

### Pipeline Events

| Event | Description |
|-------|-------------|
| `pipeline_started` | Pipeline initialized with `/forge-rd start` |
| `pipeline_completed` | All phases complete, work-item archived |
| `pipeline_cancelled` | Pipeline cancelled with `/forge-rd cancel` |
| `pipeline_held` | Pipeline paused with `/forge-rd hold` |
| `pipeline_resumed` | Pipeline resumed with `/forge-rd resume` |

### Phase Events

| Event | Description |
|-------|-------------|
| `intake_complete` | Inventory generated, sanity checks passed |
| `recon_complete` | Recon report generated |
| `questions_generated` | Clarifying questions created |
| `question_answered` | A clarifying question was answered |
| `synthesis_complete` | Synthesis document generated |
| `proposal_generated` | Initial proposal created |
| `ralph_iteration` | Ralph refinement iteration completed |
| `quality_pass` | Proposal passed quality gate |
| `quality_fail` | Proposal failed quality gate |
| `approval_requested` | Governance checkpoint reached |
| `approved` | Human Lead approved proposal |
| `approved_canon` | Human Lead approved canon change |
| `rejected` | Human Lead rejected proposal |
| `confirmed` | Second confirmation received |
| `blast_radius_warning` | Blast radius threshold exceeded |
| `implementation_started` | Implementation phase began |
| `implementation_complete` | Implementation finished |
| `verification_pass` | All verification checks passed |
| `verification_fail` | Verification checks failed |
| `archived` | Work-item moved to archive |

### Error Events

| Event | Description |
|-------|-------------|
| `hash_mismatch` | Proposal changed since approval request |
| `canon_flag_missing` | Canon change detected without --canon |
| `max_iterations` | Ralph reached max iterations |
| `smoke_test_fail` | Template smoke test failed |

---

## Approvals

| Timestamp | Type | Approved By | Hash |
|-----------|------|-------------|------|
| {{APPROVAL_TIME}} | {{APPROVAL_TYPE}} | {{APPROVED_BY}} | {{HASH}} |

---

## Rejections

| Timestamp | Rejected By | Feedback |
|-----------|-------------|----------|
| {{REJECTION_TIME}} | {{REJECTED_BY}} | {{FEEDBACK}} |

---

## Questions & Answers

| Timestamp | Question ID | Answer | Answered By |
|-----------|-------------|--------|-------------|
| {{QA_TIME}} | {{Q_ID}} | {{ANSWER}} | {{ANSWERED_BY}} |

---

*Append-only log — Do not edit previous entries*
