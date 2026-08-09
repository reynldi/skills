---
name: product-validation
description: Test the riskiest assumptions behind a candidate solution before building — assumption mapping plus cheap experiments (fake doors, prototype tests, concierge). Stage P3 of /product-workflow. Use when the user wants to validate an idea, design experiments, test demand, or invokes /product-validation.
---

# Product Validation

**Stage**: P3 of the product loop (/product-workflow). Prev: /product-discovery (target opportunity + competing solutions) · Feeds: /product-prioritization and /product-prd.
**Input**: candidate solution(s) with their assumptions — from `discovery.md`, or a PRD's open assumptions. Missing → ask or suggest /product-discovery.
**Output**: `validation.md` in the initiative folder — structure: `templates/validation.md` (read only when writing). Update in place as experiments run.
**Gate**: every riskiest assumption is tested with a pre-declared threshold, or explicitly accepted as a risk by the user.

Validation minimizes waste: assess the big risks early with the smallest test that can kill the idea.

## Process

1. **Decompose into assumptions** — for each candidate solution, write falsifiable assumptions across: desirable (do they want it), usable (can they figure it out), feasible (can we build it — route to engineers/spike, don't guess), viable (does it work for the product), ethical (could it harm).
2. **Map importance × evidence** (Assumptions Mapping): plot each assumption on a 2×2. The important-and-unevidenced quadrant is the riskiest — test those first, regardless of how easy other tests would be.
3. **Design the smallest test** — one assumption per test, never a full-concept "validation":
   - **Fake/painted door** — a real entry point to a nonexistent capability; measure click-through against a threshold; honest follow-up screen required.
   - **Prototype test** — clickable mock, ~5 sessions, task-based; tests comprehension/usability, not enthusiasm.
   - **Concierge / Wizard-of-Oz** — deliver the value manually to test desirability before automation.
   - **Feasibility spike** — time-boxed engineering question, handed to the dev pipeline.
4. **Pre-declare the decision rule** — success threshold, sample/duration, and what you'll do on pass/fail — BEFORE running. Moving thresholds after results is the cardinal sin.
5. **Run and record** — evidence per experiment: what ran, n, result vs threshold, verdict (validated / refuted / inconclusive).
6. **Route the verdicts** — refuted → back to the discovery tree (next solution or reframe); validated → into /product-prioritization and the PRD's evidence links; inconclusive → redesign or accept explicitly.

## Guards

- Commitment (time, money, reputation, data) is evidence; opinions and compliments are not.
- Test the lethal assumption, not the convenient one.
- Fake doors must resolve honestly (waitlist/explanation) and run briefly.
- Feasibility assumptions go to engineers — product does not self-certify feasibility.

## Final Check

- Assumption map present; riskiest quadrant identified and addressed first.
- Every experiment has a pre-declared threshold and a recorded verdict.
- Untested important assumptions are explicitly accepted by the user, not silently carried.
- Verdicts appended to `memory.md` (tried-and-failed included — they prevent re-litigating).
