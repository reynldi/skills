---
name: product-workflow
description: Run product work from start to end in simple English — find the real problem, test that users want it, select what to build, write the PRD, set the success numbers, give the PRD to the build pipeline, then measure the result. For all persons, not only product managers. Use when the user wants to take an idea to a shipped and measured result, or invokes /product-workflow.
---

# Product Workflow

This skill runs the product work for a feature. It controls the six other product
skills. There are two halves to the job:

- This loop answers one question: is this worth the work, and for which users?
- `/development-workflow`, the build pipeline, answers a different question: can we build it,
  and does it work?

This is a loop and not a line. The team measures what it ships. The team uses what
it learns in the next round.

**Who can use this**: all persons. You do not need product experience. Each stage
gives the steps in simple English. Read `GLOSSARY.md` if a special word stops you.

**How to write**: write all documents in Simplified Technical English. The rules are
in `STE.md`. Keep instruction sentences to 20 words or less. Use the active voice.

## The seven stages

| #  | Stage | Skill | Document | Condition to go forward |
| -- | ----- | ----- | -------- | ----------------------- |
| P0 | Make the folder | (see below) | memory.md | — |
| P1 | Learn the problem | product-discovery | discovery.md | you and the user agree which problem to solve |
| P2 | Research (only if needed) | product-analysis | analysis.md | the research answers one clear question |
| P3 | Test the risks | product-validation | validation.md | you test each large assumption, or the user accepts the risk |
| P4 | Select what to build | product-prioritization | priorities.md | the user approves the selection |
| P5 | Write the PRD | product-prd | prd.md | the checks pass and the user approves |
| P6 | Set the numbers | product-metrics | metrics.md | the numbers are exact and the user approves them before PRD approval |
| →  | Build it | `/development-workflow` (stages 1–8) | its own documents | its own gates. prd.md is the input |
| P7 | Measure the result | product-metrics (update) | metrics.md | you record the real numbers and the user approves the lessons, then go back to P1 |

All documents go in one folder for the initiative. One `memory.md` goes in the same
folder. The build pipeline uses the same folder.

## Stage P0: make the folder

Do these steps one time for each initiative:

1. Read what exists now: the README, old specs, and earlier discovery or research notes.
2. Read `.spectrum.json` in the project root, if the file exists. It sets which model
   does which role. The meaning of each field is in the Configuration part of the
   `workflow` skill. That skill is the folder next to this one. In this repository it
   is `skills/development/development-workflow/`.
3. Make the folder `{artifacts.specsRoot|specs}/{initiative-kebab-name}/`.
4. Make `memory.md` in that folder from `workflow/templates/memory.md`. Write the
   folder path in it. If `memory.md` exists, add to it. Do not make it again.
   Stage 1 of the build pipeline must use this same folder.
5. Find which model providers are on the machine. Run `workflow/bin/agent.sh list`.
6. Tell the user what you found in a few lines. Then start.

## Rules

- **Start at any stage.** If the user has a PRD, start at P5. If the user knows what to
  build and why, start at P4. If the user has only an idea, start at P1.
- **To continue old work**: read the Status line at the end of each document. Read
  `memory.md`. Find where the work stopped. Ask the user to confirm the restart point
  before you write anything.
- **Four stages need a "yes" from the user**: the problem to solve (P1), what to build
  (P4), the PRD (P5), and the lessons after launch (P7). Write the approval and the date
  in the document.
- **Stage P2 is optional.** Run it when a real decision needs evidence from outside.
  Do not run it as a habit.
- **Stage P5 and stage P6 mix.** Write the problem part of the PRD first. Then set the
  success numbers in P6. Then finish the PRD. The PRD copies a number that the user
  already approved.
- **Only an approved PRD goes to the build pipeline.** It becomes the input to
  `/plan-product-spec`. Product documents stay correct for the reason. Build documents
  are correct for the content and the method.
- **If something fails, go back. Do not go sideways.** A failed test sends you to the
  problem map. A number that misses its target becomes a lesson, not a fault. A scope
  change in the build comes back to P5 or earlier. Do not repair it in the build stage.
- **To give work to another model**: use the same method as `/development-workflow`. Write the brief
  from `workflow/templates/handoff.md`. Run it with `workflow/bin/agent.sh`. Take the
  roles, the models, and the effort levels from `.spectrum.json`.
- **Out of scope**: price, market size, sales plans, and unit economics. This loop is
  about what to build and why.
- **Keep the user informed**: write one line for each stage change —
  `{stage}: {result} → {next step}`.
