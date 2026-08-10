---
name: plan-technical-spec
description: Create an implementation-ready Technical Spec from a Product Spec. Stage 2 of /development-workflow, after /plan-product-spec. Use when the user asks to design a feature's technical implementation, plan the architecture, or invokes /plan-technical-spec.
---

# Technical Spec Planner

**Stage**: 2 (Planning). Prev: /plan-product-spec · Next: /plan-contract-spec.
**Input**: `product-spec.md` in the feature folder. Not found or ambiguous → ask the user or suggest /plan-product-spec. Status still DRAFT → warn the user and confirm before proceeding.
**Output**: `technical-spec.md` beside the Product Spec — structure: `templates/technical-spec.md` (read only when writing). Update in place on re-runs.
**Gate**: Final Check passes; unresolved product questions surfaced, never answered unilaterally; user approves before the next stage — then set the Status footer to APPROVED.

## Process

1. **Understand the Product Spec** — required flows and behavior; separate confirmed requirements from assumptions/open questions. Do not invent product behavior; carry unresolved product questions into the spec's Open Questions and surface them to the user.
2. **Discover project conventions** — check the available-skills list, CLAUDE.md / AGENTS.md / CONTRIBUTING / docs for backend, frontend, database, API, and testing conventions; note in the spec which were applied. Prefer project conventions over generic approaches unless they compromise correctness or the Product Spec.
3. **Explore the codebase** — related features, models, APIs, events, services, libraries, infrastructure, tests. Prefer reuse or extension over duplication.
4. **Define architecture** — the simplest design that satisfies the Product Spec: ownership boundaries, data flow, persistence, contract surfaces, events/background jobs, security, failure handling, observability, deployment impact.
5. **Design components** — only what is actually needed; prefer existing dependencies, abstractions, data sources, and providers. No speculative abstractions or premature infrastructure.
6. **Design the data model** (if needed) — entities/schema changes, migration and backfill strategy, indexes/constraints, ownership, lifecycle, backward compatibility.
7. **Name contract surfaces** — the APIs List table of new/modified/existing endpoints and events. Reuse conventions from existing contract specs in the project. Full request/response/error/versioning detail belongs to /plan-contract-spec — do not define it here.
8. **Plan the end-to-end flow** — from trigger to outcome through the project's actual layers (e.g. Frontend → API/Event → Service → Persistence → Response for a client/server app; adapt for CLIs, libraries, pipelines).
9. **Plan reliability** — from: validation, idempotency, duplicate processing, retries, timeouts, partial failure, concurrency, transactions, ordering, stale data, rate limits, cache consistency, authn/authz, graceful degradation. Only concerns relevant to this feature.
10. **Plan quality** — the test types relevant to this project (e.g. unit, integration, contract, UI, migration) focused on important behavior and failure boundaries, following project testing conventions.
11. **Simplicity review** — can existing code handle this? Can a component be removed? Is a new abstraction really needed? Are responsibilities clearly owned? Is operational complexity justified?

## Principles

- Product Spec is the source of truth for behavior; project conventions are the source of truth for implementation style.
- Prefer boring, proven technology; reuse over new abstraction; explicit behavior over hidden magic.
- Preserve backward compatibility when reasonable; make failure behavior predictable.
- Do not optimize for hypothetical scale without evidence.
- No file paths, method names, or code pointers in the Architecture Overview or main-flow prose; concrete paths only under `Key files`.

## Final Check

- Product Spec behavior fully covered; no product behavior invented.
- Existing patterns and project conventions reused where practical; every new dependency/abstraction justified.
- Data ownership, migration strategy, and relevant reliability concerns clear.
- Component/boundary responsibilities clear (frontend/backend split when the project has one); edge cases focus on correctness; limitations and trade-offs explicit.
- No code-level detail in high-level sections.
