# {Feature name} - Test Plan

## Overview

{2 to 4 sentences: what is being tested and why. Reference the requirement,
spec, or ticket. A simple mermaid flowchart of the feature under test is
welcome when it clarifies scope.}

- **Requirement / spec:** {link or path}
- **Owner:** {name}
- **Target release:** {version / date}

## Scope

### In scope

- {feature area / flow to be tested}

### Out of scope

- {explicitly excluded area, and why}

## Test types

{Check the ones that apply and note focus areas.}

- [ ] Functional
- [ ] Integration
- [ ] UI / visual
- [ ] Negative / error handling
- [ ] Boundary / edge cases
- [ ] Security
- [ ] Performance
- [ ] Accessibility

## Environments & test data

- **Environments:** {e.g. staging, browsers/devices, OS}
- **Test data:** {accounts, seed data, fixtures — how to obtain or generate}

## Entry criteria

- {e.g. feature deployed to staging, spec approved, test data ready}

## Exit criteria

- {e.g. all P0 executed and passing, no open critical bugs}

## Risks & mitigations

| Risk | Impact | Likelihood | Mitigation |
| --- | --- | --- | --- |
| {risk} | High/Med/Low | High/Med/Low | {mitigation} |

## Pass / fail criteria

- **PASS:** all P0 pass, 90%+ P1 pass, no critical bugs open.
- **FAIL (block release):** any P0 fails, critical bug, security vulnerability, or data-loss scenario.
- **CONDITIONAL:** P1 failures with documented workarounds, known issues logged, fix plan in place.

## Traceability

| Requirement / User story | Test case ids |
| --- | --- |
| {req id / story} | {TC-001, TC-002} |
