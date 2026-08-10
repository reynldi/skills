---
name: plan-implement
description: Execute an approved tasks.md task-by-task with tests, per-task reviewer PASS, and checkpoint gates; writes implementation-report.md. Stage 6 of /development-workflow, after /plan-ready. Use when the user asks to implement approved tasks, execute tasks.md, or invokes /plan-implement.
---

# Plan Implement

**Stage**: 6 (Implement). Prev: /plan-ready · Next: /impl-review.
**Input**: `tasks.md` with Readiness Status PASS and `User approval: approved`, plus the specs beside it. Locate from arguments or the folder containing `tasks.md`. Missing or unapproved → stop and direct the user to /plan-ready.
**Output**: implemented code; `tasks.md` checkboxes updated as tasks pass; checkpoint retrospectives beside `tasks.md`; `implementation-report.md` at completion — formats: `templates/reports.md` (read when producing output).
**Gate**: all tasks PASS, final regression green, git clean, report written.

`tasks.md` is the execution order; the specs remain the source of truth for behavior. Do not redesign the feature during implementation.

## Preflight

- Record the baseline ref (current commit) as a `Baseline: {sha}` line in the `tasks.md` Readiness block — resume and the Review stage read the `baseline..HEAD` diff range from there. No git → snapshot the changed-file list instead, skip the commit/clean gates, and note it in the report.
- Discover project conventions: build/test/run commands, commit policy, reviewer agents/skills (project agent directory, code-review skills). Fallbacks: no reviewer agent → use an independent general-purpose review subagent; no test infrastructure → state it per task and ask the user how to validate.
- Resume: continue from the first unchecked task in `tasks.md`.
- If the plan is materially inconsistent with the codebase or specs, stop that task and report the planning issue — never silently change the design.

## Task loop

Select: current phase → higher-priority story → dependency order → task ID order. `[P]` tasks may run concurrently only when genuinely conflict-free — not merely because the marker exists.

For each task:

1. Read its acceptance criteria; inspect the relevant existing code; reuse existing patterns.
2. Make the smallest coherent implementation. No unrelated refactoring, no new dependencies without spec backing, no TODOs replacing required behavior, no silent contract changes, no hidden side effects.
3. Test — smallest relevant set first: changed unit → feature → contract/integration → wider regression when needed. Test-first tasks: write test → confirm FAIL → implement → confirm PASS. Never weaken or remove valid tests to make implementation pass.
4. **Reviewer loop** — an independent reviewer compares the task diff against acceptance criteria + all specs + project conventions (correctness, missing behavior, contract compliance, edge cases, regression risk, security, simplicity, tests). Give the reviewer: task ID, acceptance criteria, spec paths, diff since task start. Result PASS / NEEDS CHANGES; fix required findings, re-test, re-review until PASS. No dependent task starts before PASS.
5. On PASS: check the task off in `tasks.md` immediately; keep the progress note concise (format in `templates/reports.md`) — no long narration for routine steps.

## Scope control

Classify every discovery:

- **Implementation detail** — behavior unchanged → resolve using project conventions.
- **Plan gap** — intended behavior clear, plan missed detail → update `tasks.md`, continue.
- **Product / architecture change** — UX, product behavior, public contract, major architecture, or scope → stop; return it to the owning planning stage. Never silently implement.

Contracts: follow `contract-spec.md` exactly; surface mismatches instead of silently modifying the contract.

## Checkpoint gate

Follow the Checkpoint Plan in `tasks.md` (fallback: every 5 tasks; story completion is also a checkpoint). At a checkpoint, stop starting new tasks until all gates pass:

1. **Review** — every task since the last checkpoint: implemented, acceptance PASS, reviewer PASS, tests PASS.
2. **Regression** — run the broader suite appropriate to the accumulated changes; fix regressions first.
3. **Retrospective** — short: went well / went wrong / improve (adjust remaining tasks, improve tests, return invalid assumptions to planning). Append it to `retrospectives.md` beside `tasks.md`. Never silently change product behavior.
4. **Git** — changes scoped to the task group; commit message per the discovered commit policy (fallback `{type}: {task outcome}`); nothing unrelated mixed in. If commits are authorized (project policy or the user said so), commit and verify `git status` is clean; otherwise present the changes for commit approval. Do not continue past a failed gate.

## Story & feature completion

A story is done only when its Independent Test passes, all its acceptance criteria hold, its story-level review passes, and previous stories still work — an independent vertical slice.

When all tasks are done: run the final regression, write `implementation-report.md` (status, per-story validation, deviations, `baseline..HEAD`, discovered build/test/run commands), and hand off to /impl-review.
