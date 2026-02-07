#!/bin/bash
# run-synthesis.sh
# FORGE R&D Pipeline - Synthesis Phase Runner
#
# Usage: ./run-synthesis.sh <work-item-path>
#
# Invokes spec-writer in FORGE mode to produce synthesis document

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
log_phase() { echo -e "${BLUE}[SYNTHESIS]${NC} $1"; }

WORK_ITEM_PATH="${1:-}"

if [[ -z "$WORK_ITEM_PATH" ]] || [[ ! -d "$WORK_ITEM_PATH" ]]; then
    log_error "Usage: $0 <work-item-path>"
    exit 1
fi

WORK_ITEM=$(basename "$WORK_ITEM_PATH")
STATE_FILE="$WORK_ITEM_PATH/state.json"
AUDIT_LOG="$WORK_ITEM_PATH/audit-log.md"
RECON_REPORT="$WORK_ITEM_PATH/artifacts/recon-report.md"
QUESTIONS_FILE="$WORK_ITEM_PATH/artifacts/questions.md"
SYNTHESIS_OUTPUT="$WORK_ITEM_PATH/artifacts/synthesis.md"

log_phase "Starting SYNTHESIS phase for: $WORK_ITEM"

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

# Verify recon report exists
if [[ ! -f "$RECON_REPORT" ]]; then
    log_error "Recon report not found: $RECON_REPORT"
    log_error "Run recon phase first."
    exit 1
fi

update_state "SYNTHESIS" "running" "Generating synthesis document..."

# Check if questions were answered (if any existed)
if [[ -f "$QUESTIONS_FILE" ]]; then
    # Check for unanswered questions
    UNANSWERED=$(grep -c "| *| *|$" "$QUESTIONS_FILE" 2>/dev/null || echo "0")
    if [[ "$UNANSWERED" -gt 0 ]]; then
        log_warn "There are $UNANSWERED unanswered questions."
        log_warn "Consider answering them before synthesis."
    fi
fi

# Gather context for synthesis
THREADS_DIR="$WORK_ITEM_PATH/threads"
ASSETS_DIR="$WORK_ITEM_PATH/assets"

# Build the synthesis prompt
SYNTHESIS_PROMPT="You are spec-writer operating in FORGE mode.

Transform the recon findings into a structured synthesis document.

## Input Context

**Work-Item:** $WORK_ITEM_PATH
**Date:** $(date +%Y-%m-%d)

### Recon Report
Read the recon report at: $RECON_REPORT

### Source Material
- Threads directory: $THREADS_DIR
- Assets directory: $ASSETS_DIR

### Answered Questions (if any)
$(if [[ -f "$QUESTIONS_FILE" ]]; then cat "$QUESTIONS_FILE"; else echo "No clarifying questions file."; fi)

## Your Task

Produce a synthesis document at: $SYNTHESIS_OUTPUT

The synthesis must include:
1. Executive Summary (2-3 sentences)
2. Problem Statement (what, why, cost of inaction)
3. Proposed Solution (overview + key components)
4. Requirements Matrix (functional + non-functional)
5. Scope Definition (in/out/deferred)
6. Affected Systems (repos, dependencies)
7. Constraints & Assumptions
8. Success Criteria (binary, verifiable)
9. Open Items Resolved (from recon questions)
10. Synthesis Assessment (completeness, ready for proposal)

## Constraints

- Use information from recon report and source material ONLY
- Do NOT invent requirements not supported by source material
- Flag any remaining ambiguities for the proposal phase
- Ensure all success criteria are binary (pass/fail)
- Cross-reference FORGE canon at $FORGE_ROOT/method/

## Output

Write the complete synthesis document to:
$SYNTHESIS_OUTPUT"

log_info "Invoking spec-writer (FORGE mode)..."

echo "---SYNTHESIS_PROMPT_START---"
echo "$SYNTHESIS_PROMPT"
echo "---SYNTHESIS_PROMPT_END---"

log_phase "Synthesis prompt generated. Awaiting spec-writer execution."
log_info "Output expected at: $SYNTHESIS_OUTPUT"

# Export for skill
export SYNTHESIS_WORK_ITEM="$WORK_ITEM"
export SYNTHESIS_WORK_ITEM_PATH="$WORK_ITEM_PATH"
export SYNTHESIS_OUTPUT_PATH="$SYNTHESIS_OUTPUT"
export SYNTHESIS_PROMPT="$SYNTHESIS_PROMPT"
