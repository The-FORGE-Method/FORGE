#!/bin/bash
# archive-workitem.sh
# FORGE R&D Pipeline - Archive and Cleanup
#
# Usage: ./archive-workitem.sh <work-item-path> [--status STATUS]
#
# Archives completed work-item and resets pipeline state
#
# Options:
#   --status STATUS   Archive status (HANDED_OFF, CANCELLED). Bypasses verification check.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
FORGE_ROOT="${FORGE_ROOT:-$(cd "$(dirname "$0")/../../../.." && pwd)}"
WORKSPACE="$FORGE_ROOT/_workspace"
ARCHIVE="$WORKSPACE/99_archive"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse arguments
WORK_ITEM_PATH=""
STATUS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --status)
            STATUS="$2"
            shift 2
            ;;
        *)
            if [[ -z "$WORK_ITEM_PATH" ]]; then
                WORK_ITEM_PATH="$1"
            fi
            shift
            ;;
    esac
done

if [[ -z "$WORK_ITEM_PATH" ]] || [[ ! -d "$WORK_ITEM_PATH" ]]; then
    log_error "Usage: $0 <work-item-path> [--status STATUS]"
    exit 1
fi

WORK_ITEM=$(basename "$WORK_ITEM_PATH")
STATE_FILE="$WORK_ITEM_PATH/state.json"

# Verify state allows archival (skip for HANDED_OFF or CANCELLED)
if [[ "$STATUS" != "HANDED_OFF" ]] && [[ "$STATUS" != "CANCELLED" ]]; then
    if [[ -f "$STATE_FILE" ]]; then
        VERIFICATION_PASSED=$(grep -o '"verification_passed": *[^,}]*' "$STATE_FILE" | cut -d: -f2 | tr -d ' ')

        if [[ "$VERIFICATION_PASSED" != "true" ]]; then
            log_error "Cannot archive: verification has not passed."
            log_error "Run verification first and ensure all checks pass."
            exit 1
        fi
    fi
fi

log_info "Archiving work-item: $WORK_ITEM"

# Create archive directory if needed
mkdir -p "$ARCHIVE"

# Add completion timestamp to audit log
AUDIT_LOG="$WORK_ITEM_PATH/audit-log.md"
if [[ -f "$AUDIT_LOG" ]]; then
    TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    # Insert before the last separator
    sed -i '' "/^## Events/a\\
| $TIMESTAMP | ARCHIVE | pipeline_completed | Work-item archived |" "$AUDIT_LOG" 2>/dev/null || \
    echo "| $TIMESTAMP | ARCHIVE | pipeline_completed | Work-item archived |" >> "$AUDIT_LOG"
fi

# Update final state
if [[ -f "$STATE_FILE" ]]; then
    # Update state to archived
    TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    # Use Python for reliable JSON manipulation
    python3 << EOF
import json

with open('$STATE_FILE', 'r') as f:
    state = json.load(f)

state['phase'] = 'ARCHIVE'
state['status'] = 'complete'
state['status_display'] = 'Pipeline complete. Work-item archived.'
state['updated_at'] = '$TIMESTAMP'

with open('$STATE_FILE', 'w') as f:
    json.dump(state, f, indent=2)
EOF
fi

# Move to archive
if [[ -n "$STATUS" ]]; then
    ARCHIVE_PATH="$ARCHIVE/${WORK_ITEM}--${STATUS}"
else
    ARCHIVE_PATH="$ARCHIVE/$WORK_ITEM"
fi

if [[ -d "$ARCHIVE_PATH" ]]; then
    # Add timestamp suffix if already exists
    ARCHIVE_PATH="${ARCHIVE_PATH}-$(date +%H%M%S)"
fi

mv "$WORK_ITEM_PATH" "$ARCHIVE_PATH"
log_info "Moved to: $ARCHIVE_PATH"

# --- Git Commit Section ---
log_info "Committing workspace changes..."

cd "$FORGE_ROOT"
COMMIT_SHA="none"

# Check if there are changes to commit in _workspace/
if git diff --quiet HEAD -- _workspace/ 2>/dev/null && \
   git diff --cached --quiet -- _workspace/ 2>/dev/null && \
   [[ -z "$(git ls-files --others --exclude-standard _workspace/)" ]]; then
    log_info "No workspace changes to commit."
else
    # Stage workspace changes only
    git add _workspace/

    # Create commit message
    COMMIT_MSG="Archive work-item: $WORK_ITEM

- Move $WORK_ITEM to 99_archive/
- Clean up inbox
- Update workspace state

Work-Item: $WORK_ITEM"

    # Commit
    if git commit -m "$COMMIT_MSG" 2>/dev/null; then
        COMMIT_SHA=$(git rev-parse --short HEAD)
        log_info "Committed: $COMMIT_SHA"

        # Log to audit (archive path now exists)
        echo "| $(date -u +%Y-%m-%dT%H:%M:%SZ) | ARCHIVE | git_commit | sha: $COMMIT_SHA |" >> "$ARCHIVE_PATH/audit-log.md"

        # Update state.json with commit SHA
        if [[ -f "$ARCHIVE_PATH/state.json" ]]; then
            python3 << PYEOF
import json
state_file = '$ARCHIVE_PATH/state.json'
with open(state_file, 'r') as f:
    state = json.load(f)
state['commit_sha'] = '$COMMIT_SHA'
with open(state_file, 'w') as f:
    json.dump(state, f, indent=2)
PYEOF
        fi
    else
        log_warn "Git commit failed. Continuing without commit."
        COMMIT_SHA="failed"
        echo "| $(date -u +%Y-%m-%dT%H:%M:%SZ) | ARCHIVE | git_commit | FAILED |" >> "$ARCHIVE_PATH/audit-log.md"
    fi
fi

# Optional push (controlled by FORGE_RD_AUTO_PUSH environment variable)
if [[ "${FORGE_RD_AUTO_PUSH:-}" == "1" ]] || [[ "${FORGE_RD_AUTO_PUSH:-}" == "true" ]]; then
    log_info "Auto-push enabled. Pushing to remote..."
    if git push 2>/dev/null; then
        log_info "Pushed to remote."
        echo "| $(date -u +%Y-%m-%dT%H:%M:%SZ) | ARCHIVE | git_push | pushed to origin |" >> "$ARCHIVE_PATH/audit-log.md"
    else
        log_warn "Git push failed. Manual push required."
        echo "| $(date -u +%Y-%m-%dT%H:%M:%SZ) | ARCHIVE | git_push | FAILED |" >> "$ARCHIVE_PATH/audit-log.md"
    fi
else
    log_info "Auto-push disabled. Run 'git push' manually if needed."
    echo "| $(date -u +%Y-%m-%dT%H:%M:%SZ) | ARCHIVE | git_push | SKIPPED (not enabled) |" >> "$ARCHIVE_PATH/audit-log.md"
fi

# Reset global pipeline state
GLOBAL_STATE="$SKILL_DIR/references/pipeline-state.json"
if [[ -f "$GLOBAL_STATE" ]]; then
    log_info "Resetting global pipeline state..."

    python3 << EOF
import json

state = {
    "version": 1,
    "work_item": None,
    "phase": "IDLE",
    "status": "idle",
    "status_display": "No active pipeline",
    "canon_mode": False,
    "canon_confirmed": False,
    "proposal_sha256": None,
    "blast_radius": None,
    "questions": None,
    "ralph_iterations": 0,
    "quality_gate_passed": False,
    "verification_passed": False,
    "work_item_path": None,
    "started_at": None,
    "updated_at": None,
    "error": None
}

with open('$GLOBAL_STATE', 'w') as f:
    json.dump(state, f, indent=2)
EOF
fi

log_info "Archive complete."
log_info ""
log_info "Feature complete: $WORK_ITEM"
log_info "Archived to: $ARCHIVE_PATH"

echo "$ARCHIVE_PATH"
