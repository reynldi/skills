---
name: product-prd-verification
description: Skeptical review of one PRD before it goes to publish or to build — find the gaps, the parts that do not belong, the words with more than one meaning, and the risks; then close each gap by asking the user one question at a time. Runs after /product-prd, and before /product-publish-prd or /development-workflow. Simple English, no product experience needed. Use when the user asks to verify, review, or challenge a PRD, when a publish gate fails, or when the user invokes /product-prd-verification.
---

# Product PRD Verification

**Stage**: between P5 and publish. Prev: `/product-prd`. Next: `/product-publish-prd`, or
`/development-workflow` for the build.

**What you need to start**: one PRD. Take it from the current session, or from a path the
user gives. See Step 1.

**What you make**: `prd-verification.md` beside the PRD — the shape is
`templates/prd-verification.md`. You also apply each agreed answer to `prd.md`.

**Condition to go forward**: Status PASS or PASS_WITH_NOTES, with zero open Blocking or
High findings.

Be skeptical. Challenge the PRD. Do not defend it. A long PRD is not a good PRD.

**Words**: see `../product-workflow/GLOSSARY.md`.
**How to write**: see `../product-workflow/STE.md`. Use simple English with the user.

**Context budget**: apply the "Context and artifact budget" rules in
`../product-workflow/SKILL.md`. Load more only when it changes the current decision.

## How hard each finding is

- **Blocking** — publish and build must wait. The PRD gate in `/product-publish-prd`
  fails while one stays open.
- **High** — the team will probably build the wrong thing, or do the work two times.
- **Medium** — a real risk to scope or to cost, but the team can start.
- **Low** — an improvement that can wait.

## Order of work

### Step 1 — Find the PRD and the references

1. **The PRD.** Use, in this order: the path in the arguments · the PRD in the current
   session · the `prd.md` in the initiative folder the user names. When more than one
   candidate exists, show the titles and ask. Do not guess.
2. **The references.** Read what is available in the same folder, and no more:
   `memory.md`, `discovery.md`, `analysis.md`, `validation.md`, `priorities.md`,
   `metrics.md`. Also read the links in the PRD when a link decides a finding.
3. **Say what is absent.** List the references you did not find. A finding that needs an
   absent reference gets the note "no evidence in the folder".
4. Record the state of the PRD (git SHA, or a hash of the content) in the report. The
   publish gate uses it to see that the PRD changed after the review.

### Step 2 — Read the PRD as a new reader

Read it one time from the start. Then answer: who is the user, what is their problem,
and what is the definition of done? When you cannot answer one of the three, that is the
first Blocking finding. Separate the decisions the user made from the things the PRD
accepts with no proof.

### Step 3 — Check each part for gaps

Use the same checks as the publish gate, so a PASS here gives a PASS there. Check the
PRD against `../product-prd/templates/prd.md`:

| # | Part | A gap is when |
|---|------|---------------|
| 1 | Shape | A part of the template is absent, or the parts are in another order. |
| 2 | Placeholders | `{…}`, `<Feature Name>`, or `YYYY-MM-DD` text remains. |
| 3 | PIC lines | Owner, Technical Lead, or QA does not name a real person. |
| 4 | Introduction | It is not 2 to 5 sentences, or a 5W1H row has no answer or no source. |
| 5 | Problem | It uses solution words, or it has no evidence link, or it is a statement with no user. |
| 6 | Metrics | There is not exactly one main metric, or a start value, a target, or a time limit is absent, or `metrics.md` says another number. |
| 7 | Stories | A story has no priority, or does not use the "As a … I want … so that …" form. |
| 8 | Requirements | A row has no story, no numbered acceptance criteria, or no numbered requirements. |
| 9 | Not in scope | There are less than 3 lines, or the must-ship and remove-first groups are absent. |
| 10 | Status | The last line is not `**Status**: APPROVED`. |

### Step 4 — Find the parts that do not belong

Remove work, do not add it. Mark each of these:

- **A solution in the problem part.** The problem part names a screen, a technology, or a
  design. Move it, or delete it.
- **Design in the PRD.** Screens, field lists, page flows, or architecture. These belong
  to `/plan-product-spec` and `/plan-technical-spec`. Mark them "out of the PRD".
- **A requirement with no story.** No user asked for it. Move it to "Not in scope", or
  delete it.
- **A P1 that is not a P1.** The product works without it. Make it P2.
- **A number with no source.** Delete it, or find the source.
- **A repeated part.** The same fact in three parts. Keep one.
- **Content the source does not have.** You invented it. Delete it, or write "Not in the
  source".

### Step 5 — Find the words with more than one meaning

Look for words that two persons read in two ways: active, eligible, real time, fast,
soon, later, some users, most users, better, easy, when needed, gracefully, and each word
that hides a number. Ask about a word only when the answer changes the behavior, the
scope, the metric, or the cost.

### Step 6 — Check the risks

- Does one main metric measure the problem? Or does it measure the work?
- Can the target move because of another team, a season, or an advertisement?
- What must not become worse, and did anybody write the limit?
- Which assumption stops the feature when it is false? Send the large ones to
  `/product-validation`.
- Which open question changes the requirements table? That question is Blocking.
- Does the scope grow after the first row of the requirements table?
- Who says yes at the end? Is that person in the PIC lines?

### Step 7 — Quiz the user, one question at a time

Ask in the order Blocking, then High, then a design choice that matters. Do not ask a Low
question when a safe default exists. Use `AskUserQuestion` when it is available.
Otherwise write the same shape in markdown.

Each question has:

1. The question, in simple words. One question only.
2. Why it matters: what changes with each answer.
3. Two to four concrete options. Give a real option, not "yes / no", when you can.
4. Your recommendation, and the reason.

Rules for the quiz:

- Ask one question. Wait for the answer. Then ask the next one.
- Do not ask the user to write the text. Give the text, and ask them to accept or change
  it.
- When the user does not know, say what you would write, and mark it an assumption.
- When the answer changes an earlier part of the PRD, say which part, before you edit it.
- Stop after 10 questions in one round. Show what is left, and ask to continue.

### Step 8 — Apply, then decide the verdict

1. Apply each agreed answer to `prd.md`. Make small, exact edits. Do not rewrite a
   sentence the user wrote for another reason.
2. Write each answer in the Decisions table of the report.
3. Close each finding the answer resolves. Keep the closed findings in the report. They
   are the record.
4. Write the verdict:
   - **PASS** — no open Blocking, High, or Medium finding.
   - **PASS_WITH_NOTES** — open Medium or Low findings only. Name them.
   - **FAIL** — one or more open Blocking or High findings.
5. Write `prd-verification.md` beside the PRD.
6. Say the next step: `/product-publish-prd` when the verdict is PASS or
   PASS_WITH_NOTES. When it is FAIL, say which findings stay open, and offer another
   round.

## When the publish gate sends the user here

`/product-publish-prd` stops when a check fails. It sends the user to this skill. Then:

1. Take the failed checks as findings that are already found. Give each one Blocking.
2. Do Step 1 and Step 3 to Step 6 for the rest of the PRD. A PRD with one failed check
   often has more.
3. Quiz the user (Step 7), apply the answers (Step 8), and give the verdict.
4. Send the user back to `/product-publish-prd`. The publish gate runs again from the
   top. This skill does not publish, and this skill does not give permission to publish.

## Repeat a review

When the PRD changes and the user asks again, update `prd-verification.md` in place. Mark
the resolved findings resolved. Read again, in depth, only the parts of the PRD that
changed. Then write the verdict again.

## Rules

- Each finding has: how hard it is, what to change, and why. The why points at a current
  requirement or at the evidence. Never write "because it is better".
- Do not add scope. When you find work that nobody asked for, the recommendation is to
  remove it.
- The PRD gives the problem and the target result. The PRD does not design the product.
- A gap with no evidence is a question for the user, not a sentence you invent.
- Do not change the words of the user for style. Change them only when the user agrees to
  a decision that changes the meaning.

## Checks before you finish

- The PRD and each reference in the folder were read, or their absence is in the report.
- Every part in Step 3 was checked. Every finding has a hardness, a recommendation, and a
  why.
- The parts that do not belong are marked, with the recommendation to remove or to move.
- Each Blocking and High question was asked, and the answer is in the Decisions table.
- Each agreed answer is in `prd.md`. `metrics.md` and the PRD give the same numbers.
- `prd-verification.md` exists, with the verdict, the open findings, and the state of the
  PRD.
- The user knows the next step.
