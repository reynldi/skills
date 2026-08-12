---
name: qa-planning
description: Generate QA test plans, Gherkin test cases, regression suites, and an optional HTML dashboard. Use for "create a test plan for X", "write test cases for X", or "build a regression suite".
disable-model-invocation: true
---

# QA Planning

Turn a feature or requirement into a test plan, Gherkin cases, regression suite, or optional dashboard. Generate only requested, reusable outputs.

This is Full QA planning. It is not the default for every change. Run it when
/plan-ready recorded Full QA depth in `tasks.md` (the choice criteria live there),
or when the user asks for it directly. Routine work uses /qa-test directly for
acceptance proof.

This is generation grounded in real context. Do not invent behavior — parse the requirement, and when context is thin, explore the code or quiz the user before writing. Every test step carries an expected result; every test case carries preconditions and test data.

**Context budget**: apply the "Risk and token budget" protocol in
../development-workflow/SKILL.md; load more only when it changes the current decision.

A feature is made of **flows**. Sign-in (sign in → verify OTP → done), onboarding, and invitations are separate flows, each its own Gherkin `.feature` file focused on one flow only. Discover the flows before writing any case.

## Inputs

- The feature or requirement to cover (e.g. "the user authentication feature").
- Optional supporting material: a spec (markdown, pasted, or a Confluence URL fetched via the Atlassian MCP), a Jira/Linear ticket, or an existing test suite to extend.

## QA assessment

Before planning, confirm Full QA is justified against /plan-ready's "Choose QA depth"
criteria (or re-apply them when running standalone). State the justification. If Full
is not justified, recommend Focused or Feature QA through /qa-test and do not generate
the large suite.

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

- Gherkin — `templates/TEST-CASE.feature`, **one `.feature` file per discovered flow** (Given/When/Then, one behavior per scenario, `Scenario Outline` + `Examples` for variations). A `.feature` file covers a single flow end to end (e.g. `signin.feature`: sign in → verify OTP → done) — never mix flows in one file.
- Dashboard data — `templates/test-data.js` only when the user requests the dashboard. It holds the plan reference, every flow, and every case as a `window.TEST_DATA = { ... }` assignment so it loads over `file://` by double-click.

Every case: unique id, title, priority (P0/P1/P2), preconditions, test data, ordered steps each with an expected result, and a traceability link to the requirement.

When the dashboard is generated, each case in `test-data.js` also carries a `status`
field (`not_run`, `pass`, `fail`, `blocked`, `skipped`; default `not_run`) — keep it
current there. Without the dashboard, execution status lives in /qa-test's
`qa-report.md`, not in the planning artifacts. Do not produce a standalone JSON
test-case export.

### Regression suite

A curated selection of existing cases plus new ones, grouped by flow and tagged by priority and run cadence. P0 cases run always; P1 weekly+; P2 at releases. Deliver as a JSON suite per `templates/REGRESSION-SUITE.json` — each entry carries the case id, flow, priority, and cadence, sourced from the `.feature` files — plus a short index. State explicitly what was excluded and why — never silently drop coverage.

### HTML dashboard

`dashboard.html` reads `test-data.js` (`window.TEST_DATA`) as its live database and opens by double-click — no server needed. It lists the plan and flows in a summary table with status rollups; clicking a flow reveals its test cases in a table with per-case status and steps. Do not author the HTML from scratch — copy `templates/DASHBOARD.html` into the output location unchanged. The dashboard never hardcodes cases; all data comes from `test-data.js`, so editing a case's `status` there and refreshing updates the dashboard.

## Quality bar

P0 covers critical, security, or data-integrity paths and runs always; P1 covers common flows; P2 covers lower-risk edges. PASS needs all P0, no critical issue, and documented P1 gaps. Every case has preconditions, data, actions, observable results, and requirement traceability.

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
    test-data.js                # only when the dashboard is requested — its database (incl. status)
    dashboard.html              # only when requested — copied from templates/DASHBOARD.html
    regression-suite.json       # when a regression suite is requested
```

Match the repo's existing QA/test documentation convention if one exists.

## Style

Short sentences, active voice. Every case traces to a requirement. No filler, no vague expected results.
