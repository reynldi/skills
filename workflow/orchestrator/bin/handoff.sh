#!/usr/bin/env bash
# handoff.sh — ephemeral, blocking handoff (synchronous supervisor pattern).
#
# The orchestrator calls this and WAITS. The delegate runs headless, finishes,
# reports, and its process ends — no long-lived agents. stdout = the delegate's
# final report. A delegation summary (agent name, role, provider/model, effort,
# session ID, timing, status) is printed to stderr and written beside the brief
# as <brief>.summary.json.
#
# Usage:
#   handoff.sh --brief <handoff.md> --provider <p>[/<model>] \
#              [--role <role>] [--effort <level>] [--dir <workdir>] [--name <agent-name>]
#
# Delegation runs through agent.sh (single source for provider invocation).
# Override its location with AGENT_SH=<path>.
set -euo pipefail

brief="" provider_spec="" role="delegate" effort="default" dir="$PWD" name=""
while [ $# -gt 0 ]; do
  case "$1" in
    --brief)    brief="$2"; shift 2 ;;
    --provider) provider_spec="$2"; shift 2 ;;
    --role)     role="$2"; shift 2 ;;
    --effort)   effort="$2"; shift 2 ;;
    --dir)      dir="$2"; shift 2 ;;
    --name)     name="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done
[ -n "$brief" ] && [ -f "$brief" ] || { echo "usage: handoff.sh --brief <handoff.md> --provider <p>[/<model>] [...]" >&2; exit 2; }
[ -n "$provider_spec" ] || { echo "--provider required (resolve via backend.sh first)" >&2; exit 2; }

# Locate the shared agent.sh runner: repo layout (skills/development/workflow/bin)
# or installed layout (sibling skill: <skills-dir>/workflow/bin). AGENT_SH= overrides.
here="$(cd "$(dirname "$0")" && pwd)"
if [ -z "${AGENT_SH:-}" ]; then
  for c in "$here/../../../skills/development/workflow/bin/agent.sh" \
           "$here/../../workflow/bin/agent.sh"; do
    [ -x "$c" ] && AGENT_SH="$c" && break
  done
fi
[ -n "${AGENT_SH:-}" ] && [ -x "$AGENT_SH" ] || { echo "agent.sh not found (repo or installed layout); set AGENT_SH=<path>" >&2; exit 2; }

provider="${provider_spec%%/*}"
model="${provider_spec#*/}"; [ "$model" = "$provider_spec" ] && model="(provider default)"
brief_abs="$(cd "$(dirname "$brief")" && pwd)/$(basename "$brief")"
[ -n "$name" ] || name="[Handoff] $(basename "${brief_abs%.md}")"
started="$(date '+%Y-%m-%dT%H:%M:%S%z')"; t0=$SECONDS

summary() {  # $1=status $2=session_id $3=duration
  {
    echo "── delegation summary ─────────────────────────"
    printf '%-12s %s\n' "agent:" "$name" "role:" "$role" "provider:" "$provider" \
      "model:" "$model" "effort:" "$effort" "session:" "$2" \
      "status:" "$1" "duration:" "${3}s" "brief:" "$brief_abs" "log:" "${brief_abs%.md}.log"
    echo "───────────────────────────────────────────────"
  } >&2
  cat > "${brief_abs%.md}.summary.json" <<JSON
{
  "agent": "$name",
  "role": "$role",
  "provider": "$provider",
  "model": "$model",
  "effort": "$effort",
  "session_id": "$2",
  "status": "$1",
  "started": "$started",
  "duration_seconds": $3,
  "brief": "$brief_abs",
  "log": "${brief_abs%.md}.log",
  "workdir": "$dir"
}
JSON
}

session_id() {  # best-effort per provider, post-run
  case "$provider" in
    claude)
      slug="$(cd "$dir" && pwd | tr '/.' '--')"
      ls -t "$HOME/.claude/projects/$slug"/*.jsonl 2>/dev/null | head -1 | xargs -I{} basename {} .jsonl || true ;;
    codex)
      ls -t "$HOME"/.codex/sessions/*/*/*/rollout-*.jsonl 2>/dev/null | head -1 \
        | sed -E 's/.*rollout-[0-9T-]+-([0-9a-f-]{36})\.jsonl/\1/' || true ;;
    *) echo "" ;;
  esac
}

echo "→ handing off to $provider_spec as \"$name\" (blocking; report follows)" >&2
status="completed"
"$AGENT_SH" "$provider_spec" "$brief_abs" "$dir" || status="failed(exit=$?)"
sid="$(session_id)"; [ -n "$sid" ] || sid="n/a"
summary "$status" "$sid" "$((SECONDS - t0))"
[ "$status" = "completed" ]
