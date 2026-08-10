#!/usr/bin/env bash
# loop.sh — bounded worker/verifier loop for when paseo is absent.
#
# Mirrors paseo's LoopService guarantees in ~100 lines: verification is
# mandatory, bounds are mandatory, every iteration is logged to disk.
# Workers/verifiers run ephemeral and blocking via handoff.sh.
#
# Usage:
#   loop.sh --worker <provider>[/<model>] --worker-prompt <file> \
#           [--verify-check "<shell cmd>"]... \
#           [--verifier <provider>[/<model>] --verify-prompt <file>] \
#           --max-iterations <N> [--max-time <seconds>] [--sleep <seconds>] [--dir <workdir>]
#
# Exit 0 when verification passes; 1 when bounds are hit without passing.
# A verifier prompt MUST instruct the agent to end with "VERDICT: PASS" or
# "VERDICT: FAIL" — that line is the contract this script checks.
set -euo pipefail

worker="" worker_prompt="" verifier="" verify_prompt="" max_iter=0 max_time=0 sleep_s=0 dir="$PWD"
verify_checks=()
while [ $# -gt 0 ]; do
  case "$1" in
    --worker)         worker="$2"; shift 2 ;;
    --worker-prompt)  worker_prompt="$2"; shift 2 ;;
    --verify-check)   verify_checks+=("$2"); shift 2 ;;
    --verifier)       verifier="$2"; shift 2 ;;
    --verify-prompt)  verify_prompt="$2"; shift 2 ;;
    --max-iterations) max_iter="$2"; shift 2 ;;
    --max-time)       max_time="$2"; shift 2 ;;
    --sleep)          sleep_s="$2"; shift 2 ;;
    --dir)            dir="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

# --- validation: same rules LoopService enforces in code ---
[ -n "$worker" ] && [ -f "${worker_prompt:-/nonexistent}" ] \
  || { echo "need --worker and an existing --worker-prompt file" >&2; exit 2; }
[ ${#verify_checks[@]} -gt 0 ] || [ -n "$verify_prompt" ] \
  || { echo "loop requires --verify-check and/or --verifier+--verify-prompt" >&2; exit 2; }
[ -z "$verify_prompt" ] || { [ -n "$verifier" ] && [ -f "$verify_prompt" ]; } \
  || { echo "--verify-prompt needs --verifier and an existing file" >&2; exit 2; }
[ "$max_iter" -gt 0 ] || [ "$max_time" -gt 0 ] \
  || { echo "loop requires --max-iterations and/or --max-time (no open-ended loops)" >&2; exit 2; }

bin="$(cd "$(dirname "$0")" && pwd)"
run_dir="$(cd "$(dirname "$worker_prompt")" && pwd)/loop-run-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$run_dir"
t0=$SECONDS i=0

echo "loop: worker=$worker verifier=${verifier:-none} checks=${#verify_checks[@]} max_iter=${max_iter:-∞} max_time=${max_time:-∞}s → $run_dir" >&2

while :; do
  i=$((i + 1))
  [ "$max_iter" -gt 0 ] && [ "$i" -gt "$max_iter" ] && { echo "loop: max-iterations reached without pass" >&2; exit 1; }
  [ "$max_time" -gt 0 ] && [ $((SECONDS - t0)) -ge "$max_time" ] && { echo "loop: max-time reached without pass" >&2; exit 1; }

  echo "── iteration $i (elapsed $((SECONDS - t0))s) ──" >&2
  cp "$worker_prompt" "$run_dir/iter-$i-worker.md"
  "$bin/handoff.sh" --brief "$run_dir/iter-$i-worker.md" --provider "$worker" \
    --role "loop-worker" --name "[loop $i worker]" --dir "$dir" \
    > "$run_dir/iter-$i-worker.out" || { echo "iteration $i: worker failed; continuing" >&2; }

  pass=true
  for cmd in "${verify_checks[@]+"${verify_checks[@]}"}"; do
    if (cd "$dir" && eval "$cmd") > "$run_dir/iter-$i-check.log" 2>&1; then
      echo "check ok: $cmd" >&2
    else
      echo "check FAILED: $cmd (see iter-$i-check.log)" >&2; pass=false; break
    fi
  done

  if $pass && [ -n "$verify_prompt" ]; then
    cp "$verify_prompt" "$run_dir/iter-$i-verifier.md"
    "$bin/handoff.sh" --brief "$run_dir/iter-$i-verifier.md" --provider "$verifier" \
      --role "loop-verifier" --name "[loop $i verifier]" --dir "$dir" \
      > "$run_dir/iter-$i-verifier.out" || true
    if grep -q "VERDICT: PASS" "$run_dir/iter-$i-verifier.out"; then
      echo "verifier: PASS" >&2
    else
      echo "verifier: FAIL (see iter-$i-verifier.out)" >&2; pass=false
    fi
  fi

  if $pass; then
    echo "loop: verification passed on iteration $i ($((SECONDS - t0))s)" >&2
    exit 0
  fi
  [ "$sleep_s" -gt 0 ] && sleep "$sleep_s"
done
