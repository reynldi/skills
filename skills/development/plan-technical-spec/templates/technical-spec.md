# {Feature Name} - Technical Spec

**Lifecycle**: ACTIVE
**Owner**: {owner}
**Next consumer**: {stage / person}
**Review trigger**: {architecture, contract, or implementation change}

Product Spec: {link/path}

## Architecture Overview

{2-4 sentences: high-level design, major boundaries, data flow. No paths, method names, or code pointers here.}

## Components

- **{Component}** — {responsibility}
- **{Dependency / Provider}** — {purpose}
- **{Data Source}** — {purpose}

Only components required by the design.

## Model & Entities

<!-- Remove this section when no model/schema change is required. -->

### {Entity / Model}

{Purpose and lifecycle. Schema/structure when useful.}

### Migration Strategy

- {Migration}
- {Backfill if required}
- {Compatibility considerations}

Key files:

- `{path}`

## {Feature / Flow Name}

{1-2 paragraphs: the complete flow from trigger to outcome; frontend/backend interaction at a high level. No code pointers here.}

```mermaid
{One flowchart or sequence diagram of the main successful flow only.
Prefer a sequence diagram when frontend/backend interaction is significant.
No edge/error flows in this diagram.}
```

### APIs List

| Path                    | Method          | Version | Status                    |
| ----------------------- | --------------- | ------- | ------------------------- |
| `{path or event name}`  | `{method/type}` | `{v1}`  | New / Existing / Modified |

Full request/response/error/versioning detail belongs to `contract-spec.md` (/plan-contract-spec).

### Specification

{End-to-end implementation behavior. Include as relevant: frontend trigger and handling, API/event entry point, validation/auth, services involved, domain behavior, persistence, cache, external providers, events emitted/consumed, async processing, response behavior, frontend state update, observability, testing expectations. Use bullets or numbered steps when useful.}

#### Component Detail

<!-- Only important implementation-specific behavior, e.g.: cache keys/TTL and invalidation, rate-limit algorithm, token validation, idempotency strategy, retry/backoff, transaction boundaries, queue/topic configuration, event ordering, indexes/constraints, feature flags, deployment/migration ordering, rollback, logging. Avoid trivial detail. -->

#### Edge Cases

- {Case affecting correctness or reliability, and its expected handling}
- {Duplicate/retry/concurrency case}
- {Dependency or stale-state case}

#### Limitations

- {Known limitation / intentional trade-off / unsupported scenario — only if relevant}

Key files:

- `{path}`

---

**Status**: DRAFT <!-- DRAFT | APPROVED — set APPROVED only after user approval -->
