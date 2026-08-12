#!/usr/bin/env bash
set -euo pipefail

start='' ready_url='' test_command='' artifacts='' timeout=60
usage() { echo 'usage: run-browser-qa.sh --start CMD --ready-url URL --test CMD --artifacts DIR [--timeout SECONDS]' >&2; exit 2; }
while [ $# -gt 0 ]; do
  case "$1" in
    --start) start="${2:-}"; shift 2 ;;
    --ready-url) ready_url="${2:-}"; shift 2 ;;
    --test) test_command="${2:-}"; shift 2 ;;
    --artifacts) artifacts="${2:-}"; shift 2 ;;
    --timeout) timeout="${2:-}"; shift 2 ;;
    *) usage ;;
  esac
done
[ -n "$start" ] && [ -n "$ready_url" ] && [ -n "$test_command" ] && [ -n "$artifacts" ] || usage
mkdir -p "$artifacts"
# kill the app's whole process group, not just the sh wrapper — dev servers spawn
# grandchildren (sh → npm → node) that would otherwise survive holding the port
cleanup() { [ -n "${app_pid:-}" ] && { kill -- "-$app_pid" 2>/dev/null || kill "$app_pid" 2>/dev/null; } || true; }
trap cleanup EXIT INT TERM
set -m
sh -c "$start" >"$artifacts/app.log" 2>&1 & app_pid=$!
set +m
end=$((SECONDS + timeout))
until curl --fail --silent --show-error "$ready_url" >/dev/null; do
  [ "$SECONDS" -lt "$end" ] || { echo "app did not become ready: $ready_url" >&2; exit 1; }
  sleep 1
done
QA_ARTIFACTS_DIR="$artifacts" sh -c "$test_command"
