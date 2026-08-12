# {Feature Name} - Plan Verification

**Lifecycle**: ACTIVE
**Owner**: {owner}
**Next consumer**: {stage / person}
**Review trigger**: {any verified input changes}

## Verdict

{2-4 sentence critical assessment}

**Status**: PASS <!-- PASS | PASS_WITH_NOTES | FAIL -->
Open findings: Blocking {n} · High {n} · Medium {n} · Low {n}
Verified inputs: product-spec.md `{sha/hash}` · technical-spec.md `{sha/hash}` · contract-spec.md `{sha/hash or absent}`

## Findings

<!-- Repeat per finding. Keep resolved findings with their resolution — they are the audit trail. -->

### {Finding}

**Severity**: Blocking / High / Medium / Low
**Area**: Product / Technical / Contract / Cross-Spec
**Issue**: {problem}
**Why it matters**: {impact}
**Recommendation**: {recommended change}
**Why**: {reason grounded in a current requirement}
**Resolution**: Open / Resolved — {how}

## Cross-Spec Consistency

| Area   | Product | Technical | Contract | Result                          |
| ------ | ------- | --------- | -------- | ------------------------------- |
| {item} | {state} | {state}   | {state}  | Consistent / Conflict / Missing |

## Decisions

| Question   | Decision | Recommended         | Applied to                 |
| ---------- | -------- | ------------------- | -------------------------- |
| {question} | {answer} | {recommended answer} | {spec file/section edited} |

## Assessment

### Must Resolve

- ...

### Safe to Defer

- ...

### Recommended Simplifications

- ...
