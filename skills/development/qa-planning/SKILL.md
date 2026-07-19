---
name: qa-planning
description: Generate QA test plans, manual test cases, regression test suites, and an HTML status dashboard. Test cases are produced per-flow in both Gherkin and JSON format. Use for "create a test plan for X", "write test cases for X", or "build a regression suite".
disable-model-invocation: true
---

# QA Planning

Turn a feature or requirement into structured QA deliverables: a **test plan**, **manual test cases** (Gherkin + JSON), a **regression suite**, and an **HTML dashboard**. Pick the deliverable from what the user asks; a single request can span several (a plan usually implies cases).

This is generation grounded in real context. Do not invent behavior — parse the requirement, and when context is thin, explore the code or quiz the user before writing. Every test step carries an expected result; every test case carries preconditions and test data.

A feature is made of **flows**. Sign-in (sign in → verify OTP → done), onboarding, and invitations are separate flows, each its own Gherkin `.feature` file focused on one flow only. Discover the flows before writing any case.

## Inputs

- The feature or requirement to cover (e.g. "the user authentication feature").
- Optional supporting material: a spec (markdown, pasted, or a Confluence URL fetched via the Atlassian MCP), a Jira/Linear ticket, or an existing test suite to extend.

## Process

1. **Input.** Restate the feature and the deliverable(s) requested in one sentence.

2. **Analyze.** Understand the context. Parse the existing feature/requirement. Identify the test types needed (functional, integration, UI, negative, boundary, security, performance, accessibility). Determine scope and priorities, and enumerate edge cases and variations — boundary values, nulls, empty states, concurrency, permissions.

3. **Explore codebase — only if needed.** ONLY IF the session does not already carry enough context, explore the code. Search comprehensively but only the relevant feature — entry points, validation rules, error paths, and states that tests must assert against.

4. **Discover flows.** Enumerate every distinct flow of the feature — the end-to-end journeys a user takes (e.g. for authentication: sign-in with OTP, sign-up/onboarding, invitation acceptance, password reset, sign-out). Each flow becomes one Gherkin `.feature` file. A flow with no coverage yet is listed, not skipped.

5. **Scope lock.** Present in one message: the discovered flow list, and the intended output location (see **Output layout** — default is a `test/` directory under the path the user named). Confirm both before writing. If a flow is missing or misgrouped, or the user wants a different location, adjust here.

6. **Quiz the user.** If context is still missing or you are relying on an assumption, ask before writing — assumptions are not allowed. Use the quiz format below. Prefer an interactive prompt (clickable options) when available.

7. **Generate.** Produce the structured deliverable(s) using the templates in this skill folder — one `.feature` file per discovered flow. Apply the priority model and best practices below. Cover the edge cases and variations found in step 2, not just the happy path.

8. **Validate.** Check the generated output against the current spec and context: completeness (every flow and requirement traced to at least one case), traceability (each case links to a requirement or user story), and that every step is actionable with an unambiguous expected result. Report anything you could not cover.

## Deliverables

### Test plan

Uses `templates/TEST-PLAN.md`. Must define:

- **Scope** — in scope and out of scope, stated explicitly.
- **Entry / exit criteria** — when testing starts, when it is done.
- **Risks** — each with a mitigation.
- **Test types** and environments in play.
- **Pass/fail criteria** (see below).

### Test cases

Produce **both** formats for the same cases:

- Gherkin — `templates/TEST-CASE.feature`, **one `.feature` file per discovered flow** (Given/When/Then, one behavior per scenario, `Scenario Outline` + `Examples` for variations). A `.feature` file covers a single flow end to end (e.g. `signin.feature`: sign in → verify OTP → done) — never mix flows in one file.
- JSON data — `templates/test-data.js`. This is the **single source of truth / database** the dashboard reads. It holds the plan reference, every flow, and every case, as one `window.TEST_DATA = { ... }` assignment (the same JSON schema documented in `templates/TEST-CASE.json`, wrapped so it loads over `file://` by double-click). Each case carries a `status` field.

Every case: unique id, title, priority (P0/P1/P2), `status`, preconditions, test data, ordered steps each with an expected result, and a traceability link to the requirement. Valid `status` values: `not_run`, `pass`, `fail`, `blocked`, `skipped` (default `not_run` on generation).

`templates/TEST-CASE.json` documents the plain-JSON schema; produce a `test-cases.json` export from it only if the user wants to import into a test-management tool. The dashboard itself uses `test-data.js`, so keep the status current there.

### Regression suite

A curated selection of existing cases plus new ones, grouped by flow and tagged by priority and run cadence. P0 cases run always; P1 weekly+; P2 at releases. Deliver as a JSON suite (array of case ids with tags) plus a short index. State explicitly what was excluded and why — never silently drop coverage.

### HTML dashboard

`dashboard.html` reads `test-data.js` (`window.TEST_DATA`) as its live database and opens by double-click — no server needed. It lists the plan and flows in a summary table with status rollups; clicking a flow reveals its test cases in a table with per-case status and steps. Do not author the HTML from scratch — copy `templates/DASHBOARD.html` into the output location unchanged. The dashboard never hardcodes cases; all data comes from `test-data.js`, so editing a case's `status` there and refreshing updates the dashboard.

## Priority model

| Priority | Description | Must run |
| --- | --- | --- |
| P0 | Business-critical, security, data integrity | Always |
| P1 | Major features, common flows | Weekly+ |
| P2 | Minor features, edge cases | Releases |

## Pass / fail criteria

- **PASS** — all P0 tests pass, 90%+ of P1 pass, no critical bugs open.
- **FAIL (block release)** — any P0 fails, a critical bug, a security vulnerability, or a data-loss scenario.
- **CONDITIONAL** — P1 failures with documented workarounds, known issues logged, and a fix plan in place.

## Verification checklist

Before delivering, confirm:

**Test plan** — scope defined (in/out); entry/exit criteria specified; risks identified with mitigations.

**Test cases** — every step has an expected result; preconditions documented; test data available.

## Test-case writing

**Do:** be specific and unambiguous; give an expected result for every step; test one thing per case; use consistent naming; keep cases maintainable.

**Don't:** assume tester knowledge; write cases too long; skip preconditions; forget edge cases; leave expected results vague.

## Anti-patterns

| Avoid | Why | Instead |
| --- | --- | --- |
| Vague test steps | Can't reproduce | Specific actions + expected results |
| Missing preconditions | Tests fail unexpectedly | Document all setup requirements |
| No test data | Tester blocked | Provide sample data or generation |
| Generic bug titles | Hard to track | Specific: "[Feature] issue when [action]" |
| Skip edge cases | Miss critical bugs | Include boundary values, nulls |

## Quiz format

Use an interactive prompt (clickable options) when available.

```
*Question n/n*
Question:  <what you need to know>
Why:       <what it unblocks in the deliverable>
Options:
  1. <option A> (RECOMMENDED) — <why here>
  2. <option B> — <tradeoff>
```

Quiz the user when: context is insufficient to cover the feature; a rule or path is unclear and you would otherwise assume; scope or priority is ambiguous; or test data / environment is unknown.

## Output layout

Place deliverables under a `test/` directory inside the path the user named — unless the user specifies a different location, or that path already has a `test/` directory (then use it). Confirm the location at scope lock before writing.

```md
{target path asked by user}/
  test/
    {feature name}-test-plan.md
    features/
      {flow-1}.feature          # one file per discovered flow
      {flow-2}.feature
      ...
    test-data.js                # single source of truth / dashboard database (incl. status)
    dashboard.html              # copied from templates/DASHBOARD.html (opens by double-click)
    regression-suite.json       # when a regression suite is requested
    test-cases.json             # optional plain-JSON export for test-management tools
```

Match the repo's existing QA/test documentation convention if one exists.

## Style

Short sentences, active voice. Every case traces to a requirement. No filler, no vague expected results.
