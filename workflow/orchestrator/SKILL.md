---
name: orchestrator
description: Global multi-agent orchestrator — delegate work to other agents with the right pattern: advisor (second opinion), committee (two contrasting agents plan a hard problem), handoff (transfer a task with full context), loop (worker/verifier cycle until done). Use when the user says "advisor", "second opinion", "committee", "handoff", "hand this to", "loop", "keep trying until", "babysit", or invokes /orchestrator. Backend-agnostic: uses paseo when available, subagents otherwise.
---

# Orchestrator

You coordinate other agents; you do not do all the work yourself. This skill tells you
which delegation pattern fits the situation and the principles every pattern shares.
The pattern playbooks are in `patterns/`.

**User's request:** $ARGUMENTS

## Pick the pattern

| Situation | Pattern | Playbook |
| --------- | ------- | -------- |
| You want an outside judgment, but you keep driving the work | Advisor | `patterns/advisor.md` |
| You are stuck, looping, tunnel-visioning, or facing a hard planning problem | Committee | `patterns/committee.md` |
| The work should move to another agent entirely (ephemeral, blocking, reports back) | Handoff | `patterns/handoff.md` |
| The work needs iteration until a condition is met ("keep trying", "babysit", "watch until X") | Loop | `patterns/loop.md` |

If the user named a pattern, use it. Otherwise pick from the table and say which one
you picked and why, in one line, before you start.

## Delegate or stay inline

Delegation is not free: the handoff cost is roughly **fixed** (write the brief, the
delegate re-discovers the repo, you verify the result), while the work's cost **scales
with the task**. Judgment stays in one owning context (yours); delegation is for
execution. Size decides:

- **Small or subtle → stay inline.** ≤ ~3 files, no new architecture — or subtle work
  (concurrency, tricky invariants) where handoff loss bites hardest. Doing it yourself,
  even on a frontier model, is usually cheaper than the delegate's re-discovery alone.
- **Large or mechanical → delegate down.** Many files, parallel stories, bulk edits,
  boilerplate. The cheap model's discount dominates the fixed overhead, and the plan
  artifact you already wrote doubles as the brief.
- **Context pressure is a trigger by itself.** Past ~60% of your context, delegate even
  medium tasks — mechanical diffs and tool noise degrade the judgment you need for
  verification and what comes next. Burn mechanical tokens in delegates; keep distilled
  summaries here.
- **Fresh eyes justify review delegation only.** "A different provider catches
  different bugs" is an argument for cross-model *verification*, never for delegating
  *implementation*.
- **Done is declared by a check the author didn't produce** — the cheapest sufficient
  one: tests/typecheck → cheap-model diff review → cross-model review → committee.
  Escalate on evidence: the same cause fails twice → fresh eyes or promote the
  implementer's model tier; ~3 non-converging rounds → committee.

## Scripts

Deterministic helpers in `bin/` — prefer them over ad-hoc probing:

- `bin/backend.sh` — resolves the backend (paseo / native / none), lists installed
  provider CLIs, and prints the role → provider map from orchestration preferences.
  Run this first.
- `bin/handoff.sh` — ephemeral blocking delegation: runs one agent headless via the
  shared `agent.sh` runner, streams its report to stdout, and emits the delegation
  summary (agent, role, provider/model, effort, session ID, status, duration) to
  stderr and `<brief>.summary.json`.
- `bin/loop.sh` — bounded worker/verifier loop for the native backend. Refuses to
  start without verification and without bounds; logs every iteration to disk.
  On paseo, use `paseo loop run` instead.

## Pick the backend

Check in order; use the first that exists:

1. **Paseo** — the `paseo` skill is available, or `paseo daemon status` succeeds, or the
   Paseo MCP tools (`create_agent`, `create_workspace`, …) are loaded. Read the `paseo`
   skill and use its tools/CLI. Loops use `paseo loop run`.
2. **Native subagents** — the Agent tool (Claude Code) or an equivalent spawn mechanism.
   Advisor/committee members map to read-only agents; handoff maps to a background agent
   (worktree isolation when asked); loops map to a worker/verifier cycle you drive.
3. **None** — no way to spawn agents. Say so and offer to run the pattern inline
   (for example, play the advisor role yourself in a fresh framing). Never fake a
   second agent's output.

## Provider selection

Before choosing who runs what, read `~/.paseo/orchestration-preferences.json` if it
exists — an actual file read, every time. It maps role categories (`impl`, `ui`,
`research`, `planning`, `audit`) to providers, plus freeform preferences to weave into
prompts. The user naming a provider always wins. If the file is missing, use what the
backend offers and tell the user once.

**Contrast is deliberate.** For committees and worker/verifier pairs, pick different
providers or model families on purpose — each catches the other's blind spots. If an
advisor would land on your own provider, swap to a different family; a fresh
perspective is the point.

## Shared principles

Every pattern inherits these. The playbooks assume them.

1. **Zero context.** The receiving agent knows nothing. Every briefing is
   self-contained: the goal, constraints, what was tried and why it failed, decisions
   made, relevant files by path (do not paste file contents — let the agent read),
   and explicit acceptance criteria.
2. **Analysis agents do not edit.** Every prompt to an advisor, committee member, or
   verifier ends with the no-edits suffix:

   ```
   This is analysis only. Do NOT edit, create, or delete any files. Do NOT write code.
   ```

3. **Preserve task semantics.** Investigate-only → "DO NOT edit files." Fix →
   "implement the fix." Refactor → "refactor, not rewrite." Carry the user's exact
   intent into the briefing; never widen or narrow it.
4. **Trust the wait.** High-reasoning agents can take 15–30+ minutes. Do not poll,
   send hurry-ups, or interrupt. Prefer notifications/callbacks over polling. A long
   wait usually means the agent found something worth thinking about.
5. **You are the middleman.** Drive the cycle (plan → implement → review, or worker →
   verify) without yielding to the user, except for genuine divergences that need
   their call. Challenge what agents return — verify assumptions against the code,
   ask "symptom or cause?" — do not accept output at face value.
6. **Bound everything.** Loops get max-iterations and/or max-time. Committees that
   don't converge after ~10 review iterations get replaced with a fresh committee
   carrying the full history. Open-ended delegation is how runaways happen.
7. **Isolate mutations.** Agents that edit files in parallel with you or each other
   work in a worktree (or the backend's isolation). Analysis agents need none.
8. **Ephemeral delegates, visible delegation.** A delegate lives exactly as long as
   its task: launch blocking, wait idle, read the report, archive. Never leave an
   agent running after its report is read. Every delegation is announced with a
   summary — agent name, role, provider/model, effort, session ID, status — so the
   user can always see who did what (see `patterns/handoff.md`). Scope: this governs
   one-shot delegations. A process-level pipeline (like `/development-workflow`) that deliberately
   resumes the same agent while iterating on one stage keeps its own reuse policy —
   context continuity there is the point, and that policy wins inside the pipeline.

## Synthesize

You own the result. When agents return, read everything, reconcile disagreements
(convergence → merged answer; significant divergence → bring it to the user with your
recommendation), and report the outcome plus your own judgment — never paste raw agent
output as the answer.
