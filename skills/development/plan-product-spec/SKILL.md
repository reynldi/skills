---
name: plan-product-spec
description: Write a UX-centric Product Spec (feature/UX spec) from a feature idea, user problem, or goal — or from an APPROVED prd.md handed off by /product-workflow (for a problem/outcome-level PRD, use /product-prd) — flows, stories, states, edge cases; no KPIs, rollout, or implementation. Stage 1 of the /development-workflow pipeline. Use when the user asks to spec a feature or invokes /plan-product-spec.
---

# Product Spec Planner

**Stage**: 1 (Planning) of the feature pipeline — see /development-workflow. Next: /plan-technical-spec.
**Input**: feature name, user problem, or goal (from the user) — or an APPROVED `prd.md` handed off from /product-workflow. When a prd.md exists, it is the primary input: treat its problem, primary metric, appetite, and non-goals as fixed constraints (do not relitigate them), and use its initiative folder as the feature folder without re-confirmation.
**Output**: `product-spec.md` in the feature folder — structure: `templates/product-spec.md` (read it only when writing the spec).
**Gate**: Final Check passes and the user approves the spec (or explicitly accepts its open questions) — then set the spec's Status footer to APPROVED. Standalone use: suggest the next stage, don't run it.

**Feature folder**: always one folder per feature, holding all pipeline artifacts. Place and name it per the project's spec convention (look for `specs/`, `docs/`, prior `*-spec.md` files and mirror the parent directory and naming style); if none exists, create `specs/{feature-kebab-name}/`. Treat an existing folder as this feature's only when the user confirms; update an existing Product Spec in place.

**Context budget**: apply the "Risk and token budget" protocol in
../development-workflow/SKILL.md; load more only when it changes the current decision.

## Process

1. **Understand intent** — what is the user trying to achieve, what blocks them, what experience should the feature provide.
2. **Discover project context** — read README / CLAUDE.md / contributing docs; find existing specs and mirror their terminology and layout. Then (optional) explore related product behavior: search the feature's domain terms in routes/handlers/UI to understand the current UX. Use findings as product context, not implementation requirements.
3. **Identify actors** — only those directly involved in the feature.
4. **Map UX flows** — entry point, user actions, system response, success, cancel/exit, failure, return/re-entry.
5. **Decompose** the feature into meaningful capabilities or lifecycle flows.
6. **Write user stories** — `As a {actor}, I want {capability}, so that {benefit}`, each with a priority (P1, P2, …). A story earns its place when it has its own success/failure states — no stories for trivial UI interactions.
7. **Specify each story** — problem, expected UX/solution, functional behavior, relevant non-functional behavior (only what the user can perceive: latency, availability of the flow, data freshness).
8. **States & edge cases** — repeated actions, stale/invalid states, unavailable resources, permission/eligibility changes, failures, completed actions, re-entry. Only cases relevant to user-visible behavior.
9. **Assumptions vs open questions** — assumptions record safe defaults; Open Questions record decisions that materially change UX or behavior. Do not invent important product decisions. If material questions remain, present them to the user before completing the stage.

## Principles

- Start from user experience, not implementation. Describe observable, testable behavior in domain language.
- Cover the full feature — happy path plus important alternative states.
- Do not prescribe API, DB, infrastructure, or UI styling. No business analysis, KPIs, prioritization, or rollout unless requested.
- Keep requirements concise; use Mermaid only when it improves understanding.

## Final Check

- Main UX flows, states, and important edge cases covered.
- Stories are meaningful capabilities with priorities; requirements observable and testable.
- Existing product behavior respected; assumptions and open questions explicit.
- No implementation or business detail leaked in.
