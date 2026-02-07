#!/bin/bash
# smoke-test.sh
# FORGE R&D Pipeline - Template Smoke Test
#
# Usage: ./smoke-test.sh <template-path> <output-log>
#
# Instantiates template in temp dir and runs Sacred Four

set -euo pipefail

FORGE_ROOT="${FORGE_ROOT:-$(cd "$(dirname "$0")/../../../.." && pwd)}"
WORKSPACE="$FORGE_ROOT/_workspace"
SMOKE_DIR="$WORKSPACE/.tmp/smoke"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

TEMPLATE_PATH="${1:-$FORGE_ROOT/template/project}"
OUTPUT_LOG="${2:-/dev/stdout}"

if [[ ! -d "$TEMPLATE_PATH" ]]; then
    log_error "Template not found: $TEMPLATE_PATH"
    exit 1
fi

# Create smoke test directory
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
TEST_DIR="$SMOKE_DIR/$TIMESTAMP"
mkdir -p "$TEST_DIR"

log_info "Starting smoke test..."
log_info "Template: $TEMPLATE_PATH"
log_info "Test dir: $TEST_DIR"
log_info "Output: $OUTPUT_LOG"

# Initialize log
{
    echo "# Smoke Test Log"
    echo ""
    echo "**Timestamp:** $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "**Template:** $TEMPLATE_PATH"
    echo "**Test Directory:** $TEST_DIR"
    echo ""
    echo "---"
    echo ""
} > "$OUTPUT_LOG"

# Copy template
log_info "Step 1: Copying template..."
{
    echo "## Step 1: Copy Template"
    echo ""
    echo "\`\`\`"
} >> "$OUTPUT_LOG"

if cp -r "$TEMPLATE_PATH"/* "$TEST_DIR/" >> "$OUTPUT_LOG" 2>&1; then
    echo "\`\`\`" >> "$OUTPUT_LOG"
    echo "**Status:** PASS" >> "$OUTPUT_LOG"
    log_info "  PASS"
else
    echo "\`\`\`" >> "$OUTPUT_LOG"
    echo "**Status:** FAIL" >> "$OUTPUT_LOG"
    log_error "  FAIL - Could not copy template"
    exit 1
fi

echo "" >> "$OUTPUT_LOG"

# Change to test directory
cd "$TEST_DIR"

# Remove .git if present (fresh start)
rm -rf .git 2>/dev/null || true

# Install dependencies
log_info "Step 2: Installing dependencies..."
{
    echo "## Step 2: Install Dependencies"
    echo ""
    echo "\`\`\`"
} >> "$OUTPUT_LOG"

INSTALL_SUCCESS=false
if [[ -f "package.json" ]]; then
    if command -v pnpm &> /dev/null; then
        if pnpm install >> "$OUTPUT_LOG" 2>&1; then
            INSTALL_SUCCESS=true
        fi
    elif command -v npm &> /dev/null; then
        if npm install >> "$OUTPUT_LOG" 2>&1; then
            INSTALL_SUCCESS=true
        fi
    fi
fi

echo "\`\`\`" >> "$OUTPUT_LOG"

if [[ "$INSTALL_SUCCESS" == "true" ]]; then
    echo "**Status:** PASS" >> "$OUTPUT_LOG"
    log_info "  PASS"
else
    echo "**Status:** FAIL or SKIP (no package.json or install failed)" >> "$OUTPUT_LOG"
    log_warn "  SKIP or FAIL"
fi

echo "" >> "$OUTPUT_LOG"

# Run Sacred Four
log_info "Step 3: Running Sacred Four..."
{
    echo "## Step 3: Sacred Four"
    echo ""
} >> "$OUTPUT_LOG"

SACRED_FOUR_PASS=true

# TypeCheck
{
    echo "### TypeCheck"
    echo ""
    echo "\`\`\`"
} >> "$OUTPUT_LOG"

if [[ -f "package.json" ]] && grep -q '"typecheck"' package.json 2>/dev/null; then
    if pnpm typecheck >> "$OUTPUT_LOG" 2>&1 || npm run typecheck >> "$OUTPUT_LOG" 2>&1; then
        echo "\`\`\`" >> "$OUTPUT_LOG"
        echo "**Status:** PASS" >> "$OUTPUT_LOG"
        log_info "  typecheck: PASS"
    else
        echo "\`\`\`" >> "$OUTPUT_LOG"
        echo "**Status:** FAIL" >> "$OUTPUT_LOG"
        log_error "  typecheck: FAIL"
        SACRED_FOUR_PASS=false
    fi
else
    echo "No typecheck script found" >> "$OUTPUT_LOG"
    echo "\`\`\`" >> "$OUTPUT_LOG"
    echo "**Status:** SKIP" >> "$OUTPUT_LOG"
    log_warn "  typecheck: SKIP"
fi

echo "" >> "$OUTPUT_LOG"

# Lint
{
    echo "### Lint"
    echo ""
    echo "\`\`\`"
} >> "$OUTPUT_LOG"

if [[ -f "package.json" ]] && grep -q '"lint"' package.json 2>/dev/null; then
    if pnpm lint >> "$OUTPUT_LOG" 2>&1 || npm run lint >> "$OUTPUT_LOG" 2>&1; then
        echo "\`\`\`" >> "$OUTPUT_LOG"
        echo "**Status:** PASS" >> "$OUTPUT_LOG"
        log_info "  lint: PASS"
    else
        echo "\`\`\`" >> "$OUTPUT_LOG"
        echo "**Status:** FAIL" >> "$OUTPUT_LOG"
        log_error "  lint: FAIL"
        SACRED_FOUR_PASS=false
    fi
else
    echo "No lint script found" >> "$OUTPUT_LOG"
    echo "\`\`\`" >> "$OUTPUT_LOG"
    echo "**Status:** SKIP" >> "$OUTPUT_LOG"
    log_warn "  lint: SKIP"
fi

echo "" >> "$OUTPUT_LOG"

# Test
{
    echo "### Test"
    echo ""
    echo "\`\`\`"
} >> "$OUTPUT_LOG"

if [[ -f "package.json" ]] && grep -qE '"test(:run)?"' package.json 2>/dev/null; then
    if pnpm test:run >> "$OUTPUT_LOG" 2>&1 || pnpm test >> "$OUTPUT_LOG" 2>&1 || npm run test >> "$OUTPUT_LOG" 2>&1; then
        echo "\`\`\`" >> "$OUTPUT_LOG"
        echo "**Status:** PASS" >> "$OUTPUT_LOG"
        log_info "  test: PASS"
    else
        echo "\`\`\`" >> "$OUTPUT_LOG"
        echo "**Status:** FAIL" >> "$OUTPUT_LOG"
        log_error "  test: FAIL"
        SACRED_FOUR_PASS=false
    fi
else
    echo "No test script found" >> "$OUTPUT_LOG"
    echo "\`\`\`" >> "$OUTPUT_LOG"
    echo "**Status:** SKIP" >> "$OUTPUT_LOG"
    log_warn "  test: SKIP"
fi

echo "" >> "$OUTPUT_LOG"

# Build
{
    echo "### Build"
    echo ""
    echo "\`\`\`"
} >> "$OUTPUT_LOG"

if [[ -f "package.json" ]] && grep -q '"build"' package.json 2>/dev/null; then
    if pnpm build >> "$OUTPUT_LOG" 2>&1 || npm run build >> "$OUTPUT_LOG" 2>&1; then
        echo "\`\`\`" >> "$OUTPUT_LOG"
        echo "**Status:** PASS" >> "$OUTPUT_LOG"
        log_info "  build: PASS"
    else
        echo "\`\`\`" >> "$OUTPUT_LOG"
        echo "**Status:** FAIL" >> "$OUTPUT_LOG"
        log_error "  build: FAIL"
        SACRED_FOUR_PASS=false
    fi
else
    echo "No build script found" >> "$OUTPUT_LOG"
    echo "\`\`\`" >> "$OUTPUT_LOG"
    echo "**Status:** SKIP" >> "$OUTPUT_LOG"
    log_warn "  build: SKIP"
fi

echo "" >> "$OUTPUT_LOG"

# Summary
{
    echo "---"
    echo ""
    echo "## Summary"
    echo ""
} >> "$OUTPUT_LOG"

if [[ "$SACRED_FOUR_PASS" == "true" ]]; then
    echo "**Overall Result:** PASS" >> "$OUTPUT_LOG"
    log_info "Smoke test: PASS"

    # Cleanup on success
    log_info "Cleaning up test directory..."
    rm -rf "$TEST_DIR"
    echo "" >> "$OUTPUT_LOG"
    echo "Test directory cleaned up." >> "$OUTPUT_LOG"

    exit 0
else
    echo "**Overall Result:** FAIL" >> "$OUTPUT_LOG"
    log_error "Smoke test: FAIL"
    log_warn "Test directory preserved for inspection: $TEST_DIR"
    echo "" >> "$OUTPUT_LOG"
    echo "Test directory preserved: $TEST_DIR" >> "$OUTPUT_LOG"

    exit 1
fi
