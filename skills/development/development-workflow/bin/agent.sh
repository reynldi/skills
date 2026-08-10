#!/usr/bin/env bash
# agent.sh — minimal multi-provider agent runner for the /development-workflow pipeline.
#
# Usage:
#   agent.sh list                                      # show installed providers
#   agent.sh <provider>[/<model>] <handoff.md> [dir]   # run one delegation
#
# Providers: claude, codex, gemini, opencode, pi. Model is optional and
# provider-native, everything after the first slash:
#   claude/opus   codex/gpt-5.1-codex   gemini/flash
#   opencode/anthropic/claude-sonnet-4-5   pi/openai/gpt-5.1  (pi models take a :thinkingLevel suffix, e.g. pi/sonnet:high)
#
# The handoff file IS the complete prompt (see ../templates/handoff.md).
# stdout = the agent's final output. Progress + output are appended to
# <handoff>.log beside the handoff file (full observability, no hidden state).
#
# AGENT_RESUME=1 continues the provider's most recent session in this
# directory instead of starting fresh — use it when iterating on the same
# stage so the delegate keeps its context (claude -c, codex exec resume
# --last, opencode -c, pi -c; gemini has no resume and runs fresh).
#
# Defaults are guarded (sandbox / edit-only approval). AGENT_YOLO=1 removes
# the guardrails — use only inside an isolated worktree or container.
set -euo pipefail

providers=(claude codex gemini opencode pi)

if [ "${1:-}" = "list" ]; then
  for p in "${providers[@]}"; do
    printf '%-9s %s\n' "$p" "$(command -v "$p" 2>/dev/null || echo missing)"
  done
  exit 0
fi

spec="${1:?usage: agent.sh <provider>[/<model>] <handoff.md> [dir] | agent.sh list}"
handoff="${2:?handoff file required}"
dir="${3:-$PWD}"

provider="${spec%%/*}"
model="${spec#*/}"; [ "$model" = "$spec" ] && model=""
[ -f "$handoff" ] || { echo "handoff file not found: $handoff" >&2; exit 2; }
command -v "$provider" >/dev/null 2>&1 || { echo "provider not installed: $provider" >&2; exit 2; }

handoff_abs="$(cd "$(dirname "$handoff")" && pwd)/$(basename "$handoff")"
log="${handoff_abs%.md}.log"
prompt="$(cat "$handoff_abs")"
yolo="${AGENT_YOLO:-}"
resume="${AGENT_RESUME:-}"

echo "=== $(date '+%Y-%m-%d %H:%M:%S') $provider${model:+/$model} $(basename "$handoff_abs") dir=$dir${resume:+ (resume)}" >>"$log"
cd "$dir"

case "$provider" in
  claude)
    # -p = headless print mode; -c continues the most recent conversation here.
    claude ${resume:+-c} -p "$prompt" ${model:+--model "$model"} \
      $([ -n "$yolo" ] && echo "--dangerously-skip-permissions" || echo "--permission-mode acceptEdits") \
      2>>"$log" | tee -a "$log"
    ;;
  codex)
    # 'codex exec -' reads the prompt from stdin; progress goes to stderr.
    if [ -n "$resume" ]; then
      printf '%s' "$prompt" | codex exec resume --last - 2>>"$log" | tee -a "$log"
    else
      if [ -n "$yolo" ]; then guard="--dangerously-bypass-approvals-and-sandbox"; else guard="--sandbox workspace-write"; fi
      printf '%s' "$prompt" | codex exec - ${model:+-m "$model"} $guard --skip-git-repo-check \
        2>>"$log" | tee -a "$log"
    fi
    ;;
  gemini)
    # Non-TTY stdin triggers headless mode; yolo approval is required for edits.
    [ -n "$resume" ] && echo "gemini: no session resume — running fresh" >&2
    printf '%s' "$prompt" | gemini ${model:+-m "$model"} --approval-mode=yolo \
      2>>"$log" | tee -a "$log"
    ;;
  opencode)
    # Without --auto, headless opencode auto-rejects every permission request.
    printf '%s' "$prompt" | opencode run ${resume:+-c} ${model:+-m "$model"} --auto \
      2>>"$log" | tee -a "$log"
    ;;
  pi)
    # pi has no permission system (isolate externally); -p = headless one-shot.
    pi ${resume:+-c} -p "$prompt" ${model:+--model "$model"} 2>>"$log" | tee -a "$log"
    ;;
  *)
    echo "unknown provider: $provider (use: ${providers[*]})" >&2
    exit 2
    ;;
esac
