---
name: qa-planning
description: Generate QA test plans, manual test cases, and regression test suites. Test cases are produced in both Gherkin and JSON format. Use for "create a test plan for X", "write test cases for X", or "build a regression suite".
disable-model-invocation: true
---

# QA Planning

Turn a feature or requirement into structured QA deliverables: a **test plan**, **manual test cases** (Gherkin + JSON), or a **regression suite**. Pick the deliverable from what the user asks; a single request can span several (a plan usually implies cases).

This is generation grounded in real context. Do not invent behavior — parse the requirement, and when context is thin, explore the code or quiz the user before writing. Every test step carries an expected result; every test case carries preconditions and test data.

## Inputs

- The feature or requirement to cover (e.g. "the user authentication feature").
- Optional supporting material: a spec (markdown, pasted, or a Confluence URL fetched via the Atlassian MCP), a Jira/Linear ticket, or an existing test suite to extend.

## Process

1. **Input.** Restate the feature and the deliverable(s) requested in one sentence.

2. **Analyze.** Understand the context. Parse the existing feature/requirement. Identify the test types needed (functional, integration, UI, negative, boundary, security, performance, accessibility). Determine scope and priorities, and enumerate edge cases and variations — boundary values, nulls, empty states, concurrency, permissions.

3. **Explore codebase — only if needed.** ONLY IF the session does not already carry enough context, explore the code. Search comprehensively but only the relevant feature — entry points, validation rules, error paths, and states that tests must assert against.

4. **Quiz the user.** If context is still missing or you are relying on an assumption, ask before writing — assumptions are not allowed. Use the quiz format below. Prefer an interactive prompt (clickable options) when available.

5. **Generate.** Produce the structured deliverable(s) using the templates in this skill folder. Apply the priority model and best practices below. Cover the edge cases and variations found in step 2, not just the happy path.

6. **Validate.** Check the generated output against the current spec and context: completeness (every requirement traced to at least one case), traceability (each case links to a requirement or user story), and that every step is actionable with an unambiguous expected result. Report anything you could not cover.

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

- Gherkin — `templates/TEST-CASE.feature` (Given/When/Then, one behavior per scenario, `Scenario Outline` + `Examples` for variations).
- JSON — `templates/TEST-CASE.json` (machine-readable, one object per case, importable into test-management tools).

Every case: unique id, title, priority (P0/P1/P2), preconditions, test data, ordered steps each with an expected result, and a traceability link to the requirement.

### Regression suite

A curated selection of existing cases plus new ones, grouped by feature area and tagged by priority and run cadence. P0 cases run always; P1 weekly+; P2 at releases. Deliver as a JSON suite (array of case ids with tags) plus a short index. State explicitly what was excluded and why — never silently drop coverage.

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

```md
{target path asked by user}/
  {feature name}/
    - {feature name}-test-plan.md
    - {feature name}-test-cases.feature
    - {feature name}-test-cases.json
    - {feature name}-regression-suite.json   # when a regression suite is requested
```

Match the repo's existing QA/test documentation convention if one exists. If none exists, ask where to save before writing any file.

## Style

Short sentences, active voice. Every case traces to a requirement. No filler, no vague expected results.
