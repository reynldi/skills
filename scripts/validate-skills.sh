#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
errors=0
warnings=0
skill_names="$(mktemp)"
trap 'rm -f "$skill_names"' EXIT

error() { printf 'ERROR: %s\n' "$*" >&2; errors=$((errors + 1)); }
warning() { printf 'WARN: %s\n' "$*" >&2; warnings=$((warnings + 1)); }
has_skill() { grep -Fqx "$1" "$skill_names"; }

while IFS= read -r skill_file; do
  skill_dir="$(dirname "$skill_file")"
  name="$(sed -n 's/^name: //p' "$skill_file" | head -1)"
  description="$(sed -n 's/^description: //p' "$skill_file" | head -1)"
  [ -n "$name" ] || error "$skill_file has no name"
  [ -n "$description" ] || error "$skill_file has no description"
  [ -n "$name" ] && printf '%s\n' "$name" >>"$skill_names"

  while IFS= read -r template; do
    [ -f "$skill_dir/$template" ] || error "$skill_file references missing $template"
  done < <(rg -o '`templates/[A-Za-z0-9._-]+' "$skill_file" | sed 's/^`//' | sort -u)
done < <(find "$root/skills" "$root/workflow" -name SKILL.md -type f | sort)

while IFS= read -r command_file; do
  target="$(sed -n 's/^Invoke the `\([^`]*\)` skill.*/\1/p' "$command_file")"
  [ -n "$target" ] || { warning "$command_file has no skill target"; continue; }
  has_skill "$target" || error "$command_file targets missing skill $target"
done < <(find "$root/commands" -name '*.md' -type f | sort)

while IFS= read -r workflow_file; do
  while IFS= read -r target; do
    has_skill "$target" || error "$workflow_file links missing skill /$target"
  done < <(rg -o '`/[a-z][a-z0-9-]+' "$workflow_file" | sed 's#^`/##' | sort -u)
done < <(find "$root/skills" "$root/workflow" -name SKILL.md -type f | sort)

printf 'Checked %s skills, %s commands, %s errors, %s warnings.\n' \
  "$(wc -l <"$skill_names" | tr -d ' ')" "$(find "$root/commands" -name '*.md' -type f | wc -l | tr -d ' ')" "$errors" "$warnings"
[ "$errors" -eq 0 ]
