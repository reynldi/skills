# Loop

A loop is a worker/verifier cycle: launch a worker → check verification → repeat until
done or limits hit. Use for "keep trying", "babysit", or "watch this until X."

For lightweight recurring checks that should return to this conversation, prefer a
scheduled heartbeat/wakeup over a loop. Use a loop when each iteration needs a full
worker/verifier lifecycle.

On paseo, loops are a CLI primitive: `paseo loop run` (manage with `paseo loop
ls/inspect/logs/stop`). On other backends, you drive the cycle yourself: spawn worker,
run verification, decide, repeat.

## Designing the loop

1. **Worker prompt** — self-contained, concrete (commands, files, branches, tests,
   PRs, systems), explicit about what counts as progress this iteration.
2. **Verification** — pick the right shape:
   - Shell check for objective criteria a command can answer
     (`gh pr checks --fail-fast`, `npm test`).
   - Verifier prompt for judgment ("Return done=true only if all tests pass and the
     changed files are coherent. Cite the command and the outcome.").
   - Both, when shell rules out the obvious failures and the verifier judges the rest.
3. **Providers** — from preferences unless the user named them. For implementation
   loops, put worker and verifier on different providers — each catches the other's
   blind spots.
4. **Sleep** — only when polling something external. Otherwise run as fast as the
   loop completes.
5. **Stops** — always set max-iterations and/or max-time. Open-ended loops are how
   runaways happen.
6. **Keep artifacts** — keep per-iteration agents/logs inspectable when the backend
   supports it.

## Prompt rules

**Worker** — self-contained, concrete, explicit about what counts as progress.

**Verifier** — checks facts, does not suggest fixes, cites commands/outputs/file
evidence, specific about what "done" means. Ends with the no-edits suffix.

## Common shapes

- **Babysit a PR** — worker checks PR state and fixes issues; shell check is
  `gh pr checks <n> --fail-fast`; sleep 2m; max-time 1h.
- **Drive tests to green** — worker investigates failures and fixes code; shell check
  is the test command; verifier confirms all tests pass; max-iterations 10.
- **Cross-provider implementation** — worker on `impl` provider, verifier on a
  different provider; verifier checks changed files, runs typecheck and tests; both
  limits bounded; iteration artifacts kept for inspection.
