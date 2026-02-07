#!/bin/bash
# run-ralph-proposal.sh
# FORGE R&D Pipeline - Proposal Generation with Ralph Refinement
#
# Usage: ./run-ralph-proposal.sh <work-item-path> [--iteration <n>]
#
# Generates proposal and runs Ralph Wiggum refinement loop

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
FORGE_ROOT="${FORGE_ROOT:-$(cd "$(dirname "$0")/../../../.." && pwd)}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_phase() { echo -e "${BLUE}[PROPOSAL]${NC} $1"; }
log_ralph() { echo -e "${MAGENTA}[RALPH]${NC} $1"; }

WORK_ITEM_PATH="${1:-}"
ITERATION="${2:-1}"
MAX_ITERATIONS=10

if [[ -z "$WORK_ITEM_PATH" ]] || [[ ! -d "$WORK_ITEM_PATH" ]]; then
    log_error "Usage: $0 <work-item-path> [iteration]"
    exit 1
fi

# Parse --iteration flag
while [[ $# -gt 0 ]]; do
    case $1 in
        --iteration)
            ITERATION="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

WORK_ITEM=$(basename "$WORK_ITEM_PATH")
STATE_FILE="$WORK_ITEM_PATH/state.json"
AUDIT_LOG="$WORK_ITEM_PATH/audit-log.md"
SYNTHESIS_FILE="$WORK_ITEM_PATH/artifacts/synthesis.md"
PROPOSAL_OUTPUT="$WORK_ITEM_PATH/artifacts/proposal.md"
QUALITY_REPORT="$WORK_ITEM_PATH/artifacts/proposal-quality-report.md"

log_phase "Starting PROPOSAL phase for: $WORK_ITEM (iteration $ITERATION)"

# Update state
update_state() {
    local phase="$1"
    local status="$2"
    local display="$3"
    local iterations="$4"

    python3 << EOF
import json
from datetime import datetime

with open('$STATE_FILE', 'r') as f:
    state = json.load(f)

state['phase'] = '$phase'
state['status'] = '$status'
state['status_display'] = '$display'
state['ralph_iterations'] = $iterations
state['updated_at'] = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')

with open('$STATE_FILE', 'w') as f:
    json.dump(state, f, indent=2)
EOF
}

# Log audit event
log_audit() {
    local event="$1"
    local details="$2"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    sed -i '' "/^| Timestamp | Phase | Event | Details |/a\\
| $timestamp | PROPOSAL | $event | $details |" "$AUDIT_LOG" 2>/dev/null || true
}

# Verify synthesis exists
if [[ ! -f "$SYNTHESIS_FILE" ]]; then
    log_error "Synthesis document not found: $SYNTHESIS_FILE"
    log_error "Run synthesis phase first."
    exit 1
fi

# Check iteration limit
if [[ $ITERATION -gt $MAX_ITERATIONS ]]; then
    log_error "Max iterations ($MAX_ITERATIONS) reached."
    log_error "Manual intervention required."
    update_state "PROPOSAL" "blocked" "Ralph max iterations reached. Manual review required." "$ITERATION"
    log_audit "max_iterations" "Ralph reached iteration $ITERATION without passing quality gate"
    exit 1
fi

update_state "PROPOSAL" "running" "Generating proposal (Ralph iteration $ITERATION)..." "$ITERATION"

# Get canon mode from state
CANON_MODE=$(python3 -c "import json; print(json.load(open('$STATE_FILE')).get('canon_mode', False))")

# Build the proposal prompt
if [[ $ITERATION -eq 1 ]]; then
    # Initial proposal generation
    PROPOSAL_PROMPT="You are generating a FORGE R&D proposal.

## Input Context

**Work-Item:** $WORK_ITEM_PATH
**Date:** $(date +%Y-%m-%d)
**Canon Mode:** $CANON_MODE
**Iteration:** $ITERATION (initial)

### Synthesis Document
Read the synthesis at: $SYNTHESIS_FILE

### Source Material
- Work-item directory: $WORK_ITEM_PATH

## Your Task

Generate a complete proposal document at: $PROPOSAL_OUTPUT

The proposal MUST include ALL of these sections:
1. Summary
2. Background (context + prior work)
3. Proposal (what + how + UX)
4. Technical Specification (architecture, components, data model, API)
5. Implementation Plan (phases, file changes, dependencies)
6. Acceptance Criteria (MUST be binary pass/fail - no ambiguity)
7. Risks & Mitigations (every risk needs a mitigation)
8. Rollback Plan
9. Testing Strategy
10. Documentation Updates
11. Blast Radius (cross-repo?, files affected, requires confirmation?)

## Critical Requirements

- NO forbidden terms: TBD, ???, maybe, should, consider, TODO, FIXME
- ALL acceptance criteria must be binary (verifiable pass/fail)
- ALL risks must have mitigations
- Blast radius must be explicitly calculated
- Canon Mode is $CANON_MODE - if true, flag method/core/ changes

## Output

Write the complete proposal to: $PROPOSAL_OUTPUT

After writing, the quality gate will scan for issues."

else
    # Ralph refinement iteration
    PROPOSAL_PROMPT="You are refining a FORGE R&D proposal using Ralph Wiggum technique.

## Context

**Work-Item:** $WORK_ITEM_PATH
**Iteration:** $ITERATION of $MAX_ITERATIONS
**Previous Quality Report:** $QUALITY_REPORT

### Current Proposal
Read the current proposal at: $PROPOSAL_OUTPUT

### Quality Gate Failures
Read the quality report at: $QUALITY_REPORT

## Your Task

Fix ALL issues identified in the quality report:
1. Remove or replace forbidden terms (TBD, ???, maybe, should, consider, TODO, FIXME)
2. Add missing sections
3. Make acceptance criteria binary (pass/fail only)
4. Ensure all risks have mitigations
5. Resolve any ambiguities

## Ralph Wiggum Technique

Ask yourself for each issue:
- \"What specifically is unclear here?\"
- \"What concrete value should replace this placeholder?\"
- \"Is this criterion verifiable with a yes/no answer?\"

Do NOT:
- Leave any issue unaddressed
- Add new placeholder text
- Introduce new forbidden terms

## Output

Rewrite the complete proposal to: $PROPOSAL_OUTPUT

Make it pass the quality gate this iteration."

fi

log_ralph "Iteration $ITERATION - $(if [[ $ITERATION -eq 1 ]]; then echo 'Initial generation'; else echo 'Refinement pass'; fi)"

echo "---PROPOSAL_PROMPT_START---"
echo "$PROPOSAL_PROMPT"
echo "---PROPOSAL_PROMPT_END---"

log_audit "ralph_iteration" "Starting iteration $ITERATION"

log_phase "Proposal prompt generated. Awaiting execution."
log_info "Output: $PROPOSAL_OUTPUT"
log_info "After generation, run quality-scan.sh to check"

# Export for skill
export PROPOSAL_WORK_ITEM="$WORK_ITEM"
export PROPOSAL_WORK_ITEM_PATH="$WORK_ITEM_PATH"
export PROPOSAL_OUTPUT_PATH="$PROPOSAL_OUTPUT"
export PROPOSAL_ITERATION="$ITERATION"
export PROPOSAL_PROMPT="$PROPOSAL_PROMPT"
