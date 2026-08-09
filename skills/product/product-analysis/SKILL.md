---
name: product-analysis
description: Decision-anchored product research — competitor teardowns, review mining, win/loss synthesis, and leading signals, synthesized into ranked product implications. Stage P2 (on demand) of /product-workflow. Use when the user asks for competitor analysis, market/product research, deep research on a product decision, or invokes /product-analysis.
---

# Product Analysis

**Stage**: P2 of the product loop (/product-workflow) — run on demand, whenever a decision needs external evidence.
**Input**: THE product decision this analysis serves. Refuse to produce a general-purpose landscape doc — if no decision is named, ask for it or infer it and confirm.
**Output**: `analysis.md` in the initiative folder — structure: `templates/analysis.md` (read only when writing). Living document: record an owner and an update trigger (competitor launch, lost-deal cluster, quarterly).
**Gate**: every evidence section ends with "so what → recommended product action"; implications ranked; user reviews them.

## Process

1. **Anchor the decision** — state it at the top of the artifact. Everything collected must serve it.
2. **Tier competitors** — direct / indirect / aspirational. Indirect is where disruption comes from; don't skip it.
3. **Plan evidence** — pick the 2–3 methods that fit the decision (never all):
   - **Product teardown** — sign up, walk every step, annotate what works and why; use when the decision hinges on HOW a competitor solves the job. Onboarding teardowns (patterns: checklists, deferred signup, progressive disclosure) when activation is the question.
   - **Review mining** — app stores, G2/Capterra, Reddit/HN, support forums. Prioritize 2–3-star reviews and "What do you dislike?" sections — engaged-but-frustrated users document exact gaps. Code themes, score frequency × severity.
   - **Win/loss synthesis** — interviews or existing notes from BOTH won and lost deals; open with the buyer's story, then drill down; qualitative questions only.
   - **Leading signals** — job postings (roadmap bets 6–18 months early), changelogs, pricing-page and docs changes, technical blog posts. Label every cited signal leading or lagging.
4. **Code the evidence** — every claim is a triplet: theme + count + representative verbatim (with source and date). Watch for survivorship bias (extremes dominate), recency bias, fake reviews, and context collapse.
5. **Rank implications** — do-now / watch / deliberately-ignore, each with the metric it should move. Classify capabilities as table-stakes / differentiator / deliberately-not-doing.
6. **Freshness** — stamp collection dates and the update trigger.

## Guards

- No feature matrix in the body — raw matrices go to an appendix; the body carries interpretation only.
- No claim without source + date; no section without a "so what".
- Tailor per audience only when asked (exec one-pager vs roadmap input); default is roadmap input.
- Market sizing, pricing strategy, TAM, and GTM are out of scope — competitor pricing pages are read only as roadmap signals.

## Final Check

- Decision stated up front; competitor tiers cover indirect players.
- Every claim is theme + count + verbatim; signals labeled leading/lagging.
- Implications ranked with target metrics; freshness metadata present.
- Insights appended to `memory.md`; opportunities surfaced here are candidates for the discovery tree — flagged UNVERIFIED until corroborated by interviews, never straight to a backlog.
