---
name: product-discovery
description: Find which problem is worth the work — talk to real users, write what they said, and map their problems to possible solutions. Stage P1 of /product-workflow. Simple English, no product experience needed. Use when the user wants to learn about the users, plan interviews, or invokes /product-discovery.
---

# Product Discovery

**Stage**: P1 of `/product-workflow`. This work does not stop. You continue to learn
while the team builds. It gives data to `/product-validation` and
`/product-prioritization`.

**What you need to start**:

1. The change in user behavior that you want. For example, "more new users complete
   setup". Do not write "ship the wizard".
2. Your best guess about which users have this problem.

Ask the user for both if they are not clear.

**What you make**: `discovery.md` in the initiative folder. The layout is in
`templates/discovery.md`. Open the template only when you write the document. Update
the same file after each group of interviews. Do not start a new file.

**Condition to go forward**: each problem in the document comes from words of a real
user. You and the user agree which problem to solve first.

The purpose: give the build team a problem, not a list of features. If you give a
feature list, the team builds it well and no user needs it.

**Words**: see `../product-workflow/GLOSSARY.md`.
**How to write**: see `../product-workflow/STE.md`. Use simple English in the document.

**Context budget**: apply the "Context and artifact budget" rules in
../product-workflow/SKILL.md; load more only when it changes the current decision.

## Steps

1. **Select one goal.** Write one change in user behavior for this round. Write which
   users you think have the problem. Make one map for one goal. Do not make one large
   map for the full company.

2. **Draw the current steps of the user.** Do this before you talk to anybody. Write
   what the user does today, step by step. The steps that you cannot write are the
   steps to ask about.

3. **Talk to users.** You can also write the questions and let the user do the
   interviews. Then help to read the notes.
   - Find persons who did the task in the last weeks, or who changed tools in the last
     weeks. Do not use persons who say they can do it some day.
   - **Ask for stories. Do not ask for opinions.** Say "tell me about the last time
     you…". Then follow the story in time order. Users are not exact about general
     behavior or about future plans. Users are exact about last Tuesday.
   - **Interview rules** (the mom test): ask about the life of the user, not about your
     idea. Ask about exact events in the past. Do not ask what the user thinks of your
     plan. Talk less than the user. Let the silence continue. If the user gives a
     compliment, continue to the next question. A compliment is not data. If the user
     gives a general answer, ask for the detail: "when did that last happen? what did
     it cost you?"
   - **If the user changed tools**, follow the time line: first thought, casual look,
     active look, decision. Ask what pushed the user away from the old tool. Ask what
     pulled the user to the new tool. Ask what made the user afraid. Ask what almost
     kept the user in place. These four questions show the result that the user wants
     from the product.
   - Write **one page for each interview**: the quote to remember, the problems you
     heard, what you learned, each new detail about the steps of the user, and the
     interview date, user segment, and consent to retain the quote. Remove unnecessary
     personal details.

4. **Read the notes after each 3 or 4 interviews.** Add the problems to the map. Add
   needs, pains, and wants. These rules control what goes on the map:
   - From an interview: add it.
   - From support tickets, app reviews, or usage data: add it with the mark
     **UNVERIFIED**. Remove the mark after an interview confirms it.
   - From your own idea, with no user data: do not add it.
   - One test: if there is only one possible way to solve it, you wrote a solution and
     not a problem. Write the need behind it.

5. **Select one problem to solve.** Compare the problems that are next to each other on
   the map. Compare two things: how much the solution moves your goal, and how strong
   the evidence is. **Do not compare how difficult the problems are.** Difficulty
   belongs to the next step, when you compare solutions.

6. **Write 2 or 3 different solutions** for that problem. Then give their largest
   assumptions to `/product-validation`.

**If you cannot talk to users now**, select one of two options:

- Make this document an interview plan: which users, where to find them, and which
  questions to ask.
- Continue with second-hand data: support tickets, app reviews from `/product-analysis`,
  and usage data. Mark each problem **UNVERIFIED**. Ask the user to accept this gap.

## Cautions

- **A feature request is an answer, not a problem.** If a user asks for a feature, ask
  "why" a few times. Find the result the user wants. Write that result in the document.
- **Bad data**: compliments, "I will use it for sure", and all future plans.
  **Good data**: what the user did, and what the user gave up. For example, time,
  money, or reputation.
- **One interview is not a pattern.** Wait for 3 or more users with the same problem.
- **Do not sell your idea in an interview.** If you must show something, show it last.
- **Record contradictions.** A story that disagrees with the selected problem is evidence,
  not an inconvenience to omit.

## Checks before you finish

- The goal and the target users are at the top. The current steps of the user are on the
  map.
- Each problem points to the interview that it came from. You changed each solution that
  looked like a problem.
- The map shows the selected problem. The user approved it. The list of different
  solutions is complete, with the largest assumption of each one.
- New facts and decisions go in `memory.md`.
