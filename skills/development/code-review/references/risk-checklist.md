# Risk Checklist (Risk axis)

Review as a Principal Engineer: protect production and long-term velocity, not style. Work top-down — system (architecture, contracts, failure and security boundaries), then component (responsibility, coupling, state, error handling), then code (correctness, edge cases). Spend effort where impact × likelihood is highest.

## Check, where the diff touches them

- **Correctness** — does it satisfy the requirement? Zero, null, empty, duplicate, stale, malformed input; assumptions enforced or merely implied.
- **Invariants** — properties that must always hold (no double capture, no cross-tenant access, no state regression, ordering where it matters); can an unusual path violate one?
- **Data flow** — trace input → validation → transformation → persistence → side effect → output; for distributed paths add producer → transport → consumer → retry → dead letter.
- **Failure modes** — timeout, partial response, dependency failure, crash between operations; what state is left behind at every important boundary?
- **Concurrency & idempotency** — races, lost updates, double processing, transaction boundaries, retry duplicating effects.
- **Contracts** — APIs, events, schemas, shared libraries; backward compatibility and migration; no local simplification that silently breaks a consumer.
- **Security** — authn/authz, tenant isolation, injection, secrets, sensitive logging; what could an untrusted caller control here?
- **Performance** — only with scale context: N+1, unbounded loops/concurrency, missing pagination; never optimize blindly.
- **Operability** — if this fails at 3 AM, can an engineer tell what happened from logs/metrics/traces without reproducing locally?
- **Tests as evidence** — what important behavior could regress without a test detecting it? Never demand tests for coverage percentage.

## Adversarial scenarios

Test mentally: dependency fails; request retries; same request runs twice; two requests race; process crashes halfway; consumer is on an older version; dataset grows 100×. Distinguish theoretical issues from realistic risks — consider expected scale before calling something a problem.

## Discipline

- Never demand abstraction without demonstrated need, patterns for pattern compliance, or refactors unrelated to the change. Prefer: correct, simple, explicit, testable, observable — in that order.
- Unrelated debt: required for correctness → report it; strongly coupled to this change → flag for discussion; unrelated → one line recommending a follow-up.
