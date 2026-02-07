#!/bin/bash
# compute-hash.sh
# FORGE R&D Pipeline - SHA-256 Hash Computation
#
# Usage: ./compute-hash.sh <file-path> [--verify <expected-hash>]
#
# Computes SHA-256 hash of a file for approval validation

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

FILE_PATH="${1:-}"
VERIFY_MODE=false
EXPECTED_HASH=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --verify)
            VERIFY_MODE=true
            EXPECTED_HASH="$2"
            shift 2
            ;;
        *)
            if [[ -z "$FILE_PATH" ]]; then
                FILE_PATH="$1"
            fi
            shift
            ;;
    esac
done

if [[ -z "$FILE_PATH" ]] || [[ ! -f "$FILE_PATH" ]]; then
    echo "Usage: $0 <file-path> [--verify <expected-hash>]" >&2
    exit 1
fi

# Compute hash
COMPUTED_HASH=$(shasum -a 256 "$FILE_PATH" | cut -d' ' -f1)

if [[ "$VERIFY_MODE" == "true" ]]; then
    if [[ -z "$EXPECTED_HASH" ]]; then
        echo "Error: --verify requires an expected hash" >&2
        exit 1
    fi

    if [[ "$COMPUTED_HASH" == "$EXPECTED_HASH" ]]; then
        echo -e "${GREEN}MATCH${NC}"
        echo "Hash: $COMPUTED_HASH"
        exit 0
    else
        echo -e "${RED}MISMATCH${NC}"
        echo "Expected: $EXPECTED_HASH"
        echo "Computed: $COMPUTED_HASH"
        echo ""
        echo "ERROR: Proposal changed since approval request."
        echo "Action: Re-enter approval gate with /forge-rd status"
        exit 1
    fi
else
    # Just output the hash
    echo "$COMPUTED_HASH"
fi
