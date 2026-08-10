# Handoff: {stage or task title}

<!-- Self-contained brief for an agent with ZERO prior context (a fresh process, possibly a different model). Point to files with a why-relevant note; NEVER paste file contents. Every section stays — write "none" rather than deleting. -->

## Mission

{One paragraph: the objective, with explicit imperative scope directives — e.g. "implement tasks T012-T015 only", "DO NOT edit files outside {area}", "refactor, do not rewrite", "investigation only — no edits".}

## Process to follow

You are executing stage {N} ({stage name}) of a feature pipeline. Follow the process in `{repo-relative path to the stage's SKILL.md}` exactly, including its output template and gate.

## Read first (in this order)

1. `{feature-folder}/memory.md` — decision log and project facts; do not relitigate anything recorded there
2. `{artifact path}` — {why relevant}
3. `{source file}:{lines}` — {why relevant}

## Context

{Why this task exists; key domain facts not derivable from the files above.}

## Decisions already made (do not relitigate)

- {decision — rationale}

## Tried & failed (do not repeat)

- {approach → why it failed}

## Constraints

- {out-of-scope boundaries}
- Commands: build `{cmd}` · test `{cmd}` · run `{cmd}`
- {project conventions that apply}

## Definition of done

- {observable acceptance criteria}
- Write/update `{artifact path}` with its Status footer set correctly
- Append your decisions and discovered facts to `{feature-folder}/memory.md` under a `### {stage} ({provider})` heading

## Report back

End your run with a summary of at most 300 words: Status (PASS / FAIL / BLOCKED — with reason), files changed, decisions made, open questions, suggested next step. Do not paste file contents into the summary.
