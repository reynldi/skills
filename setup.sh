#!/usr/bin/env bash
# setup.sh — install the skills in this repo for one or more agent CLIs,
# globally or per-project.
#
# Usage:
#   ./setup.sh --global  [--agents claude,codex,gemini,opencode,pi]
#   ./setup.sh --project <dir> [--agents ...]
#
# What it does:
#   1. Copies every skill (skills/*/<name>/ containing SKILL.md) into the
#      canonical skills dir — global: ~/.claude/skills, project: <dir>/.claude/skills.
#      Skills are plain markdown, so every agent reads them from there.
#   2. Per agent wiring:
#        claude    slash commands  -> ~/.claude/commands | <dir>/.claude/commands
#        codex     pointer block   -> ~/.codex/AGENTS.md | <dir>/AGENTS.md
#        gemini    pointer block   -> ~/.gemini/GEMINI.md | <dir>/GEMINI.md
#        opencode  pointer block   -> ~/.config/opencode/AGENTS.md | <dir>/AGENTS.md
#        pi        pointer block   -> <dir>/AGENTS.md (project only)
#      Pointer blocks are idempotent (marker-delimited; re-running replaces them).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
MARK_START='<!-- rnd-skills:start -->'
MARK_END='<!-- rnd-skills:end -->'

usage() {
  sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

scope="" dir="" agents="claude,codex,gemini,opencode,pi"
while [ $# -gt 0 ]; do
  case "$1" in
    --global) scope=global ;;
    --project) scope=project; dir="${2:?--project needs a directory}"; shift ;;
    --agents) agents="${2:?--agents needs a list}"; shift ;;
    *) usage ;;
  esac
  shift
done
[ -n "$scope" ] || usage
if [ "$scope" = project ]; then
  [ -d "$dir" ] || { echo "no such directory: $dir" >&2; exit 2; }
  dir="$(cd "$dir" && pwd)"
fi

if [ "$scope" = global ]; then skills_dst="$HOME/.claude/skills"; else skills_dst="$dir/.claude/skills"; fi

# 1. Copy all skills (flatten category level: skills/<category>/<name> -> <dst>/<name>)
mkdir -p "$skills_dst"
count=0
for s in "$ROOT"/skills/*/*/; do
  [ -f "$s/SKILL.md" ] || continue
  name="$(basename "$s")"
  rm -rf "${skills_dst:?}/$name"
  cp -R "$s" "$skills_dst/$name"
  count=$((count + 1))
done
find "$skills_dst" -name '*.sh' -exec chmod +x {} +
echo "skills: $count installed -> $skills_dst"

# 2. Pointer block for non-claude agents
block="$MARK_START
## Skills

Reusable skills live in \`$skills_dst\` — one folder per skill, entry point \`SKILL.md\`.
When a task matches a skill, read its \`SKILL.md\` and follow it exactly.

Flagship: the feature delivery pipeline. Read \`$skills_dst/workflow/SKILL.md\` first —
it coordinates plan-product-spec -> plan-technical-spec -> plan-contract-spec ->
plan-verification -> plan-ready -> plan-implement -> impl-review -> qa-test,
with approval gates, per-feature memory, and multi-model delegation.
$MARK_END"

upsert() { # $1 = file
  local f="$1" tmp
  mkdir -p "$(dirname "$f")"
  touch "$f"
  tmp="$(mktemp)"
  awk -v s="$MARK_START" -v e="$MARK_END" 'index($0,s){skip=1} index($0,e){skip=0; next} !skip{print}' "$f" >"$tmp"
  printf '\n%s\n' "$block" >>"$tmp"
  mv "$tmp" "$f"
  echo "pointer:  $f"
}

case ",$agents," in *,claude,*)
  if [ "$scope" = global ]; then cmd_dst="$HOME/.claude/commands"; else cmd_dst="$dir/.claude/commands"; fi
  mkdir -p "$cmd_dst"
  cp "$ROOT"/commands/*.md "$cmd_dst/"
  echo "claude:   commands -> $cmd_dst"
esac
case ",$agents," in *,codex,*)
  if [ "$scope" = global ]; then upsert "$HOME/.codex/AGENTS.md"; else upsert "$dir/AGENTS.md"; fi
esac
case ",$agents," in *,gemini,*)
  if [ "$scope" = global ]; then upsert "$HOME/.gemini/GEMINI.md"; else upsert "$dir/GEMINI.md"; fi
esac
case ",$agents," in *,opencode,*)
  if [ "$scope" = global ]; then upsert "$HOME/.config/opencode/AGENTS.md"; else upsert "$dir/AGENTS.md"; fi
esac
case ",$agents," in *,pi,*)
  if [ "$scope" = project ]; then upsert "$dir/AGENTS.md"; else echo "pi:       project-only (reads AGENTS.md); skipped for --global"; fi
esac

echo "done."
