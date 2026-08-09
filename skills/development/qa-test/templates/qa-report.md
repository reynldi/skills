# {Feature Name} - QA Report

**Status**: PASS <!-- PASS | FAIL -->
Scenarios: {pass}/{total} passed · Manual checklist items: {n}

## Automated Suites

| Suite  | Command | Result    |
| ------ | ------- | --------- |
| {name} | `{cmd}` | PASS/FAIL |

## Scenarios

<!-- Repeat per scenario: story happy paths, edge cases, failure paths, cross-story interactions, contract conformance. -->

### {US# / edge case} — {scenario}

- Steps/command: {…}
- Expected: {observable outcome from the spec}
- Actual: {…}
- Result: PASS / FAIL — {evidence}

## Failures & Routing

| Scenario   | Cause               | Routed to                                  | Status                  |
| ---------- | ------------------- | ------------------------------------------ | ----------------------- |
| {scenario} | bug / spec mismatch | /plan-implement T{###} / {planning stage} | open / fixed / re-tested |

## Manual Checklist (for the user)

- [ ] {steps} → expect {result}

## Sign-off

User sign-off: pending <!-- pending | approved ({date}) -->
