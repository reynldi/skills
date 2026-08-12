# Handoff

Transfer a task — context, decisions, failed attempts, constraints — to a fresh agent
that starts with zero context. The handoff prompt must be a self-contained briefing.

**Handoffs are ephemeral and blocking** (synchronous supervisor pattern): you launch
the delegate, wait idle until it finishes — no polling, no parallel work on the same
task, no hurry-ups — read its report, record the delegation summary, and tear the
delegate down. No agent outlives its task. If more work is needed, that is a new
handoff with a fresh brief (include the previous summary and report in it).

## Parsing the request

1. **Provider** — explicit user request first; otherwise resolve from the `impl`
   preference (or `ui` if the task is styling-only). Run `bin/backend.sh` to resolve.
2. **Isolation** — "in a worktree" / "worktree" → give the agent worktree isolation
   with a short branch name derived from the task.
3. **Task description** — everything else the user said.

## The handoff brief

Write it to a file (`handoff-<slug>.md` in the working folder), not just into a prompt:

```
## Task
[Imperative description.]

## Context
[Why this task exists, required context.]

## Relevant files
- `path/to/file.ts` — [what it is and why it matters]

## Current state
[What's done, what works, what doesn't.]

## What was tried
- [Approach] — [why it failed or was abandoned]

## Decisions
- [Decision — rationale]

## Acceptance criteria
- [ ] [Criterion]

## Constraints
- [Must-not / must-preserve]
```

**Preserve task semantics.** Investigate-only → "DO NOT edit files." Fix → "implement
the fix." Refactor → "refactor, not rewrite." Carry the user's exact intent.

## Lifecycle

1. **Launch blocking.**
   - Native backend: `bin/handoff.sh --brief <file> --provider <p>[/<model>]
     --role <role> [--effort <level>] [--dir <workdir>]`. The call blocks; stdout is
     the delegate's report. When `--role` names a persona (compass, forge, prism,
     gauntlet, bastion, atlas), its file is embedded into the brief automatically;
     `--effort L1..L4` pins the persona's thinking level.
   - Paseo backend: `create_agent` with `notifyOnFinish: true`, then wait for the
     finish notification — do not poll, do not start other work on this task.
2. **Read the report.** Challenge it against the acceptance criteria before accepting.
3. **Record the delegation summary** (below) and relay it to the user.
4. **Tear down.** Native: the process already ended. Paseo: `archive_agent` once the
   report is read. Never leave a delegate running "in case".

## Delegation summary

Every handoff produces a summary — shown to the user and persisted beside the brief
as `<brief>.summary.json` (`handoff.sh` does both automatically):

| Field | Meaning |
| ----- | ------- |
| agent | Title, e.g. `[Handoff] fix-retry-logic` |
| role | Why it was launched: `delegate`, `loop-worker`, `loop-verifier`, `advisor`, … |
| provider / model | What actually ran |
| effort | Requested reasoning effort (applied where the provider supports it) |
| session | Provider session ID (`claude`/`codex` captured automatically; else `n/a`) |
| status | `completed` / `failed(exit=N)` |
| duration / brief / log | Timing and where the artifacts live |

On paseo, build the same summary from `create_agent`'s return (`agentId`, provider,
workspace) and the finish notification.
