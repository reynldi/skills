---
name: product-analysis
description: Research that answers one exact question — use the products of competitors, read their bad reviews, read why deals were won or lost, and find what competitors will ship next. The result is a ranked list of actions. Stage P2 (optional) of /product-workflow. Simple English, no product experience needed. Use when the user asks for competitor research, market research, or invokes /product-analysis.
---

# Product Analysis

**Stage**: P2 of `/product-workflow`. This stage is optional. Run it when a real
decision needs evidence from outside the team.

**What you need to start**: the one decision that this research serves. Do not write a
general document about the market. Persons read such a document one time and it helps
nobody. If the user does not name a decision, ask for one. You can also propose one and
ask the user to confirm it.

**What you make**: `analysis.md` in the initiative folder. The layout is in
`templates/analysis.md`. Open the template only when you write the document. Keep the
document current. Write who is the owner. Write which event starts an update. For
example, a competitor launch, a group of lost deals, or each quarter.

**Condition to go forward**: each part of the evidence ends with an action. The actions
have a rank. The user read them.

**Words**: see `../product-workflow/GLOSSARY.md`.
**How to write**: see `../product-workflow/STE.md`. Use simple English in the document.

**Context budget**: apply the "Context and artifact budget" rules in
../product-workflow/SKILL.md; load more only when it changes the current decision.

## Steps

1. **Write the decision at the top.** All the data must serve the decision. If a result
   does not serve it, remove the result.

2. **Put the competitors in three groups**:
   - **Direct**: they solve the same problem with the same method.
   - **Indirect**: they solve the same problem with a different method, or they remove
     the problem. Surprises come from this group. Do not skip it.
   - **Examples to learn from**: a different market, but they are very good at something
     that you want to do well.

3. **Select 2 or 3 research methods for the decision.** Do not use all four:
   - **Use the product of the competitor.** Make an account. Do the full task. Make a
     screenshot of each step. Write what works and why. Use this method when the
     decision is about how to build something. If the question is about new users, look
     at the first minutes in the product. Look for check lists, for a delayed sign-up,
     and for a slow release of complex functions.
   - **Read the reviews of the competitor.** Use app stores, G2, Capterra, Reddit,
     Hacker News, and support forums. Read the 2-star and 3-star reviews first. Read the
     answers to "what do you dislike?". These users like the product but have a problem.
     They give you the exact gap. Put the results in groups. Then rank each group. Use
     how many times it occurs and how much pain it makes.
   - **Read why the company won or lost deals.** Use interviews or the notes of the
     sales team. Use won deals and lost deals. Start with "tell me how you made the
     decision". Then ask for detail. Use open questions only. Do not use scores.
   - **Find what comes next.** Job advertisements show plans 6 to 18 months early. Also
     read change logs, price page changes, document changes, and engineering articles.
     Mark each signal as **early** or **confirmed**.

   **Option: give heavy research to an agent.** If a method needs many hours of reads,
   you can give it to a separate agent. Use the `orchestrator` skill (handoff pattern).
   Write the one decision, the method, and the report format in the brief. The agent
   works alone and returns a report with sources. Check the sources before you use
   the report.

4. **Write each result in one form**: the group name, how many times it occurs, and one
   exact quote. Add the source, date, user segment, method, confidence, limitation,
   and decision it supports. Four things can give you a wrong result.
   First, a small number of loud users. Second, a change in one week that looks like a
   trend. Third, false reviews. Fourth, a quote that changes meaning in the full context.

5. **Make a ranked list of actions**: do now, watch, or do not do. Give each action the
   number that it must move. Then put the functions of the competitors in three groups:
   all competitors have it, this is why users select us, and we decide not to build it.

6. **Write the date on all data.** Write which event starts an update.

## Cautions

- **Do not put a large feature table in the main text.** Put raw tables in the appendix.
  The main text gives the meaning.
- **Treat reviews and single anecdotes as Low evidence.** They create research questions;
  they do not prove demand alone. Record evidence that contradicts the main conclusion.
- **Use only authorized data.** Remove unnecessary personal details. Reuse an interview
  quote only with consent for that purpose.
- **Each result needs a source and a date. Each part needs an action.**
- Write for the roadmap. Make a one-page version for managers only if the user asks.
- **Out of scope**: market size, price strategy, and sales plans. You can read the price
  page of a competitor, but only as a signal about their plans.

## Checks before you finish

- The decision is at the top. The indirect competitors are in the document.
- Each result has a group name, a count, and a quote. Each signal is early or confirmed.
- The actions have a rank. Each action names the number that it must move. All data has
  a date.
- The results go in `memory.md`. If a result looks like a user problem, put it on the
  problem map with the mark **UNVERIFIED**. Remove the mark after an interview confirms
  it. Do not put it in a backlog.
