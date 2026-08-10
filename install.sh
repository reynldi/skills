#!/usr/bin/env bash
# install.sh — one-liner installer: fetches this repo and runs setup.sh.
#
#   curl -fsSL https://raw.githubusercontent.com/reynldi/skills/main/install.sh | bash
#   curl -fsSL .../install.sh | bash -s -- --agents claude,codex
#   curl -fsSL .../install.sh | bash -s -- --project ~/code/myrepo
#
# Defaults to --global when no scope is given. All arguments pass through to
# setup.sh — including --spectrum / --no-spectrum for the .spectrum.json wizard,
# which prompts on your terminal (/dev/tty) even under curl|bash and skips
# itself when headless. Override the source with RND_SKILLS_REPO (git URL or
# local path) and RND_SKILLS_REF (branch/tag, default main).
set -euo pipefail

REPO="${RND_SKILLS_REPO:-https://github.com/reynldi/skills}"
REF="${RND_SKILLS_REF:-main}"

# No scope given: let setup.sh ask interactively when a terminal is present;
# default to --global only when headless.
args=("$@")
case " $* " in
  *" --global "*|*" --project "*) ;;
  *) (exec 3</dev/tty) 2>/dev/null || args=(--global "$@") ;;
esac

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "fetching $REPO@$REF ..."
if command -v git >/dev/null 2>&1; then
  git clone --quiet --depth 1 --branch "$REF" "$REPO" "$tmp/skills"
else
  curl -fsSL "${REPO}/tarball/${REF}" | tar -xz -C "$tmp"
  mv "$tmp"/*-skills-* "$tmp/skills" 2>/dev/null || mv "$tmp"/* "$tmp/skills"
fi

bash "$tmp/skills/setup.sh" "${args[@]}"
