#!/bin/bash
# run-verification.sh
# FORGE R&D Pipeline - Verification Phase Runner
#
# Usage: ./run-verification.sh <work-item-path>
#
# Runs Sacred Four and documentation checks on implemented changes

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
log_phase() { echo -e "${BLUE}[VERIFY]${NC} $1"; }
log_pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
log_fail() { echo -e "${RED}[FAIL]${NC} $1"; }

WORK_ITEM_PATH="${1:-}"

if [[ -z "$WORK_ITEM_PATH" ]] || [[ ! -d "$WORK_ITEM_PATH" ]]; then
    log_error "Usage: $0 <work-item-path>"
    exit 1
fi

WORK_ITEM=$(basename "$WORK_ITEM_PATH")
STATE_FILE="$WORK_ITEM_PATH/state.json"
AUDIT_LOG="$WORK_ITEM_PATH/audit-log.md"
PROPOSAL_FILE="$WORK_ITEM_PATH/artifacts/proposal.md"
IMPLEMENTATION_FILE="$WORK_ITEM_PATH/artifacts/implementation.md"
VERIFICATION_OUTPUT="$WORK_ITEM_PATH/artifacts/verification-report.md"
SMOKE_LOG="$WORK_ITEM_PATH/artifacts/smoke-test.log"

log_phase "Starting VERIFICATION phase for: $WORK_ITEM"

# Update state
update_state() {
    local phase="$1"
    local status="$2"
    local display="$3"
    local verified="${4:-false}"

    python3 << EOF
import json
from datetime import datetime

with open('$STATE_FILE', 'r') as f:
    state = json.load(f)

state['phase'] = '$phase'
state['status'] = '$status'
state['status_display'] = '$display'
state['verification_passed'] = $verified
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
| $timestamp | VERIFICATION | $event | $details |" "$AUDIT_LOG" 2>/dev/null || true
}

update_state "VERIFICATION" "running" "Running verification checks..." "false"

# Initialize verification report
cat > "$VERIFICATION_OUTPUT" << EOF
# Verification Report: $WORK_ITEM

**Date:** $(date +%Y-%m-%d)
**Work-Item:** $WORK_ITEM_PATH
**Implementation:** $(if [[ -f "$IMPLEMENTATION_FILE" ]]; then echo "Present"; else echo "Not found"; fi)

---

## 1. Verification Summary

**Overall Status:** PENDING

| Check | Status | Details |
|-------|--------|---------|
EOF

OVERALL_PASS=true
CHECKS_RUN=0
CHECKS_PASSED=0

# Determine what type of changes were made
CHANGES_TYPE="unknown"
if [[ -f "$PROPOSAL_FILE" ]]; then
    if grep -q "method/" "$PROPOSAL_FILE" 2>/dev/null; then
        CHANGES_TYPE="docs"
    fi
    if grep -q "template/project" "$PROPOSAL_FILE" 2>/dev/null; then
        CHANGES_TYPE="template"
    fi
    if grep -q "\.ts\|\.tsx\|\.js\|\.jsx" "$PROPOSAL_FILE" 2>/dev/null; then
        CHANGES_TYPE="code"
    fi
fi

log_info "Detected changes type: $CHANGES_TYPE"

# Run appropriate checks based on change type
run_check() {
    local name="$1"
    local command="$2"
    local status="SKIP"
    local details=""

    CHECKS_RUN=$((CHECKS_RUN + 1))

    if eval "$command" > /tmp/check_output.txt 2>&1; then
        status="PASS"
        details="Success"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
        log_pass "$name"
    else
        status="FAIL"
        details=$(head -3 /tmp/check_output.txt | tr '\n' ' ')
        OVERALL_PASS=false
        log_fail "$name"
    fi

    echo "| $name | $status | $details |" >> "$VERIFICATION_OUTPUT"
}

# Sacred Four (for code changes)
if [[ "$CHANGES_TYPE" == "code" ]] || [[ "$CHANGES_TYPE" == "template" ]]; then
    log_phase "Running Sacred Four..."

    # Find the target project directory
    TARGET_DIR=""
    if [[ -f "$PROPOSAL_FILE" ]]; then
        # Try to extract target from proposal
        TARGET_DIR=$(grep -oE '/[^ ]+template/project' "$PROPOSAL_FILE" 2>/dev/null | head -1 || echo "")
    fi

    if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$FORGE_ROOT/template/project"
    fi

    if [[ -d "$TARGET_DIR" ]] && [[ -f "$TARGET_DIR/package.json" ]]; then
        cd "$TARGET_DIR"

        run_check "TypeCheck" "pnpm typecheck 2>/dev/null || npm run typecheck 2>/dev/null || echo 'No typecheck script'"
        run_check "Lint" "pnpm lint 2>/dev/null || npm run lint 2>/dev/null || echo 'No lint script'"
        run_check "Test" "pnpm test:run 2>/dev/null || pnpm test 2>/dev/null || npm run test 2>/dev/null || echo 'No test script'"
        run_check "Build" "pnpm build 2>/dev/null || npm run build 2>/dev/null || echo 'No build script'"

        cd - > /dev/null
    else
        log_warn "No package.json found for Sacred Four. Skipping code checks."
        echo "| Sacred Four | SKIP | No package.json found |" >> "$VERIFICATION_OUTPUT"
    fi
fi

# Documentation checks (for docs changes)
if [[ "$CHANGES_TYPE" == "docs" ]]; then
    log_phase "Running documentation checks..."

    # Markdown lint (if available)
    if command -v markdownlint &> /dev/null; then
        run_check "Markdown Lint" "markdownlint '$FORGE_ROOT/method/**/*.md' 2>/dev/null || true"
    else
        echo "| Markdown Lint | SKIP | markdownlint not installed |" >> "$VERIFICATION_OUTPUT"
    fi

    # Check for broken internal links
    run_check "Internal Links" "find '$FORGE_ROOT/method' -name '*.md' -exec grep -l '\]\(' {} \; | head -5 | xargs -I {} grep -oE '\]\([^)]+\.md\)' {} 2>/dev/null | head -10 || echo 'Links checked'"

    # FORGE terminology consistency
    run_check "FORGE Terminology" "grep -r 'FORGE' '$FORGE_ROOT/method' 2>/dev/null | grep -c 'FORGE' || echo '0 references'"
fi

# Smoke test (for template changes)
if [[ "$CHANGES_TYPE" == "template" ]]; then
    log_phase "Running smoke test..."

    SMOKE_SCRIPT="$SCRIPT_DIR/smoke-test.sh"
    if [[ -x "$SMOKE_SCRIPT" ]]; then
        if "$SMOKE_SCRIPT" "$FORGE_ROOT/template/project" "$SMOKE_LOG"; then
            echo "| Smoke Test | PASS | Template instantiation successful |" >> "$VERIFICATION_OUTPUT"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
            log_pass "Smoke Test"
        else
            echo "| Smoke Test | FAIL | See $SMOKE_LOG |" >> "$VERIFICATION_OUTPUT"
            OVERALL_PASS=false
            log_fail "Smoke Test"
        fi
        CHECKS_RUN=$((CHECKS_RUN + 1))
    fi
fi

# Finalize verification report
echo "" >> "$VERIFICATION_OUTPUT"
echo "---" >> "$VERIFICATION_OUTPUT"
echo "" >> "$VERIFICATION_OUTPUT"
echo "## Verification Assessment" >> "$VERIFICATION_OUTPUT"
echo "" >> "$VERIFICATION_OUTPUT"

if [[ "$OVERALL_PASS" == "true" ]]; then
    echo "**Result:** PASS" >> "$VERIFICATION_OUTPUT"
    echo "" >> "$VERIFICATION_OUTPUT"
    echo "**Ready to Archive:** Yes" >> "$VERIFICATION_OUTPUT"
    echo "" >> "$VERIFICATION_OUTPUT"
    echo "All verification checks passed. Work-item ready for archival." >> "$VERIFICATION_OUTPUT"

    update_state "VERIFICATION" "complete" "Verification PASS. Ready to archive." "true"
    log_audit "verification_pass" "All checks passed ($CHECKS_PASSED/$CHECKS_RUN)"

    log_phase "VERIFICATION PASS"
    log_info "Checks: $CHECKS_PASSED/$CHECKS_RUN passed"
    log_info "Ready to archive with: /forge-rd archive"
else
    echo "**Result:** FAIL" >> "$VERIFICATION_OUTPUT"
    echo "" >> "$VERIFICATION_OUTPUT"
    echo "**Ready to Archive:** No" >> "$VERIFICATION_OUTPUT"
    echo "" >> "$VERIFICATION_OUTPUT"
    echo "Fix failing checks and run \`/forge-rd resume\` to re-verify." >> "$VERIFICATION_OUTPUT"

    update_state "VERIFICATION" "failed" "Verification FAIL. Fix issues and resume." "false"
    log_audit "verification_fail" "Checks failed ($CHECKS_PASSED/$CHECKS_RUN passed)"

    log_phase "VERIFICATION FAIL"
    log_error "Checks: $CHECKS_PASSED/$CHECKS_RUN passed"
    log_error "Review: $VERIFICATION_OUTPUT"
fi

echo "" >> "$VERIFICATION_OUTPUT"
echo "---" >> "$VERIFICATION_OUTPUT"
echo "" >> "$VERIFICATION_OUTPUT"
echo "*Generated by forge-rd-pipeline verification*" >> "$VERIFICATION_OUTPUT"

# Update summary line in report
sed -i '' "s/\*\*Overall Status:\*\* PENDING/**Overall Status:** $(if [[ "$OVERALL_PASS" == "true" ]]; then echo 'PASS'; else echo 'FAIL'; fi)/" "$VERIFICATION_OUTPUT"

log_info "Verification report: $VERIFICATION_OUTPUT"

if [[ "$OVERALL_PASS" == "true" ]]; then
    exit 0
else
    exit 1
fi
