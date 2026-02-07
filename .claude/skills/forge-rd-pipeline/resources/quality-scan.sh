#!/bin/bash
# quality-scan.sh
# FORGE R&D Pipeline - Proposal Quality Gate
#
# Usage: ./quality-scan.sh <proposal-path>
#
# Scans proposal for forbidden terms and completeness

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

PROPOSAL_PATH="${1:-}"

if [[ -z "$PROPOSAL_PATH" ]] || [[ ! -f "$PROPOSAL_PATH" ]]; then
    log_error "Usage: $0 <proposal-path>"
    exit 1
fi

log_info "Scanning proposal: $PROPOSAL_PATH"

# Forbidden terms that block approval
FORBIDDEN_TERMS=(
    "TBD"
    "???"
    "maybe"
    "should"
    "consider"
    "TODO"
    "FIXME"
)

# Track findings
TOTAL_BLOCKING=0
declare -a FINDINGS

# Scan for forbidden terms
log_info "Checking for forbidden terms..."
for term in "${FORBIDDEN_TERMS[@]}"; do
    # Case-insensitive search (except TBD, TODO, FIXME which are uppercase)
    if [[ "$term" =~ ^[A-Z]+$ ]]; then
        # Exact case for uppercase terms
        matches=$(grep -n "\b${term}\b" "$PROPOSAL_PATH" 2>/dev/null || true)
    else
        # Case-insensitive for lowercase terms
        matches=$(grep -ni "\b${term}\b" "$PROPOSAL_PATH" 2>/dev/null || true)
    fi

    if [[ -n "$matches" ]]; then
        count=$(echo "$matches" | wc -l | tr -d ' ')
        TOTAL_BLOCKING=$((TOTAL_BLOCKING + count))

        # Store line numbers
        lines=$(echo "$matches" | cut -d: -f1 | tr '\n' ',' | sed 's/,$//')
        FINDINGS+=("$term|$count|$lines")
        log_warn "  Found '$term' on lines: $lines"
    fi
done

# Check required sections
log_info "Checking section completeness..."
REQUIRED_SECTIONS=(
    "## 1. Summary"
    "## 2. Background"
    "## 3. Proposal"
    "## 4. Technical Specification"
    "## 5. Implementation Plan"
    "## 6. Acceptance Criteria"
    "## 7. Risks & Mitigations"
    "## 8. Rollback Plan"
    "## 9. Testing Strategy"
    "## 10. Documentation Updates"
    "## 11. Blast Radius"
)

MISSING_SECTIONS=()
for section in "${REQUIRED_SECTIONS[@]}"; do
    if ! grep -q "$section" "$PROPOSAL_PATH"; then
        MISSING_SECTIONS+=("$section")
        log_warn "  Missing section: $section"
    fi
done

# Calculate completeness
TOTAL_SECTIONS=${#REQUIRED_SECTIONS[@]}
PRESENT_SECTIONS=$((TOTAL_SECTIONS - ${#MISSING_SECTIONS[@]}))
COMPLETENESS=$((PRESENT_SECTIONS * 100 / TOTAL_SECTIONS))

# Check acceptance criteria format
log_info "Validating acceptance criteria..."
AC_ISSUES=()

# Look for acceptance criteria section content
AC_SECTION=$(sed -n '/## 6. Acceptance Criteria/,/## 7./p' "$PROPOSAL_PATH" 2>/dev/null || true)

if [[ -n "$AC_SECTION" ]]; then
    # Check for ambiguous language in AC
    for term in "approximately" "roughly" "about" "around" "possibly"; do
        if echo "$AC_SECTION" | grep -qi "\b${term}\b"; then
            AC_ISSUES+=("Ambiguous term '$term' found in acceptance criteria")
        fi
    done
fi

# Output results
echo ""
echo "=========================================="
echo "QUALITY GATE REPORT"
echo "=========================================="
echo ""
echo "Forbidden Terms Found: $TOTAL_BLOCKING"
if [[ ${#FINDINGS[@]} -gt 0 ]]; then
    echo ""
    echo "| Term | Count | Lines |"
    echo "|------|-------|-------|"
    for finding in "${FINDINGS[@]}"; do
        IFS='|' read -r term count lines <<< "$finding"
        echo "| $term | $count | $lines |"
    done
fi

echo ""
echo "Section Completeness: $COMPLETENESS% ($PRESENT_SECTIONS/$TOTAL_SECTIONS)"
if [[ ${#MISSING_SECTIONS[@]} -gt 0 ]]; then
    echo ""
    echo "Missing Sections:"
    for section in "${MISSING_SECTIONS[@]}"; do
        echo "  - $section"
    done
fi

if [[ ${#AC_ISSUES[@]} -gt 0 ]]; then
    echo ""
    echo "Acceptance Criteria Issues:"
    for issue in "${AC_ISSUES[@]}"; do
        echo "  - $issue"
    done
fi

echo ""
echo "=========================================="

# Determine pass/fail
if [[ $TOTAL_BLOCKING -eq 0 ]] && [[ ${#MISSING_SECTIONS[@]} -eq 0 ]] && [[ ${#AC_ISSUES[@]} -eq 0 ]]; then
    echo -e "${GREEN}RESULT: PASS${NC}"
    echo ""
    echo "Proposal ready for governance checkpoint."
    exit 0
else
    echo -e "${RED}RESULT: FAIL${NC}"
    echo ""
    echo "Issues must be resolved before approval."
    exit 1
fi
