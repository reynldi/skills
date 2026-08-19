# {Feature Name} - PRD Verification

**Lifecycle**: ACTIVE
**Owner**: {owner}
**Next consumer**: {/product-publish-prd, or /development-workflow}
**Review trigger**: the PRD changes

## Verdict

{2 to 4 sentences. Say what is true, not what is nice.}

**Status**: PASS <!-- PASS | PASS_WITH_NOTES | FAIL -->
Open findings: Blocking {n} · High {n} · Medium {n} · Low {n}
Verified PRD: `prd.md` `{sha or hash}`
References read: memory.md {yes/absent} · discovery.md {…} · validation.md {…} · priorities.md {…} · metrics.md {…}

## Gate check

<!-- The same 10 checks as /product-publish-prd. A PASS here must give a PASS there. -->

| # | Part | Result | Note |
|---|------|--------|------|
| 1 | Shape | Pass / Fail | {…} |
| 2 | Placeholders | Pass / Fail | {…} |
| 3 | PIC lines | Pass / Fail | {…} |
| 4 | Introduction | Pass / Fail | {…} |
| 5 | Problem | Pass / Fail | {…} |
| 6 | Metrics | Pass / Fail | {…} |
| 7 | Stories | Pass / Fail | {…} |
| 8 | Requirements | Pass / Fail | {…} |
| 9 | Not in scope | Pass / Fail | {…} |
| 10 | Status | Pass / Fail | {…} |

## Findings

<!-- One block for each finding. Keep the resolved findings. They are the record. -->

### {Finding}

**How hard**: Blocking / High / Medium / Low
**Area**: Gap / Does not belong / More than one meaning / Risk / Evidence
**Where**: {part and line of the PRD}
**The problem**: {what is wrong}
**Why it matters**: {what happens if nobody repairs it}
**What to change**: {the recommendation}
**Why**: {the current requirement or the evidence}
**Result**: Open / Resolved — {how}

## Parts that do not belong

| Part of the PRD | Why it does not belong | Action |
|-----------------|------------------------|--------|
| {…} | {design detail / no story / no source / repeated} | Remove / Move to {…} |

## Decisions

| Question | Answer of the user | Your recommendation | Applied to |
|----------|--------------------|---------------------|------------|
| {…} | {…} | {…} | {part of prd.md you edited} |

## What is left

### Must repair before publish

- {…}

### Can wait

- {…}

### Send to another stage

- {…} → /product-validation | /product-metrics | /plan-product-spec
