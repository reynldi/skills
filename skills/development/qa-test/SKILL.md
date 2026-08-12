---
name: qa-test
description: QA acceptance testing of an implemented feature against the Product Spec — run suites, execute each story's Independent Test, edge cases, contract conformance; writes qa-report.md. Final stage of /development-workflow, after /impl-review. Use when the user asks to QA or acceptance-test a feature, or invokes /qa-test.
---

# QA Test

**Stage**: 8 (QA — final). Prev: /impl-review.
**Input**: `product-spec.md` (stories, flows, edge cases), `tasks.md` (Independent Tests, acceptance criteria), `contract-spec.md` (examples), `implementation-report.md` (build/test/run commands). Locate the feature folder from arguments; ask if ambiguous.
**Output**: `qa-report.md` beside the specs — structure: `templates/qa-report.md` (read only when writing). Re-runs update it in place.
**Gate**: Status PASS — all automated scenarios pass and the manual checklist is delivered — then user sign-off closes the feature; record it by setting the report's Sign-off line to approved.

QA validates the product against the Product Spec from the user's point of view — observable behavior, not code.

**Context budget**: apply the "Risk and token budget" protocol in
../development-workflow/SKILL.md; load more only when it changes the current decision.

## QA depth

Read `tasks.md` first. Its QA depth controls the work:

- **Focused** — execute every changed acceptance criterion, focused automated checks,
  and the affected-flow smoke test.
- **Feature** — create a concise QA charter; execute happy paths, important edge and
  failure states, plus relevant contract checks.
- **Full** — consume the /qa-planning test plan and reusable cases; execute the
  risk-based regression suite, then record any scenarios that remain manual.

No depth skips acceptance proof. A Full plan is an input to QA, not a substitute for
executing and recording real evidence.

## Executable browser QA

When a scenario needs browser proof, first discover the project's existing runner.
Use it when present. Otherwise, use Playwright only after the user permits dependency
installation. Do not use browser execution for API-only or CLI behavior.

Run `bash bin/run-browser-qa.sh` with the app start command, readiness URL, browser test
command, and artifact directory. The runner starts only a local test app, waits for
readiness, runs one suite, and stops the app. Configure the browser runner to retain
screenshots, traces, console output, and failed network details on failure.

Use test accounts and isolated data. Never target production or perform destructive
actions. Record the executor, expected result, actual result, artifact location, and
remaining manual checks in `qa-report.md`.

## Process

1. **Build the QA charter** from the specs: per story — happy path, each specified edge case, and failure paths (invalid input, permission denied, duplicates/retries where specified); cross-story interactions; regression of adjacent existing behavior the feature touches.
2. **Run the automated suites** — the full test commands from the implementation report (or discovered from the project). Record results.
3. **Execute each story's Independent Test** — automate where possible: integration/e2e tests, running the app via the project's run command, scripted API calls. Verify actual behavior matches the spec's observable outcomes — not merely that code ran.
4. **Contract conformance** — exercise new/modified endpoints/events and compare real responses/payloads against `contract-spec.md` examples and field tables.
5. **Manual checklist** — for scenarios that genuinely cannot be automated here (visual polish, real third-party side effects, multi-device), write precise steps + expected results for the user. These do not block PASS but must be listed in the report.
6. **Record evidence** per scenario: command or steps, expected, actual, PASS/FAIL.
7. **Failures** — classify each: implementation bug → append fix tasks to `tasks.md` and return to /plan-implement, then re-run the failed scenarios; spec mismatch → route to the owning planning stage per /plan-implement scope control.
8. Write `qa-report.md`; on PASS, summarize the results and ask the user for sign-off.
