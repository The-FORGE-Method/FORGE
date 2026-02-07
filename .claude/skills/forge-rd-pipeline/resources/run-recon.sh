#!/bin/bash
# run-recon.sh
# FORGE R&D Pipeline - Recon Phase Runner
#
# Usage: ./run-recon.sh <work-item-path>
#
# Invokes forge-recon-runner sub-agent to analyze work-item material

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
log_phase() { echo -e "${BLUE}[RECON]${NC} $1"; }

WORK_ITEM_PATH="${1:-}"

if [[ -z "$WORK_ITEM_PATH" ]] || [[ ! -d "$WORK_ITEM_PATH" ]]; then
    log_error "Usage: $0 <work-item-path>"
    exit 1
fi

WORK_ITEM=$(basename "$WORK_ITEM_PATH")
STATE_FILE="$WORK_ITEM_PATH/state.json"
AUDIT_LOG="$WORK_ITEM_PATH/audit-log.md"
RECON_OUTPUT="$WORK_ITEM_PATH/artifacts/recon-report.md"

log_phase "Starting RECON phase for: $WORK_ITEM"

# Update state to RECON
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

# Append to audit log
log_audit() {
    local event="$1"
    local details="$2"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    local phase=$(python3 -c "import json; print(json.load(open('$STATE_FILE'))['phase'])")

    # Append to events table
    sed -i '' "/^| Timestamp | Phase | Event | Details |/a\\
| $timestamp | $phase | $event | $details |" "$AUDIT_LOG" 2>/dev/null || \
    echo "| $timestamp | $phase | $event | $details |" >> "$AUDIT_LOG"
}

update_state "RECON" "running" "Running recon analysis..."

# Verify source material exists
THREADS_DIR="$WORK_ITEM_PATH/threads"
ASSETS_DIR="$WORK_ITEM_PATH/assets"

if [[ ! -d "$THREADS_DIR" ]] && [[ ! -d "$ASSETS_DIR" ]]; then
    log_error "No source material found in work-item"
    update_state "RECON" "failed" "ERROR: No source material found"
    log_audit "recon_failed" "No source material in threads/ or assets/"
    exit 1
fi

FILE_COUNT=0
[[ -d "$THREADS_DIR" ]] && FILE_COUNT=$((FILE_COUNT + $(find "$THREADS_DIR" -type f | wc -l | tr -d ' ')))
[[ -d "$ASSETS_DIR" ]] && FILE_COUNT=$((FILE_COUNT + $(find "$ASSETS_DIR" -type f | wc -l | tr -d ' ')))

if [[ $FILE_COUNT -eq 0 ]]; then
    log_error "Source directories are empty"
    update_state "RECON" "failed" "ERROR: No files in source directories"
    log_audit "recon_failed" "Empty source directories"
    exit 1
fi

log_info "Found $FILE_COUNT source files to analyze"

# Generate the recon prompt for the sub-agent
RECON_PROMPT="Analyze the work-item at:
$WORK_ITEM_PATH

Produce a recon report following the forge-recon-runner specification.

Cross-reference against FORGE canon at:
- $FORGE_ROOT/method/
- $FORGE_ROOT/template/project/

Output to: $RECON_OUTPUT

Source material locations:
- Threads: $THREADS_DIR
- Assets: $ASSETS_DIR

Today's date: $(date +%Y-%m-%d)

Follow the forge-recon-runner operating sequence exactly:
1. Inventory source material
2. Extract key points
3. Cross-reference FORGE canon
4. Identify gaps
5. Map dependencies
6. Surface risks
7. Formulate open questions (if any)

Set Readiness to READY if no clarifying questions needed.
Set Readiness to NEEDS_CLARIFICATION if questions exist."

log_info "Invoking forge-recon-runner sub-agent..."

# Output the prompt for Claude to execute
# The skill will invoke the Task tool with this prompt
echo "---RECON_PROMPT_START---"
echo "$RECON_PROMPT"
echo "---RECON_PROMPT_END---"

# The actual sub-agent invocation happens through Claude's Task tool
# This script prepares the context and validates the output

log_phase "Recon prompt generated. Awaiting sub-agent execution."
log_info "Output expected at: $RECON_OUTPUT"

# Export for the skill to use
export RECON_WORK_ITEM="$WORK_ITEM"
export RECON_WORK_ITEM_PATH="$WORK_ITEM_PATH"
export RECON_OUTPUT_PATH="$RECON_OUTPUT"
export RECON_PROMPT="$RECON_PROMPT"
