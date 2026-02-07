#!/bin/bash
# process-inbox.sh
# FORGE R&D Pipeline - Intake Processing
#
# Usage: ./process-inbox.sh <slug> [--canon]
#
# Creates work-item structure and moves inbox material

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
FORGE_ROOT="${FORGE_ROOT:-$(cd "$(dirname "$0")/../../../.." && pwd)}"
WORKSPACE="$FORGE_ROOT/_workspace"
INBOX="$WORKSPACE/00_inbox"
PROPOSALS="$WORKSPACE/04_proposals/work-items"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse arguments
SLUG=""
CANON_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --canon)
            CANON_MODE=true
            shift
            ;;
        *)
            SLUG="$1"
            shift
            ;;
    esac
done

if [[ -z "$SLUG" ]]; then
    log_error "Usage: $0 <slug> [--canon]"
    exit 1
fi

# Validate slug format
if ! [[ "$SLUG" =~ ^[a-z0-9-]+$ ]]; then
    log_error "Invalid slug format. Use lowercase letters, numbers, and hyphens only."
    exit 1
fi

# Get current date
DATE=$(date +%Y-%m-%d)
WORK_ITEM="${DATE}-${SLUG}"
WORK_ITEM_PATH="$PROPOSALS/$WORK_ITEM"

log_info "Processing inbox for: $WORK_ITEM"
log_info "Canon mode: $CANON_MODE"

# Look for submission folder in inbox
INBOX_FOLDER="$INBOX/$SLUG"

if [[ ! -d "$INBOX_FOLDER" ]]; then
    log_error "Submission folder not found: $INBOX_FOLDER"
    log_error ""
    log_error "Expected folder structure:"
    log_error "  00_inbox/$SLUG/"
    log_error "    ├── README.md       (required)"
    log_error "    ├── threads/        (optional)"
    log_error "    └── assets/         (optional)"
    log_error ""
    log_error "Available folders in inbox:"
    ls -1 "$INBOX" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
    exit 1
fi

# Validate required README.md in submission folder
if [[ ! -f "$INBOX_FOLDER/README.md" ]]; then
    log_error "Submission folder missing required README.md: $INBOX_FOLDER/README.md"
    log_error ""
    log_error "Every submission must include a README.md with:"
    log_error "  - Summary of the feature request"
    log_error "  - Problem statement"
    log_error "  - List of included materials"
    exit 1
fi

# Check for existing work-item
if [[ -d "$WORK_ITEM_PATH" ]]; then
    log_error "Work-item already exists: $WORK_ITEM_PATH"
    exit 1
fi

# Create work-item structure
log_info "Creating work-item structure..."
mkdir -p "$WORK_ITEM_PATH"/artifacts

# Move the entire submission folder contents
log_info "Moving submission folder contents..."

# Check if submission has structured subdirectories
HAS_THREADS_DIR=false
HAS_ASSETS_DIR=false
[[ -d "$INBOX_FOLDER/threads" ]] && HAS_THREADS_DIR=true
[[ -d "$INBOX_FOLDER/assets" ]] && HAS_ASSETS_DIR=true

if [[ "$HAS_THREADS_DIR" == "true" ]] || [[ "$HAS_ASSETS_DIR" == "true" ]]; then
    # Structured submission: preserve existing layout
    log_info "Detected structured submission (has threads/ and/or assets/)"

    # Move threads/ if exists
    if [[ "$HAS_THREADS_DIR" == "true" ]]; then
        mv "$INBOX_FOLDER/threads" "$WORK_ITEM_PATH/"
        log_info "  → threads/ (preserved)"
    else
        mkdir -p "$WORK_ITEM_PATH/threads"
    fi

    # Move assets/ if exists
    if [[ "$HAS_ASSETS_DIR" == "true" ]]; then
        mv "$INBOX_FOLDER/assets" "$WORK_ITEM_PATH/"
        log_info "  → assets/ (preserved)"
    else
        mkdir -p "$WORK_ITEM_PATH/assets"
    fi

    # Move README.md to work-item root (becomes source README)
    if [[ -f "$INBOX_FOLDER/README.md" ]]; then
        mv "$INBOX_FOLDER/README.md" "$WORK_ITEM_PATH/threads/submission-readme.md"
        log_info "  → threads/submission-readme.md"
    fi

    # Move any remaining files at root level
    for item in "$INBOX_FOLDER"/*; do
        if [[ -e "$item" ]]; then
            filename=$(basename "$item")
            if [[ -f "$item" ]]; then
                ext="${filename##*.}"
                case "$ext" in
                    png|jpg|jpeg|gif|svg|pdf|mp4|mov|webm)
                        mv "$item" "$WORK_ITEM_PATH/assets/"
                        log_info "  → assets/$filename"
                        ;;
                    *)
                        mv "$item" "$WORK_ITEM_PATH/threads/"
                        log_info "  → threads/$filename"
                        ;;
                esac
            elif [[ -d "$item" ]]; then
                mv "$item" "$WORK_ITEM_PATH/threads/"
                log_info "  → threads/$filename/"
            fi
        fi
    done
else
    # Flat submission: categorize by file type
    log_info "Detected flat submission (no threads/assets structure)"
    mkdir -p "$WORK_ITEM_PATH"/{threads,assets}

    for item in "$INBOX_FOLDER"/*; do
        if [[ -e "$item" ]]; then
            filename=$(basename "$item")

            if [[ -f "$item" ]]; then
                ext="${filename##*.}"
                case "$ext" in
                    png|jpg|jpeg|gif|svg|pdf|mp4|mov|webm)
                        mv "$item" "$WORK_ITEM_PATH/assets/"
                        log_info "  → assets/$filename"
                        ;;
                    *)
                        mv "$item" "$WORK_ITEM_PATH/threads/"
                        log_info "  → threads/$filename"
                        ;;
                esac
            elif [[ -d "$item" ]]; then
                mv "$item" "$WORK_ITEM_PATH/threads/"
                log_info "  → threads/$filename/"
            fi
        fi
    done
fi

# Remove the now-empty inbox folder
rmdir "$INBOX_FOLDER" 2>/dev/null || log_warn "Inbox folder not empty after move (check for hidden files)"

# Generate manifest.json
log_info "Generating manifest..."
MANIFEST="$WORK_ITEM_PATH/artifacts/manifest.json"
echo "{" > "$MANIFEST"
echo '  "work_item": "'"$WORK_ITEM"'",' >> "$MANIFEST"
echo '  "created_at": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'",' >> "$MANIFEST"
echo '  "canon_mode": '"$CANON_MODE"',' >> "$MANIFEST"
echo '  "files": [' >> "$MANIFEST"

first=true
for dir in threads assets; do
    if [[ -d "$WORK_ITEM_PATH/$dir" ]]; then
        for file in "$WORK_ITEM_PATH/$dir"/*; do
            if [[ -f "$file" ]]; then
                filename=$(basename "$file")
                size=$(stat -f%z "$file" 2>/dev/null || stat --printf="%s" "$file" 2>/dev/null)
                hash=$(shasum -a 256 "$file" | cut -d' ' -f1)

                if [[ "$first" == "true" ]]; then
                    first=false
                else
                    echo "," >> "$MANIFEST"
                fi

                printf '    {"path": "%s/%s", "size": %s, "sha256": "%s"}' "$dir" "$filename" "$size" "$hash" >> "$MANIFEST"
            fi
        done
    fi
done

echo "" >> "$MANIFEST"
echo "  ]" >> "$MANIFEST"
echo "}" >> "$MANIFEST"

# Initialize state.json
log_info "Initializing state..."
STATE_FILE="$WORK_ITEM_PATH/state.json"
cat > "$STATE_FILE" << EOF
{
  "version": 1,
  "work_item": "$WORK_ITEM",
  "phase": "INTAKE",
  "status": "running",
  "status_display": "Processing intake sanity checks",
  "canon_mode": $CANON_MODE,
  "canon_confirmed": false,
  "proposal_sha256": null,
  "blast_radius": null,
  "questions": null,
  "ralph_iterations": 0,
  "quality_gate_passed": false,
  "verification_passed": false,
  "work_item_path": "$WORK_ITEM_PATH",
  "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "updated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "error": null
}
EOF

# Initialize audit log
log_info "Initializing audit log..."
AUDIT_LOG="$WORK_ITEM_PATH/audit-log.md"
cat > "$AUDIT_LOG" << EOF
# Audit Log: $WORK_ITEM

**Work-Item:** $WORK_ITEM_PATH
**Created:** $(date -u +%Y-%m-%dT%H:%M:%SZ)
**Canon Mode:** $CANON_MODE

---

## Events

| Timestamp | Phase | Event | Details |
|-----------|-------|-------|---------|
| $(date -u +%Y-%m-%dT%H:%M:%SZ) | INTAKE | pipeline_started | slug: $SLUG, canon: $CANON_MODE |

---

## Approvals

| Timestamp | Type | Approved By | Hash |
|-----------|------|-------------|------|

---

## Rejections

| Timestamp | Rejected By | Feedback |
|-----------|-------------|----------|

---

## Questions & Answers

| Timestamp | Question ID | Answer | Answered By |
|-----------|-------------|--------|-------------|

---

*Append-only log — Do not edit previous entries*
EOF

# Create work-item README
log_info "Creating README..."
README="$WORK_ITEM_PATH/README.md"
cat > "$README" << EOF
# Work-Item: $SLUG

**Created:** $DATE
**Status:** INTAKE
**Canon Mode:** $CANON_MODE

---

## Overview

Work-item created from inbox material. Pending recon analysis.

---

## Source Material

See \`threads/\` and \`assets/\` subdirectories for raw input material.

**Inventory:** See \`artifacts/inventory.md\` (after intake complete)

---

## Pipeline State

**Current Phase:** INTAKE
**Next Action:** Run recon analysis

See \`state.json\` for machine-readable state.
See \`audit-log.md\` for event history.

---

*Generated by forge-rd-pipeline*
EOF

log_info "Work-item created: $WORK_ITEM_PATH"
log_info "Next step: Run recon with forge-recon-runner"

# Output path for pipeline
echo "$WORK_ITEM_PATH"
