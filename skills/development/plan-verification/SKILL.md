---
name: plan-verification
description: Skeptical pre-implementation review of Product/Technical/Contract Specs — ambiguity, contradictions, over-engineering, risk — with severity-ranked findings and interactive Q&A. Stage 4 of /development-workflow, before /plan-ready. Use when the user asks to verify, review, or challenge a plan/spec set, or invokes /plan-verification.
---

# Plan Verification

**Stage**: 4 (Planning). Prev: /plan-contract-spec · Next: /plan-ready.
**Input**: the feature folder's `product-spec.md`, `technical-spec.md`, `contract-spec.md` — locate from arguments or by searching the project's spec locations; ask if ambiguous. If some are absent, scope the review to what exists and flag the absence.
**Output**: `verification.md` beside the specs — structure: `templates/verification.md` (read only when writing). Record the verified state of each input spec (git SHA or content hash) so /plan-ready can detect staleness. Re-verification updates it in place: mark resolved findings, re-derive the verdict, deep-review only changed spec sections.
**Gate**: Status PASS or PASS_WITH_NOTES with zero open Blocking/High findings before /plan-ready runs.

Be skeptical. Challenge the plan, do not defend it. Never approve a plan because it is detailed.

**Context budget**: apply the "Risk and token budget" protocol in
../development-workflow/SKILL.md; load more only when it changes the current decision.

## Severity (pipeline-wide ladder)

- **Blocking** — must resolve before implementation
- **High** — likely incorrect behavior or major rework
- **Medium** — meaningful complexity or maintainability risk
- **Low** — improvement that can safely wait

## Process

1. **Understand the plan** — problem, intended UX, flows, scope, assumptions, open questions, architecture, contracts. Separate confirmed decisions from assumptions. Inspect the existing implementation in areas the Technical Spec touches before judging the design; discover project conventions (skills list, CLAUDE.md, docs).
2. **Product critique** — does this solve the actual user problem? Larger than needed? Anything built too early? All important flows/states covered? Assumptions treated as requirements? Conflicting stories? Could the outcome be simpler? Flag unnecessary configurability, future-proofing, and scope creep.
3. **Technical critique** — simplest design that works? Can existing code support it? Responsibilities clear? State duplicated? Concurrency, idempotency, retries, transactions handled where needed? Migrations and compatibility safe? Prefer removing complexity over documenting it.
4. **Challenge complexity** — anything justified mainly by hypothetical future needs (future traffic/consumers/providers, multi-region, plugin systems, microservices, event-driven decomposition, caching, sharding): ask *what current requirement needs this?* For every new component (service, table, queue, cache, event, external dependency, or abstraction layer not already in the codebase) ask: why does it exist · what current requirement needs it · can existing code handle it · what complexity does it add · what happens if removed? Classify each: Required / Optional / Premature / Unnecessary.
5. **Cross-spec check** — every product behavior has technical coverage; the technical design invents no product behavior; contracts match the Technical Spec; naming, states, required fields, errors, retries, and versions consistent. Flag every contradiction.
6. **Ambiguity check** — terms that allow multiple interpretations (active, eligible, real-time, retry, latest, gracefully, fast, when needed). Ask the user only when the answer materially changes UX, architecture, contract, or correctness.
7. **Risk check** — invalid state transitions, duplicate processing, race conditions, unsafe retries, partial failures, stale state/cache, breaking schema changes, missing migration, missing authorization, hidden coupling, frontend/backend mismatch, unbounded resource usage.

## Interactive Q&A

For Blocking or High-impact ambiguity, ask before finalizing — via AskUserQuestion when available, otherwise in markdown with the same structure: question · why it matters · 2-4 concrete options · recommended option · why. Priority: Blocking > High > important design choice. Never ask Low-severity questions when a safe default exists.

After answers: apply each agreed decision to the affected spec files (small, targeted edits), record it in the report's Decisions table, resolve related findings, re-derive the verdict.

## Rules

- Every finding: severity + recommendation + why, grounded in a current requirement — never "because it is better".
- Current requirements beat hypothetical future needs; simpler wins when equally correct.
- Product Spec defines behavior; project conventions define implementation style. Accept no ambiguity that affects correctness.

## Final Check

- Product scope and complexity challenged; premature abstractions identified and classified.
- Specs cross-compared; contradictions and material ambiguity resolved or asked.
- Every finding has severity + recommendation + why; Blocking/High separated from deferrable.
- Verdict and Decisions persisted to `verification.md`; agreed decisions applied to the spec files.
