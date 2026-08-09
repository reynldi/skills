# {Initiative} - Metrics

## North Star (product level)

- **North Star**: {metric capturing delivered customer value} — {why moving it means the customer is better off}
- **Input metrics** (weekly-movable):
  1. {metric} — {believed causal link to the North Star}
  2. {…} (3–5 total)

## Feature Metrics ({bet name})

<!-- Only the HEART rows that serve this bet. -->

| Dimension | Goal | Signal | Metric (baseline → target, window) |
| --- | --- | --- | --- |
| {Adoption / Task success / …} | {…} | {…} | {…} |

**Primary (from PRD)**: {metric} — baseline {…} → target {…} within {window}

## Leading / Lagging Pairs

| Leading (moves in days) | Lagging (confirms) | Believed causal link |
| --- | --- | --- |
| {…} | {…} | {falsifiable statement} |

## Guardrails

- {metric} will not degrade by more than {amount}
- {support volume / latency / churn / trust bound}

**Definition approved by user**: pending <!-- pending | approved ({date}) — required before PRD approval -->

## Instrumentation Needs

- Track {event/property} when {behavior} (requirement for the dev pipeline — what, not how)

## Post-Launch Actuals

| Metric | Target | Actual @ window close | Verdict |
| --- | --- | --- | --- |
| {…} | {…} | {…} | HIT / MISS / INCONCLUSIVE |

**Learning routed to discovery**: {what the misses taught → discovery.md}
**Learnings sign-off**: pending <!-- pending | signed-off ({date}) -->

---

**Status**: CURRENT — last updated {date}
