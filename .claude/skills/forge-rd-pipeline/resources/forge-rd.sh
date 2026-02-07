#!/bin/bash
# forge-rd.sh
# FORGE R&D Pipeline - Main Command Dispatcher
#
# Usage: ./forge-rd.sh <command> [args...]
#
# Commands:
#   start <slug> [--canon]     Start new pipeline
#   status                     Show current state
#   approve [--canon]          Approve proposal
#   reject "<feedback>"        Reject with feedback
#   confirm                    Second confirmation
#   answer <qid> "<answer>"    Answer clarifying question
#   hold                       Pause pipeline
#   resume                     Resume pipeline
#   cancel                     Cancel pipeline

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
FORGE_ROOT="${FORGE_ROOT:-$(cd "$(dirname "$0")/../../../.." && pwd)}"
WORKSPACE="$FORGE_ROOT/_workspace"
PROPOSALS="$WORKSPACE/04_proposals/work-items"
GLOBAL_STATE="$SKILL_DIR/references/pipeline-state.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_header() { echo -e "${BOLD}${BLUE}$1${NC}"; }

# Ensure global state exists
ensure_global_state() {
    if [[ ! -f "$GLOBAL_STATE" ]]; then
        cat > "$GLOBAL_STATE" << 'EOF'
{
  "version": 1,
  "work_item": null,
  "phase": "IDLE",
  "status": "idle",
  "status_display": "No active pipeline",
  "canon_mode": false,
  "canon_confirmed": false,
  "proposal_sha256": null,
  "blast_radius": null,
  "questions": null,
  "ralph_iterations": 0,
  "quality_gate_passed": false,
  "verification_passed": false,
  "work_item_path": null,
  "started_at": null,
  "updated_at": null,
  "error": null
}
EOF
    fi
}

# Get current state value
get_state() {
    local key="$1"
    python3 -c "import json; print(json.load(open('$GLOBAL_STATE')).get('$key', ''))"
}

# Get work-item state value
get_work_item_state() {
    local work_item_path="$1"
    local key="$2"
    local state_file="$work_item_path/state.json"
    if [[ -f "$state_file" ]]; then
        python3 -c "import json; print(json.load(open('$state_file')).get('$key', ''))"
    fi
}

# Update global state
update_global_state() {
    local updates="$1"
    python3 << EOF
import json
from datetime import datetime

with open('$GLOBAL_STATE', 'r') as f:
    state = json.load(f)

updates = $updates
state.update(updates)
state['updated_at'] = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')

with open('$GLOBAL_STATE', 'w') as f:
    json.dump(state, f, indent=2)
EOF
}

# Show usage
show_usage() {
    cat << EOF
${BOLD}FORGE R&D Pipeline${NC}

${CYAN}Usage:${NC} /forge-rd <command> [args...]

${CYAN}Commands:${NC}
  ${GREEN}start${NC} <slug> [--canon]     Start new pipeline for feature
  ${GREEN}status${NC}                     Show current pipeline state
  ${GREEN}approve${NC} [--canon]          Approve proposal at governance checkpoint
  ${GREEN}reject${NC} "<feedback>"        Reject proposal with feedback
  ${GREEN}confirm${NC}                    Second confirmation (canon/blast radius)
  ${GREEN}answer${NC} <qid> "<answer>"    Answer a clarifying question
  ${GREEN}hold${NC}                       Pause pipeline (preserves state)
  ${GREEN}resume${NC}                     Resume paused pipeline
  ${GREEN}cancel${NC}                     Cancel pipeline (archives partial work)
  ${GREEN}handoff${NC} <target> [--copy-to] Hand off to external project

${CYAN}Examples:${NC}
  /forge-rd start auth-extension
  /forge-rd start governance-rewrite --canon
  /forge-rd approve
  /forge-rd approve --canon
  /forge-rd reject "Need more detail on rollback plan"
  /forge-rd answer Q1 "Option A - use Supabase RLS"

EOF
}

# Command: start
cmd_start() {
    local slug=""
    local canon_mode=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --canon)
                canon_mode=true
                shift
                ;;
            *)
                slug="$1"
                shift
                ;;
        esac
    done

    if [[ -z "$slug" ]]; then
        log_error "Usage: /forge-rd start <slug> [--canon]"
        return 1
    fi

    # Check for active pipeline
    local current_phase=$(get_state "phase")
    if [[ "$current_phase" != "IDLE" ]] && [[ "$current_phase" != "null" ]] && [[ -n "$current_phase" ]]; then
        log_error "Pipeline already active: $(get_state 'work_item')"
        log_error "Use /forge-rd status to check, or /forge-rd cancel to abort."
        return 1
    fi

    log_header "Starting FORGE R&D Pipeline"
    log_info "Slug: $slug"
    log_info "Canon mode: $canon_mode"

    # Run intake processing
    local canon_flag=""
    [[ "$canon_mode" == "true" ]] && canon_flag="--canon"

    local work_item_path
    work_item_path=$("$SCRIPT_DIR/process-inbox.sh" "$slug" $canon_flag)

    if [[ -z "$work_item_path" ]] || [[ ! -d "$work_item_path" ]]; then
        log_error "Failed to create work-item"
        return 1
    fi

    local work_item=$(basename "$work_item_path")

    # Update global state
    update_global_state "{
        'work_item': '$work_item',
        'phase': 'INTAKE',
        'status': 'running',
        'status_display': 'Processing intake...',
        'canon_mode': $([[ "$canon_mode" == "true" ]] && echo "True" || echo "False"),
        'work_item_path': '$work_item_path',
        'started_at': '$(date -u +%Y-%m-%dT%H:%M:%SZ)'
    }"

    log_info "Work-item created: $work_item"
    log_info "Path: $work_item_path"
    echo ""
    log_header "Next Step: RECON Phase"
    echo ""
    echo "The pipeline will now invoke forge-recon-runner to analyze the source material."
    echo ""
    echo "---NEXT_PHASE---"
    echo "RECON"
    echo "---WORK_ITEM_PATH---"
    echo "$work_item_path"
}

# Command: status
cmd_status() {
    ensure_global_state

    local phase=$(get_state "phase")
    local work_item=$(get_state "work_item")
    local status_display=$(get_state "status_display")
    local canon_mode=$(get_state "canon_mode")
    local work_item_path=$(get_state "work_item_path")

    echo ""
    log_header "FORGE R&D Pipeline Status"
    echo ""

    if [[ "$phase" == "IDLE" ]] || [[ -z "$phase" ]] || [[ "$phase" == "null" ]]; then
        echo "Status: ${GREEN}IDLE${NC} - No active pipeline"
        echo ""
        echo "To start a new pipeline:"
        echo "  /forge-rd start <slug> [--canon]"
        return 0
    fi

    echo "Work-Item:     $work_item"
    echo "Phase:         ${CYAN}$phase${NC}"
    echo "Canon Mode:    $([[ "$canon_mode" == "True" ]] && echo "${YELLOW}Yes${NC}" || echo "No")"
    echo "Status:        $status_display"
    echo ""

    if [[ -n "$work_item_path" ]] && [[ -d "$work_item_path" ]]; then
        echo "Path: $work_item_path"
        echo ""

        # Show artifacts status
        echo "Artifacts:"
        for artifact in inventory.md recon-report.md questions.md synthesis.md proposal.md verification-report.md; do
            if [[ -f "$work_item_path/artifacts/$artifact" ]]; then
                echo "  ${GREEN}✓${NC} $artifact"
            else
                echo "  ${YELLOW}○${NC} $artifact"
            fi
        done
        echo ""
    fi

    # Phase-specific guidance
    case "$phase" in
        INTAKE)
            echo "Next: Run recon analysis"
            ;;
        RECON)
            echo "Next: Generate recon report with forge-recon-runner"
            ;;
        CLARIFYING_QUESTIONS)
            local questions=$(get_state "questions")
            echo "Action: Answer pending questions with /forge-rd answer <qid> \"<answer>\""
            ;;
        SYNTHESIS)
            echo "Next: Generate synthesis document"
            ;;
        PROPOSAL)
            local iterations=$(get_state "ralph_iterations")
            echo "Ralph iteration: $iterations/10"
            echo "Next: Generate/refine proposal"
            ;;
        AWAITING_APPROVAL)
            echo "${BOLD}Governance checkpoint reached: human authority required.${NC}"
            echo ""
            if [[ "$canon_mode" == "True" ]]; then
                echo "To approve (canon change requires two steps):"
                echo "  /forge-rd approve --canon"
                echo "  /forge-rd confirm"
            else
                echo "To approve: /forge-rd approve"
            fi
            echo "To reject:  /forge-rd reject \"<feedback>\""
            ;;
        BLAST_RADIUS_CHECK)
            echo "${YELLOW}Blast radius threshold exceeded.${NC}"
            echo "To confirm: /forge-rd confirm"
            ;;
        IMPLEMENT)
            echo "Implementation in progress..."
            ;;
        VERIFICATION)
            echo "Running verification checks..."
            ;;
        HELD)
            echo "Pipeline is paused. Use /forge-rd resume to continue."
            ;;
    esac
}

# Command: approve
cmd_approve() {
    local canon_flag=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --canon)
                canon_flag=true
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    local phase=$(get_state "phase")
    local canon_mode=$(get_state "canon_mode")
    local work_item_path=$(get_state "work_item_path")

    if [[ "$phase" != "AWAITING_APPROVAL" ]]; then
        log_error "Not at approval gate. Current phase: $phase"
        return 1
    fi

    # Validate canon flag
    if [[ "$canon_mode" == "True" ]] && [[ "$canon_flag" == "false" ]]; then
        log_error "Canon change detected but --canon flag not provided."
        log_error "This change affects method/core/. Use:"
        log_error "  /forge-rd approve --canon"
        return 1
    fi

    # Verify proposal hash
    local stored_hash=$(get_state "proposal_sha256")
    local proposal_file="$work_item_path/artifacts/proposal.md"

    if [[ -f "$proposal_file" ]] && [[ -n "$stored_hash" ]] && [[ "$stored_hash" != "null" ]]; then
        local current_hash=$("$SCRIPT_DIR/compute-hash.sh" "$proposal_file")

        if [[ "$current_hash" != "$stored_hash" ]]; then
            log_error "Proposal changed since approval request."
            log_error "Stored hash: $stored_hash"
            log_error "Current hash: $current_hash"
            log_error "Action: Re-review the proposal with /forge-rd status"
            return 1
        fi
        log_info "Proposal hash verified: $current_hash"
    fi

    # Log approval
    local audit_log="$work_item_path/audit-log.md"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    sed -i '' "/^| Timestamp | Phase | Event | Details |/a\\
| $timestamp | AWAITING_APPROVAL | approved | $(if [[ "$canon_flag" == "true" ]]; then echo 'canon approval'; else echo 'standard approval'; fi) |" "$audit_log" 2>/dev/null || true

    if [[ "$canon_flag" == "true" ]]; then
        log_info "Canon approval received. Second confirmation required."
        update_global_state "{'status': 'waiting', 'status_display': 'Canon change approved. Awaiting /forge-rd confirm'}"
        echo ""
        log_header "Canon Change Confirmation Required"
        echo ""
        echo "You are approving changes to method/core/."
        echo "This is a canon change and requires explicit confirmation."
        echo ""
        echo "To confirm: /forge-rd confirm"
    else
        # Check blast radius
        local cross_repo=$(get_work_item_state "$work_item_path" "blast_radius.cross_repo" 2>/dev/null || echo "false")
        local files_affected=$(get_work_item_state "$work_item_path" "blast_radius.files_affected" 2>/dev/null || echo "0")

        if [[ "$cross_repo" == "true" ]] || [[ "$files_affected" -gt 10 ]]; then
            log_warn "Blast radius threshold exceeded."
            log_warn "Cross-repo: $cross_repo, Files affected: $files_affected"
            update_global_state "{'phase': 'BLAST_RADIUS_CHECK', 'status': 'waiting', 'status_display': 'Blast radius confirmation required'}"
            echo ""
            log_header "Blast Radius Confirmation Required"
            echo ""
            echo "To confirm: /forge-rd confirm"
        else
            log_info "Approval received. Proceeding to implementation."
            update_global_state "{'phase': 'IMPLEMENT', 'status': 'running', 'status_display': 'Implementation in progress...'}"
            echo ""
            echo "---NEXT_PHASE---"
            echo "IMPLEMENT"
            echo "---WORK_ITEM_PATH---"
            echo "$work_item_path"
        fi
    fi
}

# Command: reject
cmd_reject() {
    local feedback="$1"

    if [[ -z "$feedback" ]]; then
        log_error "Usage: /forge-rd reject \"<feedback>\""
        return 1
    fi

    local phase=$(get_state "phase")
    local work_item_path=$(get_state "work_item_path")

    if [[ "$phase" != "AWAITING_APPROVAL" ]]; then
        log_error "Not at approval gate. Current phase: $phase"
        return 1
    fi

    # Log rejection
    local audit_log="$work_item_path/audit-log.md"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    sed -i '' "/^| Timestamp | Rejected By | Feedback |/a\\
| $timestamp | Human Lead | $feedback |" "$audit_log" 2>/dev/null || true

    # Add feedback to questions file
    local questions_file="$work_item_path/artifacts/questions.md"
    if [[ -f "$questions_file" ]]; then
        echo "" >> "$questions_file"
        echo "## Rejection Feedback" >> "$questions_file"
        echo "" >> "$questions_file"
        echo "**Date:** $timestamp" >> "$questions_file"
        echo "" >> "$questions_file"
        echo "$feedback" >> "$questions_file"
    fi

    log_info "Rejection recorded with feedback."
    update_global_state "{'phase': 'SYNTHESIS', 'status': 'running', 'status_display': 'Re-synthesizing based on feedback...', 'ralph_iterations': 0, 'quality_gate_passed': False}"

    echo ""
    log_header "Returning to SYNTHESIS Phase"
    echo ""
    echo "Feedback will be incorporated into the next proposal iteration."
    echo ""
    echo "---NEXT_PHASE---"
    echo "SYNTHESIS"
    echo "---WORK_ITEM_PATH---"
    echo "$work_item_path"
}

# Command: confirm
cmd_confirm() {
    local phase=$(get_state "phase")
    local canon_mode=$(get_state "canon_mode")
    local work_item_path=$(get_state "work_item_path")

    if [[ "$phase" == "AWAITING_APPROVAL" ]] && [[ "$canon_mode" == "True" ]]; then
        # Canon confirmation
        log_info "Canon change confirmed."
        update_global_state "{'canon_confirmed': True}"

        # Now check blast radius
        local cross_repo=$(get_work_item_state "$work_item_path" "blast_radius.cross_repo" 2>/dev/null || echo "false")
        local files_affected=$(get_work_item_state "$work_item_path" "blast_radius.files_affected" 2>/dev/null || echo "0")

        if [[ "$cross_repo" == "true" ]] || [[ "$files_affected" -gt 10 ]]; then
            update_global_state "{'phase': 'BLAST_RADIUS_CHECK', 'status': 'waiting', 'status_display': 'Blast radius confirmation required'}"
            log_warn "Blast radius threshold exceeded. Additional confirmation required."
            echo ""
            echo "To confirm blast radius: /forge-rd confirm"
        else
            update_global_state "{'phase': 'IMPLEMENT', 'status': 'running', 'status_display': 'Implementation in progress...'}"
            echo ""
            echo "---NEXT_PHASE---"
            echo "IMPLEMENT"
            echo "---WORK_ITEM_PATH---"
            echo "$work_item_path"
        fi

    elif [[ "$phase" == "BLAST_RADIUS_CHECK" ]]; then
        # Blast radius confirmation
        log_info "Blast radius confirmed. Proceeding to implementation."
        update_global_state "{'phase': 'IMPLEMENT', 'status': 'running', 'status_display': 'Implementation in progress...'}"
        echo ""
        echo "---NEXT_PHASE---"
        echo "IMPLEMENT"
        echo "---WORK_ITEM_PATH---"
        echo "$work_item_path"

    else
        log_error "No confirmation pending. Current phase: $phase"
        return 1
    fi
}

# Command: answer
cmd_answer() {
    local qid="$1"
    local answer="$2"

    if [[ -z "$qid" ]] || [[ -z "$answer" ]]; then
        log_error "Usage: /forge-rd answer <question-id> \"<answer>\""
        return 1
    fi

    local phase=$(get_state "phase")
    local work_item_path=$(get_state "work_item_path")

    if [[ "$phase" != "CLARIFYING_QUESTIONS" ]]; then
        log_warn "Not in clarifying questions phase, but recording answer anyway."
    fi

    local questions_file="$work_item_path/artifacts/questions.md"

    if [[ ! -f "$questions_file" ]]; then
        log_error "Questions file not found: $questions_file"
        return 1
    fi

    # Update questions file with answer
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    # Update the answer in the table (simplified - full implementation would parse markdown)
    log_info "Recording answer for $qid: $answer"

    # Log to audit
    local audit_log="$work_item_path/audit-log.md"
    sed -i '' "/^| Timestamp | Question ID | Answer | Answered By |/a\\
| $timestamp | $qid | $answer | Human Lead |" "$audit_log" 2>/dev/null || true

    # Check if all questions answered (simplified check)
    local remaining=$(grep -c "| *| *|$" "$questions_file" 2>/dev/null || echo "0")

    if [[ "$remaining" -eq 0 ]] || [[ "$remaining" -eq 1 ]]; then
        log_info "All questions answered. Proceeding to SYNTHESIS."
        update_global_state "{'phase': 'SYNTHESIS', 'status': 'running', 'status_display': 'All questions answered. Starting synthesis...'}"
        echo ""
        echo "---NEXT_PHASE---"
        echo "SYNTHESIS"
        echo "---WORK_ITEM_PATH---"
        echo "$work_item_path"
    else
        log_info "Questions remaining: $remaining"
    fi
}

# Command: hold
cmd_hold() {
    local phase=$(get_state "phase")
    local work_item_path=$(get_state "work_item_path")

    if [[ "$phase" == "IDLE" ]]; then
        log_error "No active pipeline to hold."
        return 1
    fi

    log_info "Pausing pipeline at phase: $phase"
    update_global_state "{'phase': 'HELD', 'status': 'held', 'status_display': 'Pipeline paused at $phase'}"

    # Log to audit
    local audit_log="$work_item_path/audit-log.md"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    sed -i '' "/^| Timestamp | Phase | Event | Details |/a\\
| $timestamp | $phase | pipeline_held | Paused by Human Lead |" "$audit_log" 2>/dev/null || true

    echo ""
    log_header "Pipeline Paused"
    echo ""
    echo "State preserved. Resume with: /forge-rd resume"
}

# Command: resume
cmd_resume() {
    local phase=$(get_state "phase")
    local work_item_path=$(get_state "work_item_path")

    if [[ "$phase" != "HELD" ]]; then
        log_error "Pipeline not paused. Current phase: $phase"
        return 1
    fi

    # Get the phase before hold (from audit log or state)
    local previous_phase=$(grep "pipeline_held" "$work_item_path/audit-log.md" 2>/dev/null | tail -1 | cut -d'|' -f3 | tr -d ' ' || echo "INTAKE")

    log_info "Resuming pipeline from: $previous_phase"
    update_global_state "{'phase': '$previous_phase', 'status': 'running', 'status_display': 'Resumed from hold'}"

    # Log to audit
    local audit_log="$work_item_path/audit-log.md"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    sed -i '' "/^| Timestamp | Phase | Event | Details |/a\\
| $timestamp | $previous_phase | pipeline_resumed | Resumed by Human Lead |" "$audit_log" 2>/dev/null || true

    echo ""
    echo "---NEXT_PHASE---"
    echo "$previous_phase"
    echo "---WORK_ITEM_PATH---"
    echo "$work_item_path"
}

# Command: cancel
cmd_cancel() {
    local phase=$(get_state "phase")
    local work_item=$(get_state "work_item")
    local work_item_path=$(get_state "work_item_path")

    if [[ "$phase" == "IDLE" ]]; then
        log_error "No active pipeline to cancel."
        return 1
    fi

    log_warn "Cancelling pipeline: $work_item"

    # Log to audit before archiving
    if [[ -d "$work_item_path" ]]; then
        local audit_log="$work_item_path/audit-log.md"
        local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
        sed -i '' "/^| Timestamp | Phase | Event | Details |/a\\
| $timestamp | $phase | pipeline_cancelled | Cancelled by Human Lead |" "$audit_log" 2>/dev/null || true

        # Archive partial work
        "$SCRIPT_DIR/archive-workitem.sh" "$work_item_path" 2>/dev/null || true
    fi

    # Reset global state
    update_global_state "{
        'work_item': None,
        'phase': 'IDLE',
        'status': 'idle',
        'status_display': 'Pipeline cancelled',
        'canon_mode': False,
        'canon_confirmed': False,
        'proposal_sha256': None,
        'blast_radius': None,
        'questions': None,
        'ralph_iterations': 0,
        'quality_gate_passed': False,
        'verification_passed': False,
        'work_item_path': None,
        'started_at': None,
        'error': None
    }"

    echo ""
    log_header "Pipeline Cancelled"
    echo ""
    echo "Partial work archived to: $WORKSPACE/99_archive/"
}

# Command: handoff
cmd_handoff() {
    local target=""
    local copy_to=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --copy-to)
                copy_to="$2"
                shift 2
                ;;
            *)
                if [[ -z "$target" ]]; then
                    target="$1"
                fi
                shift
                ;;
        esac
    done

    if [[ -z "$target" ]]; then
        log_error "Usage: /forge-rd handoff <target> [--copy-to <path>]"
        log_error "Example: /forge-rd handoff my-project --copy-to ~/my-project/ai_prompts/active/feature/"
        return 1
    fi

    local phase=$(get_state "phase")
    local work_item=$(get_state "work_item")
    local work_item_path=$(get_state "work_item_path")

    # Validate phase
    if [[ "$phase" != "AWAITING_APPROVAL" ]] && [[ "$phase" != "HELD" ]]; then
        log_error "Handoff only available at AWAITING_APPROVAL or HELD phase."
        log_error "Current phase: $phase"
        return 1
    fi

    log_info "Handing off to: $target"

    # Handle copy-to if specified
    if [[ -n "$copy_to" ]]; then
        log_info "Copying artifacts to: $copy_to"
        mkdir -p "$copy_to"

        if [[ -f "$work_item_path/artifacts/proposal.md" ]]; then
            cp "$work_item_path/artifacts/proposal.md" "$copy_to/"
            log_info "  → proposal.md"
        fi

        if [[ -f "$work_item_path/artifacts/synthesis.md" ]]; then
            cp "$work_item_path/artifacts/synthesis.md" "$copy_to/"
            log_info "  → synthesis.md"
        fi

        if [[ -f "$work_item_path/artifacts/recon-report.md" ]]; then
            cp "$work_item_path/artifacts/recon-report.md" "$copy_to/"
            log_info "  → recon-report.md"
        fi
    fi

    # Log to audit
    local audit_log="$work_item_path/audit-log.md"
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    local details="target: $target"
    [[ -n "$copy_to" ]] && details="$details, copy_to: $copy_to"

    sed -i '' "/^| Timestamp | Phase | Event | Details |/a\\
| $timestamp | $phase | handoff_initiated | $details |" "$audit_log" 2>/dev/null || true

    # Update state with handoff info
    python3 << EOF
import json

with open('$work_item_path/state.json', 'r') as f:
    state = json.load(f)

state['phase'] = 'HANDED_OFF'
state['status'] = 'handed_off'
state['status_display'] = 'Handed off to $target'
state['handoff_target'] = '$target'
state['handoff_copy_path'] = '$copy_to' if '$copy_to' else None
state['updated_at'] = '$timestamp'

with open('$work_item_path/state.json', 'w') as f:
    json.dump(state, f, indent=2)
EOF

    # Archive with HANDED_OFF status
    "$SCRIPT_DIR/archive-workitem.sh" "$work_item_path" --status HANDED_OFF

    # Reset global state
    update_global_state "{
        'work_item': None,
        'phase': 'IDLE',
        'status': 'idle',
        'status_display': 'No active pipeline',
        'canon_mode': False,
        'canon_confirmed': False,
        'proposal_sha256': None,
        'blast_radius': None,
        'questions': None,
        'ralph_iterations': 0,
        'quality_gate_passed': False,
        'verification_passed': False,
        'work_item_path': None,
        'started_at': None,
        'error': None
    }"

    echo ""
    log_header "Handoff Complete"
    echo ""
    echo "Work-item: $work_item"
    echo "Target: $target"
    [[ -n "$copy_to" ]] && echo "Copied to: $copy_to"
    echo "Archived to: $WORKSPACE/99_archive/"
}

# Main dispatcher
main() {
    ensure_global_state

    local command="${1:-}"
    shift || true

    case "$command" in
        start)
            cmd_start "$@"
            ;;
        status)
            cmd_status
            ;;
        approve)
            cmd_approve "$@"
            ;;
        reject)
            cmd_reject "$@"
            ;;
        confirm)
            cmd_confirm
            ;;
        answer)
            cmd_answer "$@"
            ;;
        hold)
            cmd_hold
            ;;
        resume)
            cmd_resume
            ;;
        cancel)
            cmd_cancel
            ;;
        handoff)
            cmd_handoff "$@"
            ;;
        help|--help|-h|"")
            show_usage
            ;;
        *)
            log_error "Unknown command: $command"
            show_usage
            return 1
            ;;
    esac
}

main "$@"
