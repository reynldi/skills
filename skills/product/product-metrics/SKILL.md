---
name: product-metrics
description: Set the meaning of success before the team builds, in numbers that a person can show are false — one main number, a few weekly numbers, one early signal, and the things that must not become worse. Then record the real numbers after launch. Stages P6 and P7 of /product-workflow. Simple English, no product experience needed. Use when the user asks for success metrics, KPIs for a feature, or invokes /product-metrics.
---

# Product Metrics

**Stage**: P6 and P7 of `/product-workflow`.

- P6: set the numbers. Do this after you write the problem part of the PRD, and before
  the user approves the PRD.
- P7: record the real numbers after launch. Use the same file.

**What you need to start**: the change in user behavior that you want, or the main number
of a PRD. For stage P7, the file `implementation-report.md` or `qa-report.md` tells you
that it is time to measure.

**What you make**: `metrics.md` in the initiative folder. The layout is in
`templates/metrics.md`. Open the template only when you write the document. Write the
real numbers in the same file later.

**Condition to go forward**: a person can show that each number is false. Each number has
a start value, a target, and a time limit. The team can measure each number. The user
approves the numbers. No number can give a reward for much output.

**Words**: see `../product-workflow/GLOSSARY.md`.
**How to write**: see `../product-workflow/STE.md`. Use simple English in the document.

**Context budget**: apply the "Context and artifact budget" rules in
../product-workflow/SKILL.md; load more only when it changes the current decision.

## Steps

1. **Set one main number for the product.** Do this one time for the product, not for
   each feature. The number must show the value that users get. Do not use money. Do not
   use sign-ups. Do not use page views. Then divide the main number into 3 to 5 smaller
   numbers. A team must be able to move each smaller number in one week.

   One test keeps you honest: if this number increases, is the user better than before?
   If a company can increase the number while the experience becomes worse, the number is
   wrong.

2. **Set the numbers for this feature.** Use only the lines that are important for this
   feature. The full list has five lines:
   - **Satisfaction**: do the users like it?
   - **Use**: how much do they use it?
   - **New users**: how many new users start to use it?
   - **Return**: do the users come back?
   - **Task success**: can the users complete the task? Use completion rate, time, and
     error rate.

   For each line, work in this order. First, write the goal. Second, write which user
   action shows the goal. Third, write exactly what you count. Remove the lines that do
   not serve this feature. A table with all five lines is usually too much.

3. **Put one early signal next to each slow number.** A slow number, such as return rate,
   needs a fast number next to it. The fast number must move in days. If not, you see
   nothing for one month. Write why you believe that the fast number causes the slow
   number. Write it so that a person can show it is false.

4. **Write what must not become worse.** For example, support tickets, page speed,
   cancellations, and trust. Write it as a limit: "{number} will not become worse than
   {amount}". This step stops a win in one number and a loss in the product.

5. **Test each number with one question**: if this number changes, do we do something
   different? If not, remove the number. Three things are not permitted:
   - **A count with no total.** "500 users did X" says nothing. "12% of active users did
     X" says something.
   - **A total that only increases.** Such a number cannot show a problem.
   - **The word "use" with no exact action.** Write which action, which users, and how
     many times.

6. **After launch**: write the end date of the measurement period in `memory.md`. That
   date brings a future session back to this stage. At the end date, write the real number
   next to the target. Write the result for each number: **hit**, **miss**, or **not
   clear**. Send each miss back to discovery as a lesson. Do not use it against a person.
   Write the results in `memory.md`.

## Checks before you finish

- The main number passes the test: the user is better than before. A team can move each
  smaller number in one week.
- Each number has a start value, a target, and a time limit. If you do not know the start
  value, write `START VALUE: TBD`. Also write the task that measures it. That task stops
  the start of the period. It does not stop the approval of the PRD.
- Each slow number has a fast number next to it, with the reason that connects them.
- The list of things that must not become worse includes the probable damage. You applied
  the question "does this change a decision?" to each number.
- The measurement work is in the document as requirements for the build pipeline. Write
  what to record and when. Do not write how to build it.
