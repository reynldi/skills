---
name: product-discovery
description: Continuous product discovery — find and evidence problems worth solving via customer interviews and an Opportunity Solution Tree. Stage P1 of /product-workflow. Use when the user wants to run discovery, understand a customer problem space, plan interviews, or invokes /product-discovery.
---

# Product Discovery

**Stage**: P1 of the product loop (/product-workflow) — continuous, not a one-off phase. Feeds /product-validation and /product-prioritization.
**Input**: a product outcome (behavior/sentiment metric, not output) and a target customer theory — ask for both if missing.
**Output**: `discovery.md` in the initiative folder — structure: `templates/discovery.md` (read only when writing). Living artifact: update in place after every synthesis round.
**Gate**: every opportunity on the tree is backed by interview evidence, and the target opportunity is chosen with the user.

Discovery de-risks *valuable*: teams receive problems and desired outcomes, not feature lists.

## Process

1. **Fix the outcome** — one product outcome the discovery serves (metric the team can influence), plus the target customer theory. One tree per outcome; never a company-wide mega-tree.
2. **Draw the experience map** — sketch the customer's current experience end-to-end before interviewing; the gaps expose what you don't know and become interview territory.
3. **Interview** (or guide the user's interviews — prepare guides, then synthesize their notes):
   - Recruit people who recently DID the behavior or switched — never hypothetical prospects.
   - Story-based: "tell me about the last time you…" and walk the timeline chronologically. People are unreliable about generalizations and future intent.
   - The Mom Test rules: talk about their life, not your idea; specifics in the past, not opinions about the future; talk less, tolerate silence. Deflect compliments; anchor fluffy claims ("when did that last happen? what did it cost you?").
   - For switch decisions, use the JTBD timeline (first thought → passive looking → active looking → deciding) and the Four Forces (push + pull vs anxiety + habit) to find the job the product is hired for.
   - Write a one-page **interview snapshot** per interview: memorable quote, opportunities heard, insights, experience-map fragment.
4. **Synthesize every 3–4 interviews** — add opportunities (needs, pains, desires) to the Opportunity Solution Tree. Opportunities come only from customer evidence — interviews are first-class; analysis-sourced entries (reviews, tickets, telemetry) enter flagged UNVERIFIED until corroborated by an interview; never invented. Litmus test: if there's only one way to address it, it's a solution in disguise — reframe it.
5. **Target an opportunity** — compare siblings on the tree by impact on the outcome and strength of evidence. Never prioritize opportunities by effort — effort belongs to solution evaluation.
6. **Generate 2–3 competing solutions** for the target opportunity, then hand their risky assumptions to /product-validation.

**No interviews available?** Either (a) pause P1 and make the artifact an interview plan (who, recruiting channel, guide), or (b) proceed on proxy evidence (support tickets, reviews via /product-analysis, telemetry) with every opportunity flagged UNVERIFIED and the gap explicitly accepted by the user.

## Guards

- Feature requests are de-laundered with Five Whys: log the underlying opportunity, never the requested feature.
- Compliments, "I would definitely use it", and hypotheticals are bad data; past behavior and commitment (time, money, reputation) are evidence.
- Never overreact to a single interview — patterns need 3+ occurrences.
- Never pitch your idea during an interview; if you must show it, do it last.

## Final Check

- Outcome and target customer stated; experience map present.
- Every opportunity traces to snapshot evidence; solutions-in-disguise reframed.
- Target opportunity chosen with the user and marked on the tree; competing solutions listed with their riskiest assumptions.
- New facts and decisions appended to `memory.md`.
