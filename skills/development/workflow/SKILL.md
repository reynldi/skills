---
name: workflow
description: Orchestrate the full feature delivery pipeline — Planning (/plan-product-spec → /plan-technical-spec → /plan-contract-spec → /plan-verification → /plan-ready) → Implement (/plan-implement) → Review (/impl-review) → QA (/qa-test) — with approval gates, resume, per-feature memory, and optional multi-model delegation (claude/codex/gemini/opencode/pi via handoff briefs). Use when the user wants to build a feature end-to-end or invokes /workflow.
---

# Workflow

End-to-end feature delivery coordinator. Each stage is its own skill and also runs standalone; this skill sequences them, enforces gates, maintains the feature's memory, and can delegate stages to other models. Design principles: file-based state over hidden state (any agent can pick up from disk), everything observable (briefs and logs on disk), minimal machinery.

## Stages

| # | Phase     | Skill               | Artifact                 | Gate                                                 |
| - | --------- | ------------------- | ------------------------ | ---------------------------------------------------- |
| 0 | Discover  | (below)             | memory.md                | —                                                    |
| 1 | Planning  | plan-product-spec   | product-spec.md          | user approval                                        |
| 2 | Planning  | plan-technical-spec | technical-spec.md        | user approval                                        |
| 3 | Planning  | plan-contract-spec  | contract-spec.md         | user approval (one-paragraph file when no contracts) |
| 4 | Planning  | plan-verification   | verification.md          | PASS or PASS_WITH_NOTES, zero open Blocking/High     |
| 5 | Planning  | plan-ready          | tasks.md                 | PASS + user approval                                 |
| 6 | Implement | plan-implement      | implementation-report.md | all tasks PASS, regression green, git clean          |
| 7 | Review    | impl-review         | review-report.md         | PASS, zero open Blocking/High                        |
| 8 | QA        | qa-test             | qa-report.md             | PASS + user sign-off                                 |

All artifacts live in one feature folder — stage 1 resolves it per /plan-product-spec's feature-folder rule.

## Stage 0: Discover the project

Once per feature, before stage 1: read README / CLAUDE.md / AGENTS.md / contributing docs; identify the stack and build/test/run commands; find the spec/docs folder convention; list available project skills, reviewer agents, and installed providers (`bin/agent.sh list`); note the commit policy. Write the findings into `{feature}/memory.md` (template: `templates/memory.md`; if it already exists — e.g. created by /product-workflow — append under a new heading, never recreate). If the folder contains an APPROVED `prd.md`, note it: it is stage 1's primary input. Summarize findings to the user in a few lines, then start.

## Memory & context management

- `memory.md` in the feature folder is the shared working memory: project facts, decisions (+why), tried-and-failed, open questions, delegation log. Stage 0 creates it; every stage — local or delegated — appends. Append-only; strike through superseded entries.
- Artifacts carry state between stages; memory.md carries state *across agents and sessions*. Never rely on chat history for anything a later stage or another model will need.
- Context hygiene: point to files, don't paste them; burn exploration tokens in subagents/delegates and keep only distilled summaries (~1-2k tokens) in the coordinator; when this session's context grows stale or heavy, the feature folder + memory.md is the re-entry point — resume works from disk alone.

## Multi-model delegation

Any stage can run inline (Skill tool, default) or be delegated to another model via `bin/agent.sh`. Delegates are fresh processes that know only the repo and the brief — never assume shared context.

**When to delegate**: cross-model review/QA (a different model family than the implementer catches what self-review misses), heavy or parallel implementation (one delegate per `[P]` story, each in its own git worktree), second opinions on verification, or when the user names a model. Planning and coordination default to inline.

**Sizing rule** — the handoff cost is fixed (brief + delegate re-discovery + verification); the work's cost scales with the task. Small (≤ ~3 files, no new architecture) or subtle (concurrency, tricky invariants) → implement inline in the coordinator's session even on a frontier model: delegation would cost more in re-discovery than the whole task, and subtle intent is what handoffs lose. Large or mechanical (bulk edits, boilerplate, parallel `[P]` stories) → delegate down to the cheaper implementer with the approved plan/tasks as the brief. Coordinator context past ~60% is a delegation trigger regardless of size. Cross-provider fresh eyes justify delegating review, never implementation.

**Protocol** — for every delegation:

1. **Brief**: write `{feature}/handoff/{NNN}-{stage}-{provider}.md` from `templates/handoff.md`. Self-contained (mission with scope directives, process pointer to the stage SKILL.md, read-first list, decisions, tried-and-failed, constraints, definition of done, report-back format). Pointers, not pasted content.
2. **Run**: prefer the orchestrator's runner when installed — `workflow/orchestrator/bin/handoff.sh --brief <handoff-file> --provider <provider>[/<model>] --role <stage-role> [--effort <level>] [--dir <workdir>]` — it wraps `agent.sh` (identical behavior, `AGENT_RESUME`/`AGENT_YOLO` pass through) and adds a delegation summary (agent, role, provider/model, effort, session ID, status) plus `<brief>.summary.json`. Fall back to `bin/agent.sh <provider>[/<model>] <handoff-file> [workdir]` when the orchestrator isn't present. Output streams back; the full log lands beside the brief. Guarded defaults; `AGENT_YOLO=1` only inside an isolated worktree.
3. **Verify** — never trust the report: the artifact exists with its Status set, the stage gate criteria hold, spot-check the diff. Reject → append the findings to the brief and re-run, or take over inline. A delegated stage passes its gate the same way an inline one does.
4. **Record**: one line in memory.md's delegation log (handoff, provider, outcome); when handoff.sh ran, copy the essentials from `<brief>.summary.json` (provider/model, session ID, duration, status).

Every brief must carry an objective, an output format, the tools/commands to use, and explicit task boundaries — vague delegation produces overlap and gaps.

When several delegates share one tree, the coordinator serializes tree-wide gates — code generation and the full-suite verification run happen once, after all delegates are idle, never per-delegate in parallel.

**Agent reuse & rotation** — applies to in-session subagents and CLI delegates alike. Iterating on the same stage or artifact (revisions, gate rejections, follow-ups) continues the SAME agent: message the existing subagent by name (name stage agents, e.g. `stage1-product-spec`, so they stay addressable) or re-run the delegate with `AGENT_RESUME=1` (claude `-c`, codex `exec resume --last`, opencode `-c`, pi `-c`). Spawn a fresh agent only when: (a) the current agent's context is ~75% used, (b) the work moves to a different stage or scope, or (c) fresh eyes are the point (cross-model review, adversarial verification). When rotating at the 75% mark, have the outgoing agent append its state to memory.md first, then brief the successor from disk.

**Escalation via /orchestrator** (when installed) — the pipeline's answer for non-convergence:

- A gate cycle (implement ↔ review, or repeated verification FAIL) that hasn't converged after ~3 rounds → invoke the `orchestrator` skill's **committee** pattern with the full history (briefs, findings, what was tried); implement its merged plan, then resume the pipeline at the failed gate.
- Before an expensive or contested gate decision, a **advisor** second opinion (different model family) is cheap insurance.
- Grindy retry-until-verified work — driving the regression suite green during implement, babysitting CI after review fixes — fits the orchestrator's **loop** (`workflow/orchestrator/bin/loop.sh`, or `paseo loop run` when paseo is up) instead of the coordinator iterating by hand.

## Configuration: `.spectrum.json`

Optional project-root config tuning this pipeline and the product pipeline (/product-workflow). Read it in Stage 0; missing file → the built-in defaults (everything inline, reuse at 75%). Example: `templates/spectrum.json`. The coordinator resolves it itself — no script parses it; unknown keys are ignored; explicit user instructions override the file.

- **Roles & stages** — `roles.{name}`: `provider` (claude|codex|gemini|opencode|pi), `model` (provider-native), `effort` (low|medium|high), `run` (inline|delegate), `fresh` (never reuse). `stages.{skill-name}` maps each stage to a role; resolution = stage → role → merged over `defaults`. `run: inline` → this session or a named subagent with that model/effort; `run: delegate` → `bin/agent.sh {provider}/{model} {handoff}`. Precedence: a non-claude provider always delegates via agent.sh, overriding `run: inline`; a stage missing from `stages` uses `defaults`. Effort maps best-effort per provider (claude natively, pi via `:level` suffix, others ignore).
- **Reuse** — `reuse.policy` (reuse|always-new), `reuse.rotateAtContextPct` (default 75), `reuse.alwaysFresh` (roles that never reuse — keep reviewer/qa there). This parameterizes the Agent reuse & rotation rule above.
- **Memory** — `memory.featureMemory` (filename in the feature folder, default `memory.md`), `memory.handoffDir` (default `handoff`), `memory.globalMemory` (optional path for durable cross-feature learnings — append non-feature-specific facts there too).
- **Artifacts** — `artifacts.specsRoot` overrides the fallback feature-folder root (default `specs`).
- **Delegation** — `delegation.yolo: true` → run agent.sh with `AGENT_YOLO=1` (isolated worktrees only).

## Rules

- Run stages in order via the Skill tool. Never skip a gate. User-approval gates are hard stops — present the artifact summary and wait; do not proceed on your own. On approval, the stage records it in the artifact (Status APPROVED / User approval / Sign-off).
- Pass Stage 0 findings (via memory.md) into each stage; the stages' own discovery steps exist for standalone runs and should only fill gaps, not repeat reads.
- **Resume**: given an existing feature folder, read memory.md and each artifact's Status line; continue from the first missing / DRAFT / FAIL artifact — or the first whose approval line is still pending (`tasks.md` User approval, `qa-report.md` Sign-off). Confirm the resume point with the user before continuing.
- **Loop-backs**: verification FAIL → fix the specs at the owning stage, re-run /plan-verification. Review or QA FAIL → fix via /plan-implement (its scope control decides what returns to planning), then re-run the failed stage. Artifacts update in place — paths stay stable.
- **Scope changes mid-flow**: update the owning spec first, re-verify, then continue — never patch downstream artifacts only. If the change alters an upstream `prd.md`'s problem, outcome metric, appetite, or non-goals, stop and route to /product-workflow (P5 or earlier) before touching dev specs.
- Keep the user oriented: one short status line per stage transition (`{stage}: {status} → {next}`), plus provider/model when delegated.
