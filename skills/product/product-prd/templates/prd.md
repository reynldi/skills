---
title: <Feature Name>
product: "[[<Product Name>]]"   # the only product field: a wikilink to the hub in _MOC/Products/
feature: <Sub-area or Module>
status: draft                   # draft | in-review | approved | shipped | deprecated
tags: []                        # for example [ai, nlp, survey]
related:                        # a list, for example:
                                #   - "[[Other PRD Name]]"
source_url:                     # link to the original PRD (Notion, Google Doc, Confluence)
source_type:                    # notion | gdoc | confluence | other
last_synced:                    # YYYY-MM-DD — the last date you compared this file to the source
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# <Feature Name>

**Size**: small change | one cycle | new product (for a new product, use `pr-faq.md`)
**Evidence**: discovery {link} · research {link} · tests {link} · priorities {link} · numbers {link}

<!--
How to use this template:
- Write in simple English. Keep instruction sentences to 20 words or less.
- Delete each part that this feature does not need. An empty part helps nobody.
- Do not write "not specified". Delete the row or the part.
- Do not invent content. If the source does not say it, write "the source does not say".
- For a small change, Part 1 to Part 5 are enough. Add Part 6 to Part 8 for larger work.
-->

## 1. Introduction

{Write 2 to 5 sentences. Say what the feature is, which users it is for, and why it is important.}

Then answer the questions in the table. Use simple words. Keep only the rows that you can
answer from the source. **Delete each row that the source does not answer.** You can add
more rows for one category.

| No | Type | Question | Answer | Source |
|----|------|----------|--------|--------|
| 1 | What | What is this feature? | | |
| 2 | What | Which problem does it solve? | | |
| 3 | Where | Where does it apply? (product / module / page) | | |
| 4 | Why | Why is this feature important? | | |
| 5 | When | When do users use it, or what starts it? | | |
| 6 | Who | Which users is it for? | | |
| 7 | How | How does it work? | | |

## 2. The problem

{Write the problem in the words of the user. Say which users have it, when it occurs, and
what it costs them. Add links to the evidence. Do not write about a solution here.}

**Why now**: {…}

## 3. Success numbers

- **Main number**: {number} — start {…} → target {…} in {time limit}
- **Must not become worse**: {number} will not become worse than {amount}

<!-- Copy these values from metrics.md. The two files must be the same. -->

## 4. Time budget

{The time the team accepts to spend. This is a limit for the design. It is not an estimate.}

## 5. Not in scope

<!-- Write 3 or more. Each line is something the team can build but decides not to build. -->

- {…}
- {…}
- {…}

**If the time runs out**:

| Must ship | Remove first |
| --- | --- |
| {…} | {…} |

## 6. User stories

<!-- Put the stories in groups. P1 = must have. P2 = good to have. -->

### {Group of stories}

1. (P1) As a {user type}, I want {function}, so that {result}.
2. (P2) …

## 7. Requirements

<!--
One row for each requirement.
- Requirement: if a source PRD exists, copy the words exactly. Do not change them. If you
  write the requirement yourself, keep it short and exact.
- Acceptance criteria: the conditions that show the requirement is complete. Use bullets
  for more than one condition. Use only what the source says. If the source says nothing,
  write "the source does not say".
- Design: a link, if a design exists. If not, write "—".
-->

| No | Requirement | Acceptance criteria | Design |
|----|-------------|---------------------|--------|
| 1 | | | |

## 8. Detail: {function name}

<!-- Copy this part one time for each function that needs detail. Skip it for a small change. -->

### User story

{The user story from Part 6 that this function serves}

### Problem

{The problem of the user}

### Solution

{What the user sees and what the product does}

### Behavior

- {What the product does in the normal case}
- {What the product does in an error case or a rare case}

### Quality the user can feel

- {Only the requirements that the user can see or feel. For example, the page opens in 2 seconds.}

## 9. Risky details

<!-- Small details that can take many weeks. Make the decision now, or write that you accept the risk. -->

- {risky detail → the decision, or the reason to accept the risk}

## 10. Assumptions

- {something you accept as true, with no proof, and it is safe to accept}

## 11. Open questions

- {a decision that changes the behavior of the product and needs the user}

---

**Status**: DRAFT <!-- DRAFT | APPROVED — write APPROVED only after the user approves. Then give the PRD to /development-workflow. -->
