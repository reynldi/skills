# Skills

A portable, repo-agnostic collection of agent skills. Skills are plain markdown (one folder per skill, entry point `SKILL.md`), so any coding agent that can read files can follow them — Claude Code loads them natively; Codex, Gemini CLI, OpenCode, and pi are wired via pointer blocks in their instruction files.

Two orchestrated pipelines share one initiative folder, one memory, and one config:

- **`/product-workflow`** — the product loop (de-risks *valuable* and *viable*): Discovery → Analysis → Validation → Prioritization → PRD → Metrics → build handoff → Measure → back to Discovery.
- **`/workflow`** — the delivery pipeline (de-risks *usable* and *feasible*): planning through implementation, review, and QA — with approval gates, per-feature memory, and multi-model delegation.

The seam: an APPROVED `prd.md` (problem + outcome, never a feature list) is what crosses from product to delivery.

## The product loop

| #  | Stage          | Skill / command           | Artifact      | Core models |
| -- | -------------- | ------------------------- | ------------- | ----------- |
| P1 | Discovery      | `/product-discovery`      | discovery.md  | Continuous Discovery + Opportunity Solution Tree (Torres), Mom Test, JTBD switch interviews |
| P2 | Analysis       | `/product-analysis`       | analysis.md   | competitor tiering, teardowns, review mining, win/loss, leading signals |
| P3 | Validation     | `/product-validation`     | validation.md | Assumptions Mapping (Bland), fake doors, prototype tests |
| P4 | Prioritization | `/product-prioritization` | priorities.md | opportunity scoring (ODI), evidence-cited RICE, Kano, Now-Next-Later |
| P5 | PRD            | `/product-prd`            | prd.md        | Lenny 1-pager / Shape Up pitch / Amazon PR-FAQ, by bet size |
| P6 | Metrics        | `/product-metrics`        | metrics.md    | North Star + inputs, Google HEART, leading/lagging, guardrails |

Business strategy (pricing, TAM, GTM, unit economics) is deliberately out of scope.

## The delivery pipeline

| # | Phase     | Skill / command       | Artifact                 | Gate                            |
| - | --------- | --------------------- | ------------------------ | ------------------------------- |
| 0 | Discover  | (workflow, inline)    | memory.md                | —                               |
| 1 | Planning  | `/plan-product-spec`  | product-spec.md          | user approval                   |
| 2 | Planning  | `/plan-technical-spec`| technical-spec.md        | user approval                   |
| 3 | Planning  | `/plan-contract-spec` | contract-spec.md         | user approval                   |
| 4 | Planning  | `/plan-verification`  | verification.md          | PASS or PASS_WITH_NOTES, no open Blocking/High |
| 5 | Planning  | `/plan-ready`         | tasks.md                 | PASS + user approval            |
| 6 | Implement | `/plan-implement`     | implementation-report.md | all tasks PASS, regression green, git clean |
| 7 | Review    | `/impl-review`        | review-report.md         | PASS, no open Blocking/High     |
| 8 | QA        | `/qa-test`            | qa-report.md             | PASS + user sign-off            |

`/workflow` orchestrates all of it: run `/workflow <feature idea>` for a full run, or any stage standalone. All artifacts live in one feature folder (discovered from the project's spec convention; fallback `specs/{feature-name}/`), each ending in a machine-readable Status line — resume works from disk alone, no chat history needed.

## Install

```sh
./setup.sh --global                          # all agents, user-wide
./setup.sh --project ~/code/myrepo           # all agents, one repo
./setup.sh --global --agents claude,codex    # subset
```

| Agent    | Skills (copied)                     | Wiring                                          |
| -------- | ----------------------------------- | ----------------------------------------------- |
| claude   | `~/.claude/skills` or `<dir>/.claude/skills` | slash commands into `commands/` (native)  |
| codex    | same copy                           | pointer block in `~/.codex/AGENTS.md` / `<dir>/AGENTS.md` |
| gemini   | same copy                           | pointer block in `~/.gemini/GEMINI.md` / `<dir>/GEMINI.md` |
| opencode | same copy                           | pointer block in `~/.config/opencode/AGENTS.md` / `<dir>/AGENTS.md` |
| pi       | same copy                           | pointer block in `<dir>/AGENTS.md` (project only) |

Pointer blocks are marker-delimited and idempotent — re-run `setup.sh` after updating skills.

## Configuration: `.spectrum.json`

One optional project-root file configures both pipelines (example: `skills/development/workflow/templates/spectrum.json`; semantics: the workflow skill's Configuration section):

- **Roles & stages** — model, provider, effort, and inline-vs-delegate per role (`coordinator`, `planner`, `implementer`, `reviewer`, `qa`, `researcher`); `stages` maps every pipeline stage to a role.
- **Reuse** — `policy`, `rotateAtContextPct` (default 75), `alwaysFresh` roles (reviewer/qa keep fresh eyes).
- **Memory** — feature memory filename, handoff dir, optional cross-feature `globalMemory` path.
- **Artifacts / delegation** — specs root override; `yolo` for isolated worktrees.

The coordinator resolves the config itself — no scripts parse it; user instructions always win over the file.

## Multi-model delegation

The workflow coordinator can hand any stage to another model with a fresh process and zero shared context:

```sh
skills/development/workflow/bin/agent.sh list                       # show installed providers
skills/development/workflow/bin/agent.sh codex/gpt-5.1-codex \
    specs/my-feature/handoff/001-impl-review-codex.md               # run one delegation
```

- **Handoff briefs** (`workflow/templates/handoff.md`): self-contained — mission with scope directives, process pointer, read-first list, decisions made, tried-and-failed, constraints, definition of done, report-back format. Pointers to files, never pasted content.
- **Memory** (`workflow/templates/memory.md`): per-feature append-only log — project facts, decisions + why, failed attempts, delegation log. Every agent (any model) reads and appends it.
- **Trust nothing**: the coordinator verifies the artifact, gate, and diff before accepting a delegate's work. Full run logs land beside each brief.
- **Reuse agents**: iterating on the same stage continues the same agent — `AGENT_RESUME=1 agent.sh …` resumes the provider's last session (claude/codex/opencode/pi). Spawn fresh only at ~75% context use, on a stage change, or when fresh eyes are the point.
- Guarded defaults (sandbox / edit-only approval); `AGENT_YOLO=1` removes guardrails — only inside an isolated worktree or container.

## Principles

- Product Spec defines behavior; project conventions define implementation style; specs are the source of truth during implementation.
- Repo-agnostic: discovering the project (stack, commands, conventions, spec layout) is part of every skill — nothing is hardcoded.
- File-based state over hidden state; everything observable (briefs, logs, artifacts on disk).
- Challenge complexity: current requirements beat hypothetical future needs; prefer extending existing patterns over new abstractions.
- Every gate is real: no tasks while Blocking/High findings are open, no dependent task before reviewer PASS, no continuing past a dirty checkpoint.

## Layout

```
skills/
  development/    delivery pipeline (plan-*, impl-review, qa-test, workflow) + others
  product/        product loop (product-discovery … product-workflow)
  general/        general skills
commands/         Claude Code slash commands (thin pointers to skills)
setup.sh          multi-agent installer (global or per-project)
```

Each skill keeps its output templates in `templates/` (read only at write time — keeps every invocation cheap); the workflow skill also ships `bin/agent.sh`.
