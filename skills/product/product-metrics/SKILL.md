---
name: product-metrics
description: Define and measure product success — North Star + input metrics, HEART for feature-level UX, leading/lagging pairs, guardrails. Stage P6 of /product-workflow, and the post-launch measurement loop. Use when the user asks to define success metrics, a North Star, KPIs for a feature, or invokes /product-metrics.
---

# Product Metrics

**Stage**: P6 (define — after the PRD's problem gate, before its approval) and P7 (measure — post-launch update of the same artifact) of the product loop (/product-workflow).
**Input**: the product outcome or a PRD's primary metric; post-launch: `implementation-report.md`/`qa-report.md` existence signals it's time to measure.
**Output**: `metrics.md` in the initiative folder — structure: `templates/metrics.md` (read only when writing). Update in place with actuals.
**Gate**: every metric is falsifiable (baseline + target + window) and instrumentable in principle; user approves. Outcomes over output — no metric may reward shipping volume.

## Process

1. **North Star** (product level, once per product) — one metric capturing the value customers actually receive (not revenue, not vanity), decomposed into 3–5 input metrics a team can move week to week. Check: if the North Star moves, is the customer necessarily better off?
2. **Feature level** — Google HEART, but only the relevant rows: Happiness, Engagement, Adoption, Retention, Task success — each derived Goals → Signals → Metrics. Skip rows that don't serve the bet.
3. **Pair leading and lagging** — every lagging outcome (retention, the primary PRD metric) gets a leading indicator that moves within days; state the believed causal link so it can be falsified.
4. **Guardrails** — non-degradation bounds on what the win must not damage: support volume, latency, churn, trust ("{metric} will not degrade more than {amount}").
5. **Anti-vanity lint** — for each metric: would a change alter a decision? Counts without denominators are banned (use rates); cumulative charts banned; "engagement" without a named behavior banned.
6. **Post-launch measurement** — record the window-close date in `memory.md` as the P7 re-entry trigger (a future session resumes from it); at the close, record actuals vs target; verdict per metric (hit / miss / inconclusive); misses route back to /product-discovery as learning, not blame. Append the verdict to `memory.md`.

## Final Check

- North Star passes the customer-value check; input metrics are weekly-movable.
- Every metric has baseline + target + window (baseline unknown → `BASELINE: TBD` plus the instrumentation task that will establish it — blocks the window start, not PRD approval); leading/lagging pairs with stated causal links.
- Guardrails cover the plausible damage; vanity lint applied.
- Instrumentation needs are named as requirements for the PRD/dev pipeline (what to track, not how).
