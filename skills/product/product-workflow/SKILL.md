---
name: product-workflow
description: Orchestrate the product loop — Discovery → Analysis (on demand) → Validation → Prioritization → PRD → Metrics → handoff to /workflow (build) → Measure → back to Discovery — with approval gates, shared memory, and .spectrum.json-configured multi-model delegation. Use when the user wants to run product work end-to-end, from problem to shipped-and-measured bet, or invokes /product-workflow.
---

# Product Workflow

Product-side coordinator — the counterpart of /workflow (development). It runs a **loop**, not a line: continuous discovery feeds bets; shipped bets feed measurement; measurement feeds discovery. Grounded in the Product Operating Model: teams receive problems and desired outcomes, not feature lists; outcomes over output. Product stages de-risk *valuable* and *viable*; the dev pipeline de-risks *usable* and *feasible*.

## Stages

| #  | Stage          | Skill                  | Artifact      | Gate                                            |
| -- | -------------- | ---------------------- | ------------- | ----------------------------------------------- |
| P0 | Discover setup | (below)                | memory.md     | —                                               |
| P1 | Discovery      | product-discovery      | discovery.md  | target opportunity chosen with user             |
| P2 | Analysis       | product-analysis       | analysis.md   | on demand — decision-ready implications         |
| P3 | Validation     | product-validation     | validation.md | riskiest assumptions tested or accepted         |
| P4 | Prioritization | product-prioritization | priorities.md | user approves the bet                           |
| P5 | PRD            | product-prd            | prd.md        | gating order + self-review + user approval      |
| P6 | Metrics        | product-metrics        | metrics.md    | falsifiable + approved (before PRD approval)    |
| →  | Build          | **/workflow** (stages 1–8) | its artifacts | its gates — prd.md is stage-1 input         |
| P7 | Measure        | product-metrics (update) | metrics.md  | actuals recorded + user signs off on learnings → back to P1 |

All artifacts share one initiative folder (same folder the dev pipeline uses for the feature) and one `memory.md`.

## Stage P0: Setup

Once per initiative: read the project's product context (README, existing specs, prior discovery/analysis artifacts); read `.spectrum.json` at the project root (semantics: the workflow skill's Configuration section — installed as the sibling folder `workflow/`; in this repo, `skills/development/workflow/`). **Create the initiative folder now**: `{artifacts.specsRoot|specs}/{initiative-kebab-name}/`, create `memory.md` in it from the workflow skill's `templates/memory.md` (if it exists, append — never recreate) and record the folder path in it; the dev pipeline's stage 1 MUST reuse this folder (its own folder rule applies only to standalone runs). Note installed providers (workflow `bin/agent.sh list`). Summarize to the user, then start.

## Rules

- Entry at any stage — a user with an existing PRD starts at P5; one with a validated bet at P4. **Resume**: read the artifacts' Status lines and `memory.md`; living artifacts (CURRENT) re-enter where the loop left off; confirm the resume point with the user.
- User-approval gates are hard stops (P1 target, P4 bet, P5 PRD, P7 sign-on-learnings). On approval, record it in the artifact.
- P2 is on demand — run it when a decision lacks external evidence, never as a ritual. **P5/P6 choreography**: run P6 after P5's gate 1 (problem) and before P5's gate 2 — the PRD's Success Metric section transcribes metrics.md's primary metric, so the PRD is falsifiable before it advances.
- **Handoff to build**: only an APPROVED prd.md crosses to /workflow; it becomes /plan-product-spec's input. Product artifacts stay authoritative for *why*; dev artifacts for *what/how*.
- **Loop-backs**: refuted validation → discovery tree; missed metrics → discovery as learning; scope changes during build → /workflow's scope-control routes product-level changes back here (P5 or earlier), never patched downstream.
- **Delegation & reuse**: same machinery as /workflow — handoff briefs from `workflow/templates/handoff.md`, run via `workflow/bin/agent.sh`, roles/models/effort resolved from `.spectrum.json`, agent reuse per the workflow skill's Agent reuse & rotation rule and the config's `reuse` policy.
- Boundary: no pricing, TAM, GTM, or unit-economics work — out of scope by design.
- Keep the user oriented: one status line per stage transition (`{stage}: {status} → {next}`).
