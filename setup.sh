#!/usr/bin/env bash
# setup.sh — install the skills in this repo for one or more agent CLIs,
# globally or per-project.
#
# Usage:
#   ./setup.sh                                  # interactive: asks scope + skills dir
#   ./setup.sh --global  [--agents claude,codex,gemini,opencode,pi]
#   ./setup.sh --project <dir> [--agents ...]
#   ./setup.sh ... [--skills-dir .claude|.agents|<custom>]
#   ./setup.sh ... [--spectrum | --no-spectrum]
#
# What it does:
#   1. Asks where to install when not told: global (user-wide) or init in a
#      project, and which dot-dir convention holds the skills (.claude default,
#      .agents, or custom).
#   2. Copies every skill (skills/*/<name>/ and workflow/<name>/ containing
#      SKILL.md) into <base>/<skills-dir>/skills.
#   3. Per agent wiring:
#        claude    slash commands  -> ~/.claude/commands | <dir>/.claude/commands
#        codex     pointer block   -> ~/.codex/AGENTS.md | <dir>/AGENTS.md
#        gemini    pointer block   -> ~/.gemini/GEMINI.md | <dir>/GEMINI.md
#        opencode  pointer block   -> ~/.config/opencode/AGENTS.md | <dir>/AGENTS.md
#        pi        pointer block   -> <dir>/AGENTS.md (project only)
#      Pointer blocks are idempotent (marker-delimited; re-running replaces them).
#   4. Offers to init .spectrum.json (per-role provider/model/effort) via a
#      step-by-step wizard: configure a role, then continue with another role
#      or finish. Prompts on /dev/tty (works under curl|bash); --spectrum
#      forces the wizard, --no-spectrum skips it.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
MARK_START='<!-- rnd-skills:start -->'
MARK_END='<!-- rnd-skills:end -->'

bash "$ROOT/scripts/validate-skills.sh"

usage() {
  sed -n '2,29p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

scope="" dir="" agents="claude,codex,gemini,opencode,pi" spectrum_mode=ask skills_base=""
while [ $# -gt 0 ]; do
  case "$1" in
    --global) scope=global ;;
    --project) scope=project; dir="${2:?--project needs a directory}"; shift ;;
    --agents) agents="${2:?--agents needs a list}"; shift ;;
    --skills-dir) skills_base="${2:?--skills-dir needs a directory name}"; shift ;;
    --spectrum) spectrum_mode=yes ;;
    --no-spectrum) spectrum_mode=no ;;
    *) usage ;;
  esac
  shift
done

# --- interactive layer: prefer the real terminal; fall back to piped stdin ---
interactive=0 GOT_EOF=0
if (exec 3</dev/tty) 2>/dev/null; then
  exec 3</dev/tty; interactive=1
elif [ ! -t 0 ]; then
  exec 3<&0; interactive=1          # piped answers (tests, scripting); EOF -> defaults
fi

ask() { # ask VAR "prompt" "default" -> sets $VAR; sets GOT_EOF=1 on end of input
  local _var="$1" _ans
  printf '%s' "$2" >&2
  if ! IFS= read -r _ans <&3; then _ans=""; GOT_EOF=1; fi
  [ -n "$_ans" ] || _ans="$3"
  eval "$_var=\$_ans"
}

lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

# --- scope: flag, or ask, or usage ---
if [ -z "$scope" ]; then
  [ "$interactive" = 1 ] || usage
  echo "Install where?"
  echo "  1) global  — user-wide, for every project"
  echo "  2) project — init inside one project directory"
  ask sc "Choose [1]: " 1
  [ "$GOT_EOF" = 1 ] && usage        # headless with no scope: keep the old error
  case "$sc" in
    1|g|global) scope=global ;;
    2|p|project)
      scope=project
      ask dir "Project directory [$PWD]: " "$PWD"
      ;;
    *) echo "unknown choice: $sc" >&2; exit 2 ;;
  esac
fi
if [ "$scope" = project ]; then
  [ -d "$dir" ] || { echo "no such directory: $dir" >&2; exit 2; }
  dir="$(cd "$dir" && pwd)"
fi

# --- skills dir convention: flag, or ask, default .claude ---
if [ -z "$skills_base" ]; then
  if [ "$interactive" = 1 ] && [ "$GOT_EOF" = 0 ]; then
    echo "Skills directory convention?"
    echo "  1) .claude — default; Claude Code loads it natively"
    echo "  2) .agents — neutral convention (agents find it via pointer blocks)"
    ask sb "Choose, or type a custom dot-dir [1]: " 1
    case "$sb" in
      1|.claude) skills_base=.claude ;;
      2|.agents) skills_base=.agents ;;
      *) skills_base="${sb%/}" ;;
    esac
  else
    skills_base=.claude
  fi
fi
if [ "$scope" = global ]; then base="$HOME"; else base="$dir"; fi
skills_dst="$base/$skills_base/skills"
[ "$skills_base" = .claude ] || echo "note: outside .claude, Claude Code won't auto-load skills — agents reach them via the pointer blocks"

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

Default output style: follow \`$skills_dst/simplified-english/SKILL.md\` for every
user-facing response and document unless the user explicitly requests another style.

Flagship: the feature delivery pipeline. Read \`$skills_dst/development-workflow/SKILL.md\` first —
it coordinates plan-product-spec -> plan-technical-spec -> plan-contract-spec ->
plan-verification -> plan-ready -> plan-implement -> impl-review -> qa-test,
with approval gates, per-feature memory, and multi-model delegation.

Delegation to other agents (advisor / committee / handoff / loop) goes through the
global orchestrator: \`$skills_dst/orchestrator/SKILL.md\` (helpers in its \`bin/\`).

Role personas (compass, forge, prism, gauntlet, bastion, atlas) live in
\`$skills_dst/personas/\` — when asked to act as one (e.g. "@bastion"), read its
file under \`roles/\` and adopt it.
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
  if [ "$scope" = global ]; then upsert "$HOME/.claude/CLAUDE.md"; else upsert "$dir/CLAUDE.md"; fi
  # persona subagents: one .claude/agents/<name>.md per persona, so "@bastion"
  # / "use the bastion agent" resolves natively in Claude Code
  if [ -d "$skills_dst/personas/roles" ]; then
    if [ "$scope" = global ]; then agents_dst="$HOME/.claude/agents"; else agents_dst="$dir/.claude/agents"; fi
    mkdir -p "$agents_dst"
    pcount=0
    for pf in "$skills_dst/personas/roles"/*.md; do
      [ -f "$pf" ] || continue
      pname="$(basename "$pf" .md)"
      ptitle="$(head -1 "$pf" | sed 's/^# *//')"
      {
        printf -- '---\nname: %s\ndescription: %s persona. Use PROACTIVELY when a task belongs to this role, or when the user says @%s or "as %s".\n---\n\n' "$pname" "$ptitle" "$pname" "$pname"
        printf 'You are %s. Adopt this persona completely — its job, principles, vetoes, and thinking levels:\n\n' "$ptitle"
        cat "$pf"
        printf '\nOperate at the thinking level named in your task (L1–L4). If none is named, read the "personas" block of .spectrum.json in the project root; default L2. Vetoes hold at every level.\n'
      } > "$agents_dst/$pname.md"
      pcount=$((pcount + 1))
    done
    echo "claude:   $pcount persona subagents -> $agents_dst"
  fi
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

role_of() { # $1 = selection token -> echoes role name or nothing
  case "$1" in
    1|planner) echo planner ;; 2|implementer) echo implementer ;; 3|reviewer) echo reviewer ;;
    4|qa) echo qa ;; 5|researcher) echo researcher ;; 6|coordinator) echo coordinator ;;
  esac
}

num_of() { # $1 = role name -> its menu number
  case "$1" in
    planner) echo 1 ;; implementer) echo 2 ;; reviewer) echo 3 ;;
    qa) echo 4 ;; researcher) echo 5 ;; coordinator) echo 6 ;;
  esac
}

configure_role() { # $1 = role name; edits p_/m_/e_ vars
  local r="$1" dp dm de pv mv ev
  eval "dp=\$p_$r; dm=\$m_$r; de=\$e_$r"
  echo "— $r —"
  ask pv "  provider (claude|codex|gemini|opencode|pi) [$dp]: " "$dp"
  case "$pv" in claude|codex|gemini|opencode|pi) ;; *) echo "  note: '$pv' is not a known provider; keeping it as written" ;; esac
  ask mv "  model (empty = provider default) [${dm:-provider default}]: " "$dm"
  ask ev "  effort (low|medium|high) [$de]: " "$de"
  case "$ev" in low|medium|high) ;; *) echo "  invalid effort '$ev' — using $de"; ev="$de" ;; esac
  eval "p_$r=\$pv; m_$r=\$mv; e_$r=\$ev; done_$r=1"
  echo "  + $r configured ($pv${mv:+/$mv}, effort $ev)"
}

if [ "$interactive" = 1 ] && [ "$spectrum_mode" != no ]; then
  wantit=y
  if [ "$spectrum_mode" = ask ]; then
    ask wantit "Init $spectrum_file — per-role provider/model/effort for the pipelines? [y/N] " n
  fi
  case "$(lower "$wantit")" in y|yes) ;; *) wantit=n ;; esac
  if [ "$wantit" != n ] && [ -f "$spectrum_file" ]; then
    ask ow ".spectrum.json exists — overwrite? [y/N] " n
    case "$(lower "$ow")" in y|yes) ;; *) wantit=n; echo "spectrum: kept existing $spectrum_file" ;; esac
  fi

  if [ "$wantit" != n ]; then
    # role defaults (mirror templates/spectrum.json)
    for r in coordinator researcher planner implementer reviewer qa; do
      eval "p_$r=claude m_$r= e_$r=medium done_$r=0"
    done
    p_reviewer=codex; e_planner=high; e_reviewer=high

    echo ""
    echo "Step 1 — your workflow (pick a role to set up; you can add more after each one)"
    echo "  1) planner      — Plan: product/technical/contract specs, PRD, tasks"
    echo "  2) implementer  — Implement: code, per-task commits"
    echo "  3) reviewer     — Review: spec verification, implementation review"
    echo "  4) qa           — QA: test plan + execution"
    echo "  5) researcher   — Research: discovery, analysis, validation"
    echo "  6) coordinator  — pipeline coordination (usually this session)"
    ask sel "Start with (numbers, Enter = 1): " 1

    echo ""
    echo "Step 2 — provider, model, effort per role (Enter keeps the default)"
    while :; do
      for n in $(printf '%s' "$sel" | tr ',' ' '); do
        r="$(role_of "$n")"
        [ -n "$r" ] || { echo "  (unknown selection: $n — skipped)"; continue; }
        if eval "[ \"\$done_$r\" = 1 ]"; then echo "  ($r already configured — skipped)"; continue; fi
        configure_role "$r"
      done
      # offer the remaining roles, or finish
      remaining=""
      for r in planner implementer reviewer qa researcher coordinator; do
        eval "d=\$done_$r"
        [ "$d" = 1 ] || remaining="$remaining $(num_of "$r")) $r "
      done
      [ -n "$remaining" ] || { echo "All roles configured."; break; }
      ask sel "Continue with another role — ${remaining# } — or Enter to finish: " ""
      [ -n "$sel" ] || break
    done
    echo "(unconfigured roles keep the template defaults)"

    echo ""
    echo "Step 3 — other settings"
    ask rotate "  Rotate an agent when its context reaches N% [75]: " 75
    case "$rotate" in ''|*[!0-9]*) echo "  invalid number — using 75"; rotate=75 ;; esac
    ask specs "  Specs root directory [specs]: " specs
    ask yolo_ans "  Unguarded delegates (yolo — isolated worktrees only)? [y/N] " n
    case "$(lower "$yolo_ans")" in y|yes) yolo=true ;; *) yolo=false ;; esac

    # persona thinking levels (L1 pragmatic .. L4 perfection at scale)
    l_compass=L2 l_forge=L2 l_prism=L2 l_gauntlet=L3 l_bastion=L3 l_atlas=L2
    echo "  Persona thinking levels — defaults: compass L2, forge L2, prism L2, gauntlet L3, bastion L3, atlas L2"
    ask plv "  Overrides like 'forge=L3 bastion=L4' (Enter = defaults): " ""
    for pair in $plv; do
      pname="${pair%%=*}"; plevel="${pair#*=}"
      case "$plevel" in L1|L2|L3|L4|l1|l2|l3|l4) plevel="$(printf '%s' "$plevel" | tr 'l' 'L')" ;; *) echo "  invalid level in '$pair' — skipped"; continue ;; esac
      case "$pname" in compass|forge|prism|gauntlet|bastion|atlas) eval "l_$pname=\$plevel" ;; *) echo "  unknown persona in '$pair' — skipped" ;; esac
    done

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
  "personas": {
    "compass": "$l_compass", "forge": "$l_forge", "prism": "$l_prism",
    "gauntlet": "$l_gauntlet", "bastion": "$l_bastion", "atlas": "$l_atlas"
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
  echo "spectrum: no TTY — skipped .spectrum.json wizard (re-run with --spectrum, or copy skills/development/development-workflow/templates/spectrum.json)"
fi

echo "done."
