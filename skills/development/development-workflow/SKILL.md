---
name: development-workflow
description: Orchestrate the full feature delivery pipeline — Planning (/plan-product-spec → /plan-technical-spec → /plan-contract-spec → /plan-verification → /plan-ready) → Implement (/plan-implement) → Review (/impl-review) → QA (/qa-test) — with approval gates, resume, per-feature memory, and optional multi-model delegation (claude/codex/gemini/opencode/pi via handoff briefs). Use when the user wants to build a feature end-to-end or invokes /development-workflow.
---

# Development Workflow

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

## QA depth

Every change receives QA acceptance against its criteria. /plan-ready owns the QA-depth
decision (Focused, Feature, or Full — criteria live in its "Choose QA depth" section)
and records it in `tasks.md`. /qa-test reads and executes the recorded choice; when the
choice is Full, /qa-planning runs first and hands its test plan and reusable cases to
/qa-test.

## Artifact lifecycle

Every delivery artifact records: Lifecycle (ACTIVE, SUPERSEDED, or ARCHIVED), Owner,
Next consumer, and Review trigger. Keep its existing approval, PASS/FAIL, and sign-off
fields. Mark an artifact SUPERSEDED when a newer approved decision replaces it; do not
erase history. Review ACTIVE artifacts after a scope, contract, architecture, or test
evidence change. Archive only when the feature has closed and no future consumer remains.

## Stage 0: Discover the project

Once per feature, before stage 1: read README / CLAUDE.md / AGENTS.md / contributing docs; identify the stack and build/test/run commands; find the spec/docs folder convention; list available project skills, reviewer agents, and installed providers (`bin/agent.sh list`); note the commit policy. Write the findings into `{feature}/memory.md` (template: `templates/memory.md`; if it already exists — e.g. created by /product-workflow — append under a new heading, never recreate). If the folder contains an APPROVED `prd.md`, note it: it is stage 1's primary input. Summarize findings to the user in a few lines, then start.

## Memory & context management

- `memory.md` in the feature folder is the shared working memory: project facts, decisions (+why), tried-and-failed, open questions, delegation log. Stage 0 creates it; every stage — local or delegated — appends. Append-only; strike through superseded entries.
- Artifacts carry state between stages; memory.md carries state *across agents and sessions*. Never rely on chat history for anything a later stage or another model will need.
- Context hygiene: point to files, don't paste them; burn exploration tokens in subagents/delegates and keep only distilled summaries (~1-2k tokens) in the coordinator; when this session's context grows stale or heavy, the feature folder + memory.md is the re-entry point — resume works from disk alone.

## Risk and token budget

Classify the work before deep reading. The tier controls context depth and artifact
detail. It never bypasses an applicable approval, verification, review, or QA gate.

| Tier | Use when | Read and write |
| --- | --- | --- |
| Quick | Reversible, small, no public contract, data, money, permission, or reliability boundary | A context card; only the affected spec/task and tests; a concise decision record if a later stage needs it. |
| Standard | Normal feature work | The current stage inputs plus directly linked decisions; normal stage artifacts. |
| High-risk | Data migration, money, permissions, public contract, production reliability, security, or hard-to-reverse user impact | The relevant approved specs, contracts, risk owner input, rollout/rollback conditions, and explicit verification evidence. |

Use this protocol in every tier:

1. Build a context card: goal, tier, current decision, approved decisions, open
   questions, changed files, and next consumer.
2. Read the minimum artifacts named by the tier. Follow links only when they change
   the current decision. Summarize findings; never paste prior artifacts or code.
3. Create an artifact only when it records a decision, evidence, risk, or proof that
   a named later person, stage, or agent will consume. Otherwise update the context
   card or do not write it.
4. Keep ordinary output to decision, evidence, risks, and next owner. Expand only for
   ambiguity, conflict, a tier trigger, or a user request.
5. Raise the tier immediately when a listed High-risk boundary appears. State why,
   then load only the newly relevant context.

Quick-tier changes need no human approval when behavior is minor, reversible, and
unambiguous. Ask only when the change affects visible behavior, creates a material
trade-off, crosses a risk boundary, or the user requests confirmation. Explicit user
instructions override this default.

Use this progress narration when helpful: “I have the goal, approved decisions, and
open question. This is {tier}. I will read {minimum inputs}, produce {output}, and
raise the tier if {trigger} appears.”

## Transition rules

1. **Enter** at the earliest decision that can change the requested outcome. Quick
   work starts with a decision record and focused proof; Standard and High-risk work
   start with their relevant product or delivery artifact.
2. **Skip** an artifact only when its purpose does not apply: research with sufficient
   evidence, contracts without external changes, or technical planning for a minor,
   reversible change. Never skip proof for changed behavior.
3. **Resume** from the first decision that is missing, stale, failed, or lacks required
   approval. If implementation alone changed, resume at review or QA instead of
   rewriting unaffected planning artifacts.
4. **Escalate** immediately for data, money, permissions, public interfaces, security,
   production reliability, or irreversible user impact. Record the trigger, then load
   only newly relevant context.
5. **Loop back** to the owner of the changed decision: product behavior → Product Spec;
   architecture or reliability → Technical Spec; interface behavior → Contract Spec;
   failed proof with unchanged intent → implementation, review, or QA.

Explicit user instructions override these defaults. Applicable approval, verification,
review, and QA gates remain mandatory.

## Delegation

For delegation, independent review, non-convergence, or bounded retry work, use
`/orchestrator`. It owns pattern selection, briefing, isolation, verification, and
backend rules. This workflow supplies the current stage, artifact brief, and next gate.
Read `.spectrum.json` in Stage 0 when present; explicit user instructions win.

## Configuration: `.spectrum.json`

Optional project-root config for this pipeline and /product-workflow. Missing file →
built-in defaults (everything inline, reuse, rotate at 75% context). Example:
`templates/spectrum.json`. The coordinator resolves it itself — no script parses it;
unknown keys are ignored; explicit user instructions override the file.

- **Roles & stages** — `roles.{name}`: `provider` (claude|codex|gemini|opencode|pi),
  `model`, `effort` (low|medium|high), `run` (inline|delegate), `fresh` (never reuse).
  `stages.{skill-name}` maps a stage to a role; resolution = stage → role → merged over
  `defaults`. `run: inline` → this session or a named subagent; `run: delegate` →
  `bin/agent.sh {provider}/{model} {handoff}`. A non-claude provider always delegates
  via agent.sh, overriding `run: inline`; a stage missing from `stages` uses `defaults`.
- **Personas** — `personas.{name}`: default thinking level (L1–L4) for that persona role.
- **Reuse** — `reuse.policy` (reuse|always-new), `reuse.rotateAtContextPct` (default 75),
  `reuse.alwaysFresh` (roles that never reuse — keep reviewer/qa there). On rotation,
  the outgoing agent appends its state to memory.md first.
- **Memory** — `memory.featureMemory` (default `memory.md`), `memory.handoffDir`
  (default `handoff`), `memory.globalMemory` (optional cross-feature learnings path).
- **Artifacts** — `artifacts.specsRoot` overrides the feature-folder root (default `specs`).
- **Delegation** — `delegation.yolo: true` → run agent.sh with `AGENT_YOLO=1`, allowed
  **only inside an isolated git worktree**, never in the user's live checkout.

Delegated work follows the verify-and-record protocol: never trust the report — check
the artifact exists with its Status set and the gate criteria hold, then log one line in
memory.md's delegation log (handoff, provider, outcome).

## Rules

- Run stages in order after entry. Use the Transition rules for entry, skip, resume,
  escalation, and loop-back decisions. Never skip an applicable gate. User-approval
  gates are hard stops — present the artifact summary and wait; do not proceed on your
  own. On approval, the stage records it in the artifact (Status APPROVED / User
  approval / Sign-off).
- Pass Stage 0 findings (via memory.md) into each stage; the stages' own discovery steps exist for standalone runs and should only fill gaps, not repeat reads.
- **Resume**: given an existing feature folder, read memory.md and each artifact's Status line; continue from the first missing / DRAFT / FAIL artifact — or the first whose approval line is still pending (`tasks.md` User approval, `qa-report.md` Sign-off). Confirm the resume point with the user before continuing.
- **Loop-backs**: verification FAIL → fix the specs at the owning stage, re-run /plan-verification. Review or QA FAIL → fix via /plan-implement (its scope control decides what returns to planning), then re-run the failed stage. Artifacts update in place — paths stay stable.
- **Scope changes mid-flow**: update the owning spec first, re-verify, then continue — never patch downstream artifacts only. If the change alters an upstream `prd.md`'s problem, outcome metric, appetite, or non-goals, stop and route to /product-workflow (P5 or earlier) before touching dev specs.
- Keep the user oriented: one short status line per stage transition (`{stage}: {status} → {next}`), plus provider/model when delegated.
