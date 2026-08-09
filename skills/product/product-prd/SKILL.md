---
name: product-prd
description: Write a lean, problem-first PRD for the chosen bet — 1-pager, Shape Up pitch, or PR/FAQ by bet size — and hand it to the /workflow development pipeline. Stage P5 of /product-workflow. Use when the user asks for a PRD, product one-pager, pitch, PR/FAQ, or invokes /product-prd.
---

# Product PRD

**Stage**: P5 of the product loop (/product-workflow). Prev: /product-prioritization (the approved bet) · Next: handoff to /workflow (its /plan-product-spec consumes this PRD).
**Input**: the chosen bet + evidence links (`discovery.md`, `analysis.md`, `validation.md`, `priorities.md`). Missing evidence → say what's unvalidated, don't fabricate confidence.
**Output**: `prd.md` in the initiative folder — templates by bet size: `templates/prd.md` (1-pager and pitch), `templates/pr-faq.md` (new-product bets). Ends with `**Status**: DRAFT | APPROVED`.
**Gate**: gating order below passes → self-review passes → `metrics.md` (P6, /product-metrics) defined and approved → user approves → set Status APPROVED → hand off to /workflow with this PRD as stage-1 input.

The PRD frames the problem and the outcome. It does not design the product — screens, fields, and flows belong to /plan-product-spec; architecture to /plan-technical-spec.

## Fork by bet size

- **Enhancement** → 1-pager: problem, who/when/evidence, why now, goal metric, non-goals.
- **Cycle-sized bet** → Shape Up pitch shape: problem, appetite, fat-marker solution, rabbit holes, no-gos.
- **New-product bet** → PR/FAQ: one-page future-dated press release + FAQ limited to risk, dependency, and hardest-questions content (market-sizing, pricing, and P&L questions are out of scope for this skill).

## Gating order (each gate must pass before writing the next section)

1. **Problem first** — problem statement in the user's terms, with who has it, when it bites, and evidence links. Zero solution language; "we need an AI chatbot" gets reversed via JTBD/Five-Whys into the job to be done before it's accepted.
2. **Metrics falsifiable** — exactly ONE primary metric with baseline, target, and measurement window; guardrails as non-degradation bounds ("{metric} will not degrade more than {amount}"). Reject "improve engagement"-shaped goals.
3. **Appetite, not estimate** — a time budget the solution is designed within (Shape Up), set with the user.
4. **Solution direction at fat-marker altitude** — key flows and principles concrete enough to evaluate, abstract enough to leave design room. No screens, no field lists.
5. **Non-goals** — minimum 3, each naming a plausible thing deliberately NOT being built; plus scope tiers (must-ship / cut-first) tied to the appetite so cuts are pre-decided.
6. **Rabbit holes** — risky details called out and pre-solved or explicitly patched.

## Self-review (PR/FAQ mechanics, adapted)

Before presenting, critique the draft fresh, truth-seeking not selling: Is the customer and their problem unmistakable in one read? Is the problem real (evidence) or asserted? What's the hardest question a skeptic would ask — is it answered? Where does this fail? Fix, then present to the user for approval.

## Final Check

- Problem section has zero solution language and live evidence links; unvalidated assumptions declared (route big ones to /product-validation first).
- One primary metric + guardrails, all falsifiable; appetite set; non-goals ≥ 3; scope tiers present.
- `metrics.md` exists and its primary metric matches this PRD's Success Metric (baseline/target/window identical) before Status is set APPROVED.
- Size cap respected: 1–2 pages (enhancement/pitch), ~6 pages ceiling (PR/FAQ).
- On approval: Status APPROVED, decision + why appended to `memory.md`, handoff offered to /workflow.
