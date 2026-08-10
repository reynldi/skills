# Committee

Two agents from contrasting providers, fresh context, planning a solution in parallel.
They stay alive to review the implementation afterward.

The purpose is to step back, not double down. The committee may propose a completely
different approach than the one you were pursuing.

## Composition

Two members with different reasoning styles, resolved from orchestration preferences:

- one planning/research-strength provider
- one contrasting high-reasoning provider

Override only when the user explicitly asks for different members.

## Phase 1: Plan

Write one problem-level prompt for both members:

- High-level goal and acceptance criteria
- Constraints
- Symptoms (if a bug)
- What you tried and why it failed
- Explicit: "do root cause analysis"
- Explicit: "state assumptions, ask why three levels deep, check whether you're
  patching a symptom or removing the problem"
- End with the no-edits suffix

Launch both in parallel with `[Committee] <task>` titles and the same prompt. Wait for
both — not just whichever finishes first.

Read both responses and challenge them:

- "Why does <underlying thing> happen? Symptom or cause?"
- Verify any assumption the plan makes about the code.
- "What did you consider and reject?"

Send follow-ups until the plan addresses the root cause. Then synthesize:
convergence → unified plan; significant divergence → involve the user. Confirm the
merged plan with both members; multi-turn until consensus.

## Phase 2: Implement

Default: implement yourself. If the user said "delegate", launch one implementation
agent and pass it the merged plan. The committee stays clean — never involved in
implementation.

## Phase 3: Review

Send the diff to both members:

> Implementation is done. Review changes against the plan. Flag drift or missing
> pieces. <no-edits suffix>

Apply feedback yourself (or via the impl agent). Repeat implement → review until
consensus. After ~10 iterations without convergence, start a fresh committee with the
full history of what was tried — the current committee's context may have drifted.
