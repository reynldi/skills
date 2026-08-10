#!/usr/bin/env bash
# backend.sh — resolve the orchestration backend and providers, deterministically.
#
# Usage: backend.sh
#
# Prints:
#   backend: paseo | native | none
#   providers installed (native CLIs)
#   role → provider map from ~/.paseo/orchestration-preferences.json (if present)
#
# The orchestrator skill runs this first instead of probing by hand.
set -euo pipefail

# --- backend detection ---
backend="none"
if command -v paseo >/dev/null 2>&1 && paseo daemon status >/dev/null 2>&1; then
  backend="paseo"
elif curl -sf --max-time 2 http://127.0.0.1:6767/api/health >/dev/null 2>&1; then
  backend="paseo"
else
  for p in claude codex gemini opencode pi; do
    if command -v "$p" >/dev/null 2>&1; then backend="native"; break; fi
  done
fi
echo "backend: $backend"

# --- installed provider CLIs ---
echo "providers:"
for p in claude codex gemini opencode pi; do
  printf '  %-9s %s\n' "$p" "$(command -v "$p" 2>/dev/null || echo missing)"
done

# --- orchestration preferences ---
prefs="${PASEO_HOME:-$HOME/.paseo}/orchestration-preferences.json"
if [ -f "$prefs" ]; then
  echo "preferences: $prefs"
  if command -v jq >/dev/null 2>&1; then
    jq -r '.providers | to_entries[] | "  \(.key): \(.value)"' "$prefs" 2>/dev/null || true
    jq -r '.preferences[]? | "  note: \(.)"' "$prefs" 2>/dev/null || true
  else
    python3 -c '
import json,sys
d=json.load(open(sys.argv[1]))
for k,v in d.get("providers",{}).items(): print(f"  {k}: {v}")
for n in d.get("preferences",[]): print(f"  note: {n}")
' "$prefs" 2>/dev/null || cat "$prefs"
  fi
else
  echo "preferences: none (using backend defaults)"
fi
