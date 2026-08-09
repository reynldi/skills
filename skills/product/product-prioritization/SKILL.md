---
name: product-prioritization
description: Choose product bets transparently — opportunity scoring for the problem space, evidence-cited RICE/ICE for solutions, Kano when satisfaction shape matters, Now-Next-Later roadmap. Stage P4 of /product-workflow. Use when the user asks to prioritize a backlog or opportunities, build a roadmap, score bets, or invokes /product-prioritization.
---

# Product Prioritization

**Stage**: P4 of the product loop (/product-workflow). Prev: /product-discovery, /product-validation · Next: /product-prd.
**Input**: opportunities (problem space) or candidate bets (solution space) plus their evidence from `discovery.md` / `analysis.md` / `validation.md`.
**Output**: `priorities.md` in the initiative folder — structure: `templates/priorities.md` (read only when writing). Update in place; the roadmap survives priority changes because it has no dates.
**Gate**: user approves the top bet(s); the reasoning is recorded, not just the ranking.

Strategy principles applied: Focus (few impactful bets), Powered by Insights (evidence-cited inputs), Transparency (reasoning visible), Placing Bets (portfolio of quarterly bets).

## Process

1. **Fix the altitude** — problem space or solution space; never mix in one table.
   - **Problem space** → opportunity scoring (Outcome-Driven style): rate importance and current satisfaction per opportunity; `opportunity = importance + max(importance − satisfaction, 0)`. Underserved = important + unsatisfied. Never rank opportunities by effort.
   - **Solution space** → RICE (`Reach × Impact × Confidence / Effort`) or ICE for triage.
2. **Evidence-cite every cell** — each Reach/Impact/Confidence value names its source (discovery snapshot, analysis theme, validation verdict, telemetry). A guessed cell caps Confidence at 50%. No source, no score.
3. **Optional lenses, gated by cost**:
   - **Kano** (functional/dysfunctional question pairs → basic / performance / delighter) — solution space only; it shapes satisfaction expectations, it does not pick what to build. Use when over/under-investing in delight is the live question.
   - **Cost of Delay / CD3** — when timing matters materially; the economically honest tiebreaker for sequence.
4. **Roadmap as Now-Next-Later** — columns are confidence horizons, not dates; entries are outcomes/opportunities, not feature promises. Now = validated + committed; Next = validated direction, solution open; Later = opportunity acknowledged.
5. **Record the bet** — the chosen bet(s), what was deliberately not chosen and why, and the review trigger. Append the decision + why to `memory.md`.

## Guards

- The score is a sorting hypothesis, never the decision — the decision is made by a human reading the evidence, and recorded with its why.
- Anti-RICE-theater: no conviction-laundering (uncited cells), no effort-dominance (sanity-check that low-effort trivia isn't outranking validated opportunities).
- Kano never applies to needs/opportunities — that's Ulwick's critique; use opportunity scoring there.

## Final Check

- Altitude explicit; every score cell cited; capped confidence where guessed.
- Now-Next-Later present with outcomes, not dated features.
- Chosen bet approved by the user with reasoning recorded; rejected alternatives noted.
