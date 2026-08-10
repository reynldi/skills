# Advisor

Single agent. It reads the situation you are in, gives a judgment, and you decide what
to do — the advisor does not drive the work.

## Picking the advisor

1. User named a provider → use it.
2. Otherwise resolve from orchestration preferences by question type:
   - Design / approach question → `planning`
   - "Did I miss something" review → `audit`
   - "Is this even right" → `research`
3. If that lands on your own provider or model family, swap to a different one on
   purpose — contrast is the point.

## The briefing

The advisor has zero context. Make it self-contained:

- The question, sharply.
- What you have considered and what you have ruled out.
- Relevant files by path (do not paste — let the agent read).
- Explicit ask: "give me a recommendation, with reasoning."
- End with the no-edits suffix.

## Forwarded skills

If the request contains another skill reference (`/name` or `$name`), the user wants
the advisor to run that skill against the current task. Tell the advisor explicitly:

```
Invoke the `<name>` skill against this task. Load it via the Skill tool before doing anything else.
```

Pass remaining arguments through as the skill's own input. The advisor runs the skill;
you stay the orchestrator.

## Launch and synthesize

Launch with an `[Advisor] <topic>` title. Wait for it to finish. Read the response and
report the advisor's verdict plus your own recommendation.

## Persistent advisor

If the user wants ongoing input ("keep this advisor for the next few decisions"), keep
the agent alive and send follow-ups. Retire it when the user is done or the topic
shifts enough that a fresh context would serve better.
