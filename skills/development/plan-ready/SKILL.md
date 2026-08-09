---
name: plan-ready
description: Final planning gate — verify specs are consistent, then generate tasks.md organized by user story with checkpoints; fails without generating tasks while Blocking/High issues remain. Stage 5 of /workflow, before /plan-implement. Use when the user asks to generate implementation tasks or invokes /plan-ready.
---

# Plan Ready

**Stage**: 5 (Planning gate). Prev: /plan-verification · Next: /plan-implement.
**Input**: `product-spec.md` + `technical-spec.md` (required), `contract-spec.md` + `verification.md` (when present — note absence and proceed). Locate the feature folder from arguments; ask if ambiguous.
**Output**: `tasks.md` beside the specs — structure: `templates/tasks.md`. On FAIL, write only its Readiness block (Status FAIL + issues); generate tasks only after the gate passes. Re-runs update in place — preserve completed checkboxes, task IDs, and appended fix tasks; only add or modify tasks affected by the change.
**Gate**: FAIL — no tasks generated — while any Blocking/High finding is open. On PASS, present `tasks.md`, get explicit user approval, and record it: set `User approval: approved` in the Readiness block before /plan-implement.

## 1. Quality gate

If `verification.md` exists with Status PASS/PASS_WITH_NOTES and the specs still match its recorded verified-input hashes, run only a delta check (decisions applied? anything changed since?). Otherwise verify:

- **Product** — main flows complete; important states/edge cases defined; no blocking ambiguity; scope fits the current stage.
- **Technical** — architecture satisfies the Product Spec; project conventions respected; no unjustified abstraction/infrastructure; models, migrations, reliability, ownership clear.
- **Contract** — contracts match Product + Technical Specs; auth, fields, errors, idempotency, versions consistent.
- **Cross-spec** — terminology and states match; every product behavior has technical coverage; nothing invented; every contract serves a defined flow.

On FAIL, report each issue with: severity (per the /plan-verification ladder), affected spec, recommendation, and which stage should fix it. Do not generate tasks.

## 2. Load context

Stack, project structure, existing related code, stories and priorities (from the Product Spec), models, contracts, technical decisions. Discover available reviewer agents/skills and test commands. If the project defines its own workflow/checkpoint convention, adopt it over the defaults below.

## 3. Generate tasks

Every task maps to a user story or a real shared prerequisite — nothing speculative.

- **Phases**: Setup (shared init only; skip when unnecessary) → Foundational (only prerequisites blocking multiple stories; keep minimal; story work must not begin before it completes) → one phase per user story (ordered by Product Spec priority, then dependency) → Polish (only real cross-cutting work; do not manufacture polish tasks).
- **Within a story**: Tests → Models → Services → Endpoints/Events → Frontend → Integration → Review (adapt the layer sequence to the project's actual architecture; keep Tests first and Review last). Each story must be independently functional and testable, with an explicit **Independent Test** line.
- **Task format**: `- [ ] T001 [P] [US1] {action} in {path}` + `Acceptance: {observable criteria}`. IDs `T###`, globally sequential in execution order. `[P]` = parallel-safe (no mutual dependency, no conflicting files/state, independently reviewable). `[US#]` = story mapping. One implementation/review cycle per task. Never tasks like "implement backend", "handle errors", "refactor code".
- **Tests**: follow project testing conventions; contract tests precede contract implementation whenever a Contract Spec exists; mark test-first tasks explicitly.
- **Review & checkpoints**: end each story with a reviewer task. Insert checkpoint markers using the cadence: every 10 small / 5 medium / 2 high-complexity tasks (complexity ≈ files touched + novelty; use the smallest interval in a mixed batch; story completion also counts as a checkpoint). The gate protocol (reviewer loop, regression, retrospective, git) is owned by /plan-implement — reference it, do not restate it.
- **Dependencies**: explicit phase and story dependencies, plus parallel opportunities.

## Final Check (before returning PASS)

- No open Blocking/High issues; readiness block filled in `tasks.md`.
- Every story has complete tasks with acceptance criteria; models/contracts map to stories.
- Every task traces to a story or shared prerequisite; `[P]` genuinely parallel-safe; dependencies explicit.
- Stories independently testable; reviewer tasks and checkpoint markers present.
