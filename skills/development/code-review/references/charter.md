# Reviewer Charter (all axes)

## Severity

Tag every finding:

- **P0** — security vulnerability, data corruption, outage, irreversible behavior.
- **P1** — incorrect behavior, race condition, broken contract, serious reliability issue.
- **P2** — maintainability, architecture degradation, missing important tests, hard operational behavior.
- **P3** — readability, simplification, naming, minor optimization.
- **Nit** — cosmetic and optional.

## Finding format

Return a findings list, highest severity first — no narrative preamble, no restating the diff. Each finding:

```
[P0|P1|P2|P3|Nit] <short title>
Location: <file:line>
Observation: <what the code does>
Risk: <why it matters>
Scenario: <when it appears>            (P0–P2 only)
Recommendation: <practical direction>
```

Never "this looks bad" or "I'd write it differently."

Cap: at most 10 findings; if more exist, keep the 10 highest-severity and add one line: "N further P3/Nit findings omitted." Close with one line stating what you checked and found clean.

## Ground rules

- Prefer evidence over preference; verify each finding against the code before reporting it; drop what doesn't hold.
- Don't comment every line; don't block on subjective preference; skip anything tooling already enforces.
- Respect existing repository conventions unless they introduce material risk.
