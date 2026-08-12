---
name: spec-analyze
description: Judge and analyze an existing product or technical spec. Deep-research the product spec against competitors and first-principles; review the technical spec against the codebase for robustness, quality, simplicity, scalability, and long-term maintainability. Surfaces labeled findings and quizzes the user to resolve them. Use for "analyze this spec", "review my spec", "is this spec sound?".
disable-model-invocation: true
---

Judge an existing spec. This is evaluation, not extraction — the opposite of `spec-generate`. Where `spec-generate` only documents what exists with no critique, `spec-analyze` exists to critique: it compares the spec against industry best practice, competitors, first-principles reasoning, and the actual codebase, then labels every gap and asks the user to resolve it.

Nothing is written to disk until the final step, and only on the user's explicit instruction.

**Context budget**: apply the "Risk and token budget" protocol in
../development-workflow/SKILL.md; load more only when it changes the current decision.

## Step 0 — Scope the analysis

Before anything else, ask the user what to analyze. Use an interactive prompt (clickable options) when available:

- **Product spec** — analyze the product / feature spec.
- **Technical spec** — analyze the technical / implementation spec.
- **Both** — analyze product and technical together.

Also confirm which spec files or paths are in scope. Do not proceed until the user picks.

## Analysis lenses

### Product spec

Deep-research the problem and solution, not just proofread the document.

- **Competitor analysis** — how do similar products or direct competitors solve the same use case? What did they choose and why?
- **First-principles thinking** — strip the spec to the underlying problem. Does the proposed solution actually follow from the problem, or is it an inherited assumption?
- **Relevant mental models** — apply whatever fits: jobs-to-be-done, tradeoff triangles, second-order effects, failure modes, incentives, edge-case users. Name the model when you use it.
- Check for: unstated assumptions, missing user segments, unhandled edge cases, success metrics that don't measure the goal, scope that doesn't match the problem.

### Technical spec

Review the spec against the **actual codebase**. Focus on:

- **Robustness** — failure handling, race conditions, idempotency, data integrity, security enforcement across entry points.
- **Quality** — correctness, test coverage, error paths, consistency with existing patterns and ADRs.
- **Simplicity** — is there a simpler design that meets the same need? Over-engineering, premature abstraction, needless coupling.
- **Scalability** — behavior under load, hot paths, N+1s, unbounded growth, statefulness.
- **Long-term maintainability** — naming, layering, taxonomy consistency, how hard the next change will be.

## Finding labels

Tag every finding with a label so the user can scan severity and type at a glance. Use these, and add your own when they fit:

- `[BAD IMPLEMENTATION]` — exists but is wrong, fragile, or unsafe.
- `[NEED CLARIFICATION]` — spec is ambiguous, contradictory, or underspecified.
- `[MISSING IMPLEMENTATION]` — spec requires it; code doesn't have it (or vice versa).
- `[OVER-ENGINEERED]`, `[SCALABILITY RISK]`, `[SECURITY RISK]`, `[MAINTAINABILITY]`, `[SPEC DRIFT]` — use as relevant.

Each finding cites its evidence: spec section for spec claims, file path for code claims, source/competitor for research claims.

## Process

1. **Analyze the current spec.** Read it fully. Deep-research industry best practice and how similar products or competitors handle the same use case. For product specs, run the product lenses; for technical specs, run the technical lenses.

2. **Explore the codebase — only if needed.** ONLY IF you do not already have codebase context, explore it. Compare the current implementation against the spec. Skip this if the session already carries enough code context.

3. **Gather findings into the session. No file writes yet.** Collect every finding with its label and evidence into context. Then ask the user: do they want to **clarify all findings directly** now, or have you **summarize first**?

4. **If they choose to clarify — quiz the findings.** Walk findings one at a time using the quiz template below. Prefer an interactive prompt (clickable options) so the user just selects.

5. **Summarize and persist.** Summarize all findings plus any clarifications the user resolved. Then ask the user where to store this — a **new analysis document**, or **replace / update the existing spec** with the resolved clarifications. Write only after they answer.

## Quiz template

Use interactive prompt chat if available, so the user just clicks an option.

```
*Finding n/n*  [LABEL]
Title:      <the question to the user>
            e.g. "Spec 001: System rate-limits by device UUID, but that's unreliable. Options to handle this:"
Statement:  <the relevant context or statement from the current spec, with evidence>
Options:
  1. <option A> (RECOMMENDED) — <strong reason this is the pick>
  2. <option B> — <tradeoff>
  3. <option C> — <tradeoff>
```

Rules:

- Break each option out; state its tradeoff plainly.
- Mark at least one option `(RECOMMENDED)` and back it with a strong, specific reason — not "best practice", but *why* here.
- One finding per prompt. Number them `n/n` so the user knows how many remain.

## Style

Short sentences, active voice. Every finding earns its place with evidence — a spec section, a file path, or a named source. No filler, no hedging. Prefer concise labeled findings over long prose.
