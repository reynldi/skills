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

**Owner**: {owner}

**Technical Lead**: {name}

**QA**: {name}

**Contributors**: {names, separated by commas — or "None"}

<!--
How to use this template:
- Write in simple English. Keep instruction sentences to 20 words or less.
- Delete each part that this feature does not need. An empty part helps nobody.
- Do not write "not specified". Delete the row or the part.
- Do not invent content. If the source does not say it, write "Not in the source".
- When a part has no content, write a short label. Do not explain the absence. Write
  "No problem defined", "No success metrics", "Not in the source".
- For a small change, Part 1 to Part 4 are enough. Add Part 5 to Part 6 for larger work.
- The PIC lines (Owner, Technical Lead, QA, Contributors) name real persons.
  /product-publish-prd uses these names to build mentions for the open questions,
  the assumptions, and the risky details.
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

## 3. Success Metrics

- **Main metric**: {metric} — start {…} → target {…} in {time limit}
- **Must not become worse**: {metric} will not become worse than {amount}

<!-- Copy these values from metrics.md. The two files must be the same. -->

## 4. Not in scope

<!-- Write 3 or more. Each line is something the team can build but decides not to build. -->

- {…}
- {…}
- {…}

**If the scope must shrink**:

| Must ship | Remove first |
| --- | --- |
| {…} | {…} |

## 5. User stories

<!-- Put the stories in groups. P1 = must have. P2 = good to have. -->

### {Group of stories}

1. (P1) As a {user type}, I want {function}, so that {result}.
2. (P2) …

## 6. Requirements

<!--
One row for each requirement.
- User story: the story from Part 5 that this row serves. Use the same words.
- Acceptance criteria: the conditions that show the requirement is complete. Always number
  them: 1, 2, 3. Use sub-numbers (1.1, 1.2) inside one condition group. Put one empty line
  between each number: use `<br><br>` in the table cell. Use only what the source says. If
  the source says nothing, write "Not in the source".
- Requirements: what the product must do for this story. Keep it specific: the normal
  behavior, the error and rare cases, and the quality the user can feel. Number them and
  separate each number with `<br><br>`. No screens, no field lists, no architecture.
- Attachments: links to the design, the mockup, the ticket, or the file. One per line. If
  there is none, write "None".
-->

| No | User story | Acceptance criteria | Requirements | Attachments |
|----|------------|---------------------|--------------|-------------|
| 1 | As a {user type}, I want {function}, so that {result}. | 1. {condition}<br><br>2. {condition}<br><br>2.1 {sub-condition}<br><br>2.2 {sub-condition} | 1. {what the product does in the normal case}<br><br>2. {what the product does in an error case or a rare case}<br><br>3. {quality the user can feel, for example the page opens in 2 seconds} | None |

## 7. Risky details

<!-- Small details that can take many weeks. Make the decision now, or write that you accept the risk. -->

- {risky detail → the decision, or the reason to accept the risk}

## 8. Assumptions

- {something you accept as true, with no proof, and it is safe to accept}

## 9. Open questions

- {a decision that changes the behavior of the product and needs the user}

---

**Status**: DRAFT <!-- DRAFT | APPROVED — write APPROVED only after the user approves. Then give the PRD to /development-workflow. -->
