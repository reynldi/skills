---
name: impl-review
description: Holistic post-implementation review of the whole feature diff against Product/Technical/Contract Specs — spec compliance, correctness, security, tests, maintainability; writes review-report.md. Stage 7 of /development-workflow, after /plan-implement. Use when the user asks to review an implemented feature or invokes /impl-review.
---

# Implementation Review

**Stage**: 7 (Review). Prev: /plan-implement · Next: /qa-test.
**Input**: `implementation-report.md` (diff range, commands) + the specs + `tasks.md` in the feature folder. Missing report → use the `Baseline` line in `tasks.md`, else the merge-base with the default branch, and note it in the report.
**Output**: `review-report.md` beside the specs — structure: `templates/review-report.md` (read only when writing). Re-reviews update it in place.
**Gate**: Status PASS with zero open Blocking/High findings.

This is a whole-feature review across the full diff — integration seams, cumulative drift, spec coverage as a whole — not a repeat of the per-task reviews done during implementation.

**Context budget**: apply the "Risk and token budget" protocol in
../development-workflow/SKILL.md; load more only when it changes the current decision.

## Process

1. **Scope** — collect the full diff (`baseline..HEAD` from the report); group changed files by area.
2. **Discover review conventions** — project reviewer agents/skills, lint/static-analysis commands, security guidance. Use project reviewers per area when available; otherwise run independent review subagents (or a structured self-review) per dimension below.
3. **Review dimensions**:
   - **Product compliance** — every Product Spec behavior and story present; no invented behavior; specified edge cases handled.
   - **Technical compliance** — architecture as designed; deviations match the report's Deviations list; nothing undeclared.
   - **Contract compliance** — implementation matches `contract-spec.md` exactly: fields, errors, auth, idempotency, versions.
   - **Correctness & safety** — bugs, race conditions, unsafe retries, transaction boundaries; security: authorization on every new surface, input validation, secrets handling.
   - **Tests** — critical behavior and failure boundaries covered; tests assert real behavior, not implementation details.
   - **Maintainability** — simplicity, clear ownership, dead code, scope creep, leftover debug output or TODOs.
4. **Verify findings** — re-read the code and confirm each finding is real before reporting; drop what doesn't hold. Severity per the /plan-verification ladder; every finding carries a recommendation + why.
5. **Fix loop** — for Blocking/High findings: append fix tasks to `tasks.md` and return to /plan-implement (its scope control decides what goes back to planning — never patch product/architecture changes silently), then re-review the affected areas until PASS.
6. Write `review-report.md` with the verdict and per-dimension results; hand off to /qa-test.
