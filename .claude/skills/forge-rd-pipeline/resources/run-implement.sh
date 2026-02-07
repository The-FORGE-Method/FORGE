#!/bin/bash
# run-implement.sh
# FORGE R&D Pipeline - Implementation Phase Runner
#
# Usage: ./run-implement.sh <work-item-path>
#
# Invokes forge-maintainer to execute approved proposal

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
FORGE_ROOT="${FORGE_ROOT:-$(cd "$(dirname "$0")/../../../.." && pwd)}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_phase() { echo -e "${BLUE}[IMPLEMENT]${NC} $1"; }

WORK_ITEM_PATH="${1:-}"

if [[ -z "$WORK_ITEM_PATH" ]] || [[ ! -d "$WORK_ITEM_PATH" ]]; then
    log_error "Usage: $0 <work-item-path>"
    exit 1
fi

WORK_ITEM=$(basename "$WORK_ITEM_PATH")
STATE_FILE="$WORK_ITEM_PATH/state.json"
AUDIT_LOG="$WORK_ITEM_PATH/audit-log.md"
PROPOSAL_FILE="$WORK_ITEM_PATH/artifacts/proposal.md"
IMPLEMENTATION_OUTPUT="$WORK_ITEM_PATH/artifacts/implementation.md"

log_phase "Starting IMPLEMENT phase for: $WORK_ITEM"

# Update state
update_state() {
    local phase="$1"
    local status="$2"
    local display="$3"

    python3 << EOF
import json
from datetime import datetime

with open('$STATE_FILE', 'r') as f:
    state = json.load(f)

state['phase'] = '$phase'
state['status'] = '$status'
state['status_display'] = '$display'
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
| $timestamp | IMPLEMENT | $event | $details |" "$AUDIT_LOG" 2>/dev/null || true
}

# Verify proposal exists and is approved
if [[ ! -f "$PROPOSAL_FILE" ]]; then
    log_error "Proposal not found: $PROPOSAL_FILE"
    exit 1
fi

update_state "IMPLEMENT" "running" "Implementation in progress..."
log_audit "implementation_started" "Beginning implementation per approved proposal"

# Get proposal hash for implementation report
PROPOSAL_HASH=$(shasum -a 256 "$PROPOSAL_FILE" | cut -d' ' -f1)

# Get canon mode
CANON_MODE=$(python3 -c "import json; print(json.load(open('$STATE_FILE')).get('canon_mode', False))")

# Build the implementation prompt
IMPLEMENT_PROMPT="You are forge-maintainer executing an approved FORGE R&D proposal.

## Context

**Work-Item:** $WORK_ITEM_PATH
**Date:** $(date +%Y-%m-%d)
**Proposal Hash:** $PROPOSAL_HASH
**Canon Mode:** $CANON_MODE

### Approved Proposal
Read the proposal at: $PROPOSAL_FILE

## Your Task

Execute the implementation plan from the approved proposal.

### Constraints

1. **Follow the proposal exactly** — Do not deviate without escalation
2. **Create local commits only** — Never push to remote
3. **Never delete files** outside of \`_workspace/99_archive/\`
4. **Stop on ambiguity** — If something is unclear, document and stop
5. **Document everything** — Every change must be tracked

### Implementation Steps

1. Read the Implementation Plan section of the proposal
2. For each file change listed:
   - Create/modify the file as specified
   - Create a local commit with descriptive message
3. Track all changes in the implementation report
4. Note any deviations or issues encountered

### Output Requirements

Create an implementation report at: $IMPLEMENTATION_OUTPUT

The report must include:
- Summary of what was implemented
- Files created (with purposes)
- Files modified (with change descriptions)
- Files deleted (with reasons) — only if explicitly in proposal
- Commit history
- Any deviations from proposal (with reasons)
- Issues encountered
- Verification readiness status

### FORGE Canon Rules

$(if [[ "$CANON_MODE" == "True" ]]; then
echo "This is a CANON change. Pay special attention to:
- method/core/ changes require exact adherence to proposal
- Update CHANGELOG.md with the change
- Ensure all cross-references remain valid"
else
echo "Standard change. No special canon rules apply."
fi)

## Handoff

After implementation, the pipeline will run verification (Sacred Four + doc checks).

Do NOT:
- Push any commits
- Make changes outside the proposal scope
- Delete files outside _workspace/99_archive/
- Skip documenting changes

Output implementation report to:
$IMPLEMENTATION_OUTPUT"

log_info "Invoking forge-maintainer..."

echo "---IMPLEMENT_PROMPT_START---"
echo "$IMPLEMENT_PROMPT"
echo "---IMPLEMENT_PROMPT_END---"

log_phase "Implementation prompt generated. Awaiting forge-maintainer execution."
log_info "Output expected at: $IMPLEMENTATION_OUTPUT"

# Export for skill
export IMPLEMENT_WORK_ITEM="$WORK_ITEM"
export IMPLEMENT_WORK_ITEM_PATH="$WORK_ITEM_PATH"
export IMPLEMENT_OUTPUT_PATH="$IMPLEMENTATION_OUTPUT"
export IMPLEMENT_PROMPT="$IMPLEMENT_PROMPT"
