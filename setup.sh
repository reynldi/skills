#!/usr/bin/env bash
# setup.sh — install the skills in this repo for one or more agent CLIs,
# globally or per-project.
#
# Usage:
#   ./setup.sh --global  [--agents claude,codex,gemini,opencode,pi]
#   ./setup.sh --project <dir> [--agents ...]
#   ./setup.sh ... [--spectrum | --no-spectrum]
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
#   3. Offers to init .spectrum.json (per-role provider/model/effort for the
#      pipelines) via an interactive wizard. Needs a TTY (works under curl|bash);
#      --spectrum forces the wizard (reads stdin if no TTY), --no-spectrum skips.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
MARK_START='<!-- rnd-skills:start -->'
MARK_END='<!-- rnd-skills:end -->'

usage() {
  sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

scope="" dir="" agents="claude,codex,gemini,opencode,pi" spectrum_mode=ask
while [ $# -gt 0 ]; do
  case "$1" in
    --global) scope=global ;;
    --project) scope=project; dir="${2:?--project needs a directory}"; shift ;;
    --agents) agents="${2:?--agents needs a list}"; shift ;;
    --spectrum) spectrum_mode=yes ;;
    --no-spectrum) spectrum_mode=no ;;
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

# 1. Copy all skills (flatten category level: skills/<category>/<name> -> <dst>/<name>;
#    also root-level workflow/<name>, e.g. the orchestrator)
mkdir -p "$skills_dst"
count=0
for s in "$ROOT"/skills/*/*/ "$ROOT"/workflow/*/; do
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

Delegation to other agents (advisor / committee / handoff / loop) goes through the
global orchestrator: \`$skills_dst/orchestrator/SKILL.md\` (helpers in its \`bin/\`).
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

# 3. Optional: init .spectrum.json (interactive wizard)
if [ "$scope" = project ]; then spectrum_dir="$dir"; else spectrum_dir="$PWD"; fi
spectrum_file="$spectrum_dir/.spectrum.json"

interactive=0
if [ "$spectrum_mode" != no ]; then
  if (exec 3</dev/tty) 2>/dev/null; then
    exec 3</dev/tty; interactive=1
  elif [ "$spectrum_mode" = yes ]; then
    exec 3<&0; interactive=1        # forced: read answers from stdin (tests, scripting)
  fi
fi

ask() { # $1=prompt $2=default -> echoes answer or default
  local ans
  printf '%s' "$1" >&2
  IFS= read -r ans <&3 || ans=""
  [ -n "$ans" ] && printf '%s\n' "$ans" || printf '%s\n' "$2"
}

if [ "$interactive" = 1 ]; then
  wantit=y
  if [ "$spectrum_mode" = ask ]; then
    wantit="$(ask "Init $spectrum_file — per-role provider/model/effort for the pipelines? [y/N] " n)"
  fi
  case "$(printf '%s' "$wantit" | tr '[:upper:]' '[:lower:]')" in y|yes) ;; *) wantit=n ;; esac
  if [ "$wantit" != n ] && [ -f "$spectrum_file" ]; then
    ow="$(ask ".spectrum.json exists — overwrite? [y/N] " n)"
    case "$(printf '%s' "$ow" | tr '[:upper:]' '[:lower:]')" in y|yes) ;; *) wantit=n; echo "spectrum: kept existing $spectrum_file" ;; esac
  fi

  if [ "$wantit" != n ]; then
    # role defaults (mirror templates/spectrum.json)
    for r in coordinator researcher planner implementer reviewer qa; do
      eval "p_$r=claude m_$r= e_$r=medium"
    done
    p_reviewer=codex; e_planner=high; e_reviewer=high

    echo ""
    echo "Step 1 — your workflow (which roles to configure; the rest keep defaults)"
    echo "  1) planner      — Plan: product/technical/contract specs, PRD, tasks"
    echo "  2) implementer  — Implement: code, per-task commits"
    echo "  3) reviewer     — Review: spec verification, implementation review"
    echo "  4) qa           — QA: test plan + execution"
    echo "  5) researcher   — Research: discovery, analysis, validation"
    echo "  6) coordinator  — pipeline coordination (usually this session)"
    sel="$(ask "Roles to configure (numbers, Enter = 1 2 3 4): " "1 2 3 4")"
    sel="$(printf '%s' "$sel" | tr ',' ' ')"

    echo ""
    echo "Step 2 — provider, model, effort per role (Enter keeps the default)"
    for n in $sel; do
      case "$n" in
        1|planner) r=planner ;; 2|implementer) r=implementer ;; 3|reviewer) r=reviewer ;;
        4|qa) r=qa ;; 5|researcher) r=researcher ;; 6|coordinator) r=coordinator ;;
        *) echo "  (unknown selection: $n — skipped)"; continue ;;
      esac
      eval "dp=\$p_$r; dm=\$m_$r; de=\$e_$r"
      echo "— $r —"
      pv="$(ask "  provider (claude|codex|gemini|opencode|pi) [$dp]: " "$dp")"
      case "$pv" in claude|codex|gemini|opencode|pi) ;; *) echo "  note: '$pv' is not a known provider; keeping it as written" ;; esac
      mv="$(ask "  model (empty = provider default) [${dm:-provider default}]: " "$dm")"
      ev="$(ask "  effort (low|medium|high) [$de]: " "$de")"
      case "$ev" in low|medium|high) ;; *) echo "  invalid effort '$ev' — using $de"; ev="$de" ;; esac
      eval "p_$r=\$pv; m_$r=\$mv; e_$r=\$ev"
    done

    echo ""
    echo "Step 3 — other settings"
    rotate="$(ask "  Rotate an agent when its context reaches N% [75]: " 75)"
    case "$rotate" in ''|*[!0-9]*) echo "  invalid number — using 75"; rotate=75 ;; esac
    specs="$(ask "  Specs root directory [specs]: " specs)"
    yolo_ans="$(ask "  Unguarded delegates (yolo — isolated worktrees only)? [y/N] " n)"
    case "$(printf '%s' "$yolo_ans" | tr '[:upper:]' '[:lower:]')" in y|yes) yolo=true ;; *) yolo=false ;; esac

    cat > "$spectrum_file" <<JSON
{
  "version": 1,
  "defaults": { "provider": "claude", "model": "", "effort": "medium", "run": "inline" },
  "roles": {
    "coordinator": { "provider": "$p_coordinator", "model": "$m_coordinator", "effort": "$e_coordinator", "run": "inline" },
    "researcher": { "provider": "$p_researcher", "model": "$m_researcher", "effort": "$e_researcher" },
    "planner": { "provider": "$p_planner", "model": "$m_planner", "effort": "$e_planner" },
    "implementer": { "provider": "$p_implementer", "model": "$m_implementer", "effort": "$e_implementer" },
    "reviewer": { "provider": "$p_reviewer", "model": "$m_reviewer", "effort": "$e_reviewer", "fresh": true },
    "qa": { "provider": "$p_qa", "model": "$m_qa", "effort": "$e_qa", "fresh": true }
  },
  "stages": {
    "product-discovery": "researcher",
    "product-analysis": "researcher",
    "product-validation": "researcher",
    "product-prioritization": "planner",
    "product-prd": "planner",
    "product-metrics": "planner",
    "plan-product-spec": "planner",
    "plan-technical-spec": "planner",
    "plan-contract-spec": "planner",
    "plan-verification": "reviewer",
    "plan-ready": "planner",
    "plan-implement": "implementer",
    "impl-review": "reviewer",
    "qa-test": "qa"
  },
  "reuse": { "policy": "reuse", "rotateAtContextPct": $rotate, "alwaysFresh": ["reviewer", "qa"] },
  "memory": { "featureMemory": "memory.md", "handoffDir": "handoff", "globalMemory": "" },
  "artifacts": { "specsRoot": "$specs" },
  "delegation": { "yolo": $yolo }
}
JSON
    echo "spectrum: wrote $spectrum_file"
  fi
elif [ "$spectrum_mode" = ask ]; then
  echo "spectrum: no TTY — skipped .spectrum.json wizard (re-run with --spectrum, or copy skills/development/workflow/templates/spectrum.json)"
fi

echo "done."
