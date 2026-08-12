---
name: product-prd
description: Write a short PRD that starts with the problem — introduction with 5W1H, success numbers, user stories, requirements with acceptance criteria, and detail per function. Then give it to the /development-workflow build pipeline. Stage P5 of /product-workflow. Simple English, no product experience needed. Use when the user asks for a PRD, a product spec, a feature spec, a pitch, a PR/FAQ, or invokes /product-prd.
---

# Product PRD

**Stage**: P5 of `/product-workflow`. Before: `/product-prioritization` gives the selected
work. After: give the PRD to `/development-workflow`. Its stage `/plan-product-spec` uses the PRD.

**What you need to start**: the selected work and the links to the evidence
(`discovery.md`, `analysis.md`, `validation.md`, `priorities.md`). If evidence is absent,
say which parts have no proof. Do not write a confident sentence with no data.

**What you make**: `prd.md` in the initiative folder.

- For a feature or a change, use `templates/prd.md`.
- For a new product, use `templates/pr-faq.md`.

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
| Small change | `prd.md` | Parts 1 to 5, and Part 7. 1 to 2 pages. |
| One cycle of work | `prd.md` | All parts. 2 to 4 pages. |
| New product | `pr-faq.md` | Announcement and questions. 6 pages maximum. |

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

3. **Make the numbers exact.** Write exactly one main number. Give it a start value, a
   target, and a time limit. Then write what must not become worse. Use a limit:
   "{number} will not become worse than {amount}". Do not accept a goal such as "more
   engagement". A person must be able to show the number is false.

4. **Set a time budget, not an estimate.** This is the time that the team accepts to
   spend. The team designs the solution to fit the time. Agree the time with the user.

5. **Write the user stories.** Put them in groups. Use the form: as a {user type}, I want
   {function}, so that {result}. Mark each story P1 (must have) or P2 (good to have).

6. **Write the requirements and the acceptance criteria.** One row for each requirement.
   - If a source PRD exists, copy the requirement words exactly. Do not change them.
   - Write the acceptance criteria from the source only. Do not invent them. If the source
     says nothing, write "the source does not say".
   - Add a link to the design, or write "—".

7. **Write the detail for each function that needs it.** Copy Part 8 of the template one
   time for each function. Write the user story, the problem, the solution, the behavior,
   and the quality that the user can feel. Keep the solution at a rough level. Do not
   write screens or field lists.

8. **Write what is not in scope.** Write 3 lines or more. Each line is something the team
   can build but decides not to build. Then write the two groups: must ship, and remove
   first. The groups must fit the time budget. Then the team knows what to remove before
   the work starts.

9. **Write the risky details.** Find each small detail that can take many weeks. Make the
   decision now, or write that you accept the risk.

10. **Write the assumptions and the open questions.** An assumption is safe to accept. An
    open question changes the behavior of the product and needs the user.

## Review the draft yourself

Do this before you show the draft to the user. Read it as a new reader. Look for the
truth. Do not sell the idea. Answer these questions:

- Can a new reader name the user and the problem after one read?
- Is the problem real, with evidence? Or is it only a statement?
- What is the hardest question from a person who does not agree? Is the answer in the
  document?
- Where can this feature fail?

Repair the document. Then show it to the user for approval.

## Checks before you finish

- The problem part has no solution words. The links to the evidence work. You wrote which
  assumptions have no proof. Send the large ones to `/product-validation` first.
- The introduction has 2 to 5 sentences. The 5W1H table has only rows that you can answer.
  Each answer has a source.
- There is one main number, and a list of things that must not become worse. A person can
  show each number is false.
- `metrics.md` exists. Its main number is the same as the number in the PRD. The start
  value, the target, and the time limit are the same. Do this before Status APPROVED.
- The user stories have priorities. Each requirement has acceptance criteria or the words
  "the source does not say".
- There are 3 or more lines that are not in scope. The must-ship and remove-first groups
  exist.
- The document is not longer than the limit in the table above.
- After approval: write Status APPROVED. Write the decision and the reason in `memory.md`.
  Then offer to start `/development-workflow`.
