---
name: product-prioritization
description: Select what to build next and show the reasons — score the problems by how much users need help, score the solutions with a simple formula, give a source for each number, and make a roadmap with no false dates. Stage P4 of /product-workflow. Simple English, no product experience needed. Use when the user asks to put a backlog in order, make a roadmap, score ideas, or invokes /product-prioritization.
---

# Product Prioritization

**Stage**: P4 of `/product-workflow`. It comes after `/product-discovery` and
`/product-validation`. It gives data to `/product-prd`.

**What you need to start**: a list of user problems, or a list of possible things to
build. You also need the evidence from `discovery.md`, `analysis.md`, and
`validation.md`.

**What you make**: `priorities.md` in the initiative folder. The layout is in
`templates/priorities.md`. Open the template only when you write the document. Update the
same file. The roadmap stays correct after a change of plan because it has no dates.

**Condition to go forward**: the user approves the selection. You write the reasons in
the document, not only the order.

This skill uses four habits: select few things, use evidence, show the reasons, and
accept that each selection can fail.

**Words**: see `../product-workflow/GLOSSARY.md`.
**How to write**: see `../product-workflow/STE.md`. Use simple English in the document.

**Context budget**: apply the "Context and artifact budget" rules in
../product-workflow/SKILL.md; load more only when it changes the current decision.

## Steps

1. **Select which list you put in order**: user problems, or things to build. Do not mix
   the two lists in one table. You cannot compare them.

   **To put user problems in order**: for each problem, give two scores from 1 to 10. The
   first score is how important the problem is for the user. The second score is how
   satisfied the user is with the options today. Then use this formula:

   ```
   score = importance + (importance − satisfaction, or 0 if the result is negative)
   ```

   A high score means two things: the user cares, and no option helps. There is space
   for you. **Do not put problems in order by difficulty.** If you do, you remove the
   largest opportunities because they look expensive before you design a solution.

   **To put things to build in order**: use RICE.
   `score = Reach × Impact × Confidence ÷ Effort`.
   - **Reach**: how many users this touches in one quarter.
   - **Impact**: how much it changes the result for each user. Use a number from 0.25
     to 3.
   - **Confidence**: how sure you are, as a percent.
   - **Effort**: person-weeks or person-months.

   For a fast first pass, remove Reach. Use `Impact × Confidence ÷ Effort`. The name of
   this formula is ICE.

2. **Give a source for each number.** A source is an interview, a research group, a test
   result, or usage data. If you guess a number, Confidence cannot be more than 50%. No
   source, no score. Record the source date, user segment, confidence, and limitation
   beside each score. This one rule keeps the scores honest.

3. **Two extra methods are optional. Use them only if they give value:**
   - **Find which features users expect and which features make users happy.** This is
     the Kano survey. Ask how the user feels if the feature exists. Then ask how the user
     feels if the feature does not exist. The difference puts each feature in a group:
     expected, more is better, or makes users happy. Use this method for solutions only.
     It sets what users expect. It does not select the winner. Use it when the team
     argues about how much to spend on delight.
   - **Find what a delay costs.** Use this method to select between two items with the
     same score, when one item has a time limit.

4. **Make the roadmap with three columns: Now, Next, and Later.** The columns show how
   sure the team is. They do not show a month. Each item is an outcome or a problem. Do
   not promise a feature.
   - **Now**: the team tested it and made a commitment.
   - **Next**: the direction is clear. The solution is open.
   - **Later**: the team knows the problem. The team does not work on it now.

5. **Record the selection**: what you selected, what you did not select and why, and
   which event starts a new review. Write the decision and the reasons in `memory.md`.

## Cautions

- **The score puts items in order. The score does not make the decision.** A person
  reads the evidence and makes the decision. Write the reasons. A table is not
  responsible for a decision.
- **Scores become false in two ways.** First, numbers with no source. They make a guess
  look like analysis. Second, effort controls the result. Then many small easy items get
  a higher rank than the one problem that you proved. Look for both before you show the
  document.
- The Kano survey is for solutions only. Do not use it for problems. Use the problem
  formula for problems.

## Checks before you finish

- The document says which list you put in order. Each number has a source. Each number
  that you guessed has 50% confidence or less.
- The Now, Next, and Later table exists. It has outcomes, not features with dates.
- The user approved the selection. The reasons are in the document. The document names
  the options that you did not select and what can change your decision.
