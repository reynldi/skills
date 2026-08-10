---
name: plan-contract-spec
description: Create or update contract-spec.md (REST/gRPC/Event contracts) from a Technical Spec. Stage 3 of /development-workflow, after /plan-technical-spec. Use when the user asks to define API or event contracts, write a contract spec, or invokes /plan-contract-spec.
---

# Contract Spec Planner

**Stage**: 3 (Planning). Prev: /plan-technical-spec · Next: /plan-verification.
**Input**: `technical-spec.md` in the feature folder. Missing → ask the user or suggest /plan-technical-spec. Status still DRAFT → warn the user and confirm before proceeding.
**Output**: `contract-spec.md` in the same folder, ending with the standard footer `**Status**: DRAFT | APPROVED`. Templates — read only the type(s) the feature actually uses: `templates/rest.md`, `templates/grpc.md`, `templates/event.md`.
**Gate**: Final Check passes; user approves — then set the Status footer to APPROVED. If the feature introduces no new/changed external interfaces, write a one-paragraph `contract-spec.md` saying so (same footer) and present it for approval.

## Process

1. **Read the Technical Spec** — identify every new or modified contract from its APIs List. Do not invent behavior beyond the Product/Technical Specs.
2. **Discover existing contract conventions** — read any project API/backend/event/proto skills; locate contract sources of truth (OpenAPI/Swagger files, `*.proto` dirs, route registration, event schema files) via glob/grep; read 1-2 representative endpoints/events to extract envelope, error model, auth header, naming case, pagination, versioning. If none exist, use the template defaults and say so in the spec.
3. **Define each contract boundary** — caller/producer, receiver/consumer, input, output, validation, auth/permission, idempotency, errors, version, compatibility. Tag every contract **New / Modified / Existing**.
4. **Reliability** — apply to every event contract and every mutating endpoint (skip for pure reads): duplicate requests/messages, retries, timeouts, ordering, concurrency, correlation/tracing, DLQ, schema evolution.
5. **Compatibility** — prefer additive changes; never change existing field semantics; never reuse removed protobuf field numbers; define an explicit version change when compatibility cannot be preserved.

**Update mode**: when `contract-spec.md` already exists, only touch contracts the Technical Spec changes; keep New/Modified/Existing tags accurate.
**Other interface styles** (GraphQL, WebSocket, webhooks): adapt the nearest template and document the same boundary fields.

## Principles

- Project contract conventions take precedence; use one canonical envelope/error format where available.
- Contracts describe interfaces, not internal implementation; be explicit about required vs optional fields.
- Only document contracts the feature uses — never generate unused REST/RPC/Event sections.
- Do not add fields, headers, or metadata without a concrete need; do not expose internals.

## Final Check

- Contracts match the Product and Technical Specs; every contract serves a defined feature flow.
- Auth, required/optional fields, errors, idempotency, and versioning are explicit and intentional.
- Examples match field tables exactly; event delivery semantics match the actual broker.
- Every contract references its Technical Spec section and carries a New/Modified/Existing tag.
