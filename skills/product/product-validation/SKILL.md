---
name: product-validation
description: Test the risks in an idea before the team builds it — write what you accept as true with no proof, find the assumption that can stop the idea, and run the cheapest test that can show it is false. Stage P3 of /product-workflow. Simple English, no product experience needed. Use when the user wants to test an idea, design an experiment, measure demand, or invokes /product-validation.
---

# Product Validation

**Stage**: P3 of `/product-workflow`. It comes after `/product-discovery`. That stage
gives you the selected problem and 2 or 3 different solutions. This stage gives data to
`/product-prioritization` and to the PRD.

**What you need to start**: one or more possible solutions and the assumptions about
them. Take them from `discovery.md`, or from the open questions in a PRD. If you have
neither, ask the user. You can also propose `/product-discovery` first.

**What you make**: `validation.md` in the initiative folder. The layout is in
`templates/validation.md`. Open the template only when you write the document. Update
the same file when each test ends.

**Condition to go forward**: you test each dangerous assumption against a number that
you wrote before the test. If you do not test it, the user must say that the team
accepts the risk.

The purpose: spend a few days to find something that can cost you a few months.

**Words**: see `../product-workflow/GLOSSARY.md`.
**How to write**: see `../product-workflow/STE.md`. Use simple English in the document.

## Steps

1. **Write what you accept as true with no proof.** Do this for each possible solution.
   Write each assumption so that a person can show it is false. Use five types:
   - **Do the users want it?** This type stops most ideas.
   - **Can the users operate it?**
   - **Can we build it?** Give this type to the engineers, or run a short study. Do not
     answer it from your own feeling.
   - **Does it work for the company?** For example, support load, operations, law, and
     maintenance.
   - **Can it hurt a person?** For example, privacy, fairness, and misuse.

2. **Put the assumptions in order.** Draw a simple 2 × 2 table. One axis: how much
   damage occurs if the assumption is false. The other axis: how much proof you have
   now. The box with much damage and no proof is first. Start there, also if the tests in
   the easy box are faster.

3. **Design the smallest test that can stop the idea.** Test one assumption in one test.
   Do not run one large test of the full idea. If a large test fails, you do not know
   which part failed.
   - **Fake door**: a real button for a function that does not exist. Count the clicks.
     Compare the count to your number. The users who click must see an honest page. For
     example, "this function comes soon. Do you want an email?". Run this test for a
     short time only.
   - **Click model**: a model with links, about 5 sessions. Give each user a task. Watch
     where the user stops. This test shows if users understand it. It does not show if
     users want it.
   - **Manual service**: give the value by hand to a few users before you build
     software. This test shows if the value is real.
   - **Engineering study**: one question, one time limit. Give it to the build pipeline.

4. **Write the decision rule before you run the test.** Write which number is a pass.
   Write how many users or how many days. Write what you do if the test passes and what
   you do if the test fails. Do not change the number after you see the result. This
   error makes the test useless.

5. **Run the test and record it**: what you ran, how many users, the result against the
   number, and the result type. Use **true**, **false**, or **not clear**.

6. **Use the results.** If an assumption is false, go back to the problem map. Use the
   next solution, or write the problem again. If an assumption is true, put it in the
   selection of what to build and in the evidence links of the PRD. If the result is not
   clear, design the test again, or ask the user to accept the risk.

## Cautions

- **What is proof**: users who give something real. For example, time, money,
  reputation, or their data. **What is not proof**: opinions, compliments, and
  "I will use it for sure".
- **Test the assumption that can stop the idea.** Do not test the easy assumption.
- A fake door must be honest and short. You use the trust of the user.
- The question "can we build it?" goes to the engineers. Product does not approve this
  question.

## Checks before you finish

- The 2 × 2 table is in the document. You started with the box with much damage and no
  proof.
- Each test has a number from before the test and a result after the test.
- The user accepts each important assumption that you did not test. Write the name and
  the date. Do not continue in silence.
- The results go in `memory.md`. Put the failures in the file also. The failures stop the
  team from a new discussion about the same idea in six months.
