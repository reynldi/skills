---
name: product-prd
description: Write a short PRD that starts with the problem — introduction with 5W1H, success metrics, user stories, and a requirements table with acceptance criteria. Then give it to the /development-workflow build pipeline. Stage P5 of /product-workflow. Simple English, no product experience needed. Use when the user asks for a PRD, a product spec, a feature spec, a pitch, or invokes /product-prd.
---

# Product PRD

**Stage**: P5 of `/product-workflow`. Before: `/product-prioritization` gives the selected
work. After: give the PRD to `/development-workflow`. Its stage `/plan-product-spec` uses the PRD.

**What you need to start**: the selected work and the links to the evidence
(`discovery.md`, `analysis.md`, `validation.md`, `priorities.md`). If evidence is absent,
say which parts have no proof. Do not write a confident sentence with no data.

**What you make**: `prd.md` in the initiative folder.

Always use `templates/prd.md`. One PRD shape covers every size of work — a small change,
one cycle of work, and a new product. The size changes how much you write, not which
template you use. Do not invent another document format.

Open the template only when you write the document. The document ends with
`**Status**: DRAFT | APPROVED`.

**Condition to go forward**: the checks in "Order of work" pass. Then your own review
passes. Then `metrics.md` exists and the user approves it (stage P6). Then the user
approves the PRD. Then write Status APPROVED. Then give the PRD to `/development-workflow` as the
input to stage 1.

The PRD gives the problem and the target result. The PRD does not design the product.
Screens, fields, and flows belong to `/plan-product-spec`. The architecture belongs to
`/plan-technical-spec`.

**Words**: see `../product-workflow/GLOSSARY.md`.
**How to write**: see `../product-workflow/STE.md`. Use simple English in the document.

**Context budget**: apply the "Context and artifact budget" rules in
../product-workflow/SKILL.md; load more only when it changes the current decision.

## How much to write

| Size of the work | Template | How much to write |
| --- | --- | --- |
| Small change | `prd.md` | Parts 1 to 4, and Part 6. 1 to 2 pages. |
| One cycle of work | `prd.md` | All parts. 2 to 4 pages. |
| New product | `prd.md` | All parts, with more detail in the problem and the metrics. 4 to 6 pages. |

## Order of work

Each check must pass before you write the next part.

1. **Write the problem first.** Use the words of the user. Say which users have the
   problem, when it occurs, and what it costs them. Add links to the evidence. Do not
   write about a solution in this part. If the user says "we need an AI chatbot", ask
   "why" a few times. Find the result that the user wants. Write that result. Then
   continue.

2. **Fill the introduction and the 5W1H table.** Write 2 to 5 sentences first. Then
   answer the questions in the table. Keep only the rows that you can answer. Delete the
   other rows. Do not write "not specified". Add a source for each answer.

3. **Make the success metrics exact.** Write exactly one main metric. Give it a start
   value, a target, and a time limit. Then write what must not become worse. Use a limit:
   "{metric} will not become worse than {amount}". Do not accept a goal such as "more
   engagement". A person must be able to show the metric is false.

4. **Write the user stories.** Put them in groups. Use the form: as a {user type}, I want
   {function}, so that {result}. Mark each story P1 (must have) or P2 (good to have).

5. **Write the requirements table.** One row for each requirement. Each row has the user
   story, the acceptance criteria, the requirements, and the design link.
   - User story: use the same words as the story in Part 5.
   - Acceptance criteria: write them from the source only. Do not invent them. Always
     number them. Use sub-numbers inside one condition group. Put one empty line between
     each number (`<br><br>` in the table cell). If the source says nothing, write "Not in
     the source".
   - Requirements: what the product must do for that story. Number them, with one empty
     line between each number. Give the normal behavior, the error and rare cases, and the
     quality the user can feel. Keep it at a rough level. Do not write screens, field
     lists, or architecture.
   - Attachments: links to the design, the mockup, the ticket, or the file. Write "None" if
     there is none.

6. **Write what is not in scope.** Write 3 lines or more. Each line is something the team
   can build but decides not to build. Then write the two groups: must ship, and remove
   first. Then the team knows what to remove before the work starts.

7. **Write the risky details.** Find each small detail that can take many weeks. Make the
   decision now, or write that you accept the risk.

8. **Write the assumptions and the open questions.** An assumption is safe to accept. An
   open question changes the behavior of the product and needs the user.

## How to write an absent part

Write a short label. Do not write a sentence that explains what the source does not have.

| Write this | Not this |
| --- | --- |
| **No problem defined** | The source does not state a user problem with evidence. |
| **No success metrics** | The source does not give a start value, a target, or a time limit. |
| **Not in the source** | The source PRD does not say anything about this. |

After the label, you can add the facts that do exist, and the action that closes the gap.
Keep it to one or two lines.

## Review the draft yourself

Do this before you show the draft to the user. Read it as a new reader. Look for the
truth. Do not sell the idea. Answer these questions:

- Can a new reader name the user and the problem after one read?
- Is the problem real, with evidence? Or is it only a statement?
- What is the hardest question from a person who does not agree? Is the answer in the
  document?
- Where can this feature fail?

Repair the document. Then show it to the user for approval.

When a part still has a gap, or the user is not sure about an answer, offer
`/product-prd-verification`. It finds the gaps and the parts that do not belong, then
it asks the user one question at a time until each gap has an answer.

## Checks before you finish

- The problem part has no solution words. The links to the evidence work. You wrote which
  assumptions have no proof. Send the large ones to `/product-validation` first.
- The introduction has 2 to 5 sentences. The 5W1H table has only rows that you can answer.
  Each answer has a source.
- There is one main metric, and a list of things that must not become worse. A person can
  show each metric is false.
- `metrics.md` exists. Its main metric is the same as the metric in the PRD. The start
  value, the target, and the time limit are the same. Do this before Status APPROVED.
- The user stories have priorities. Each requirements row has a user story, numbered
  acceptance criteria (or "Not in the source"), and numbered requirements.
- There are 3 or more lines that are not in scope. The must-ship and remove-first groups
  exist.
- The document is not longer than the limit in the table above.
- After approval: write Status APPROVED. Write the decision and the reason in `memory.md`.
  Then offer to start `/development-workflow`.
