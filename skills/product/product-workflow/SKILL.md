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
| P5b | Verify the PRD (only if needed) | product-prd-verification | prd-verification.md | no Blocking or High finding stays open |
| P6 | Set the numbers | product-metrics | metrics.md | the numbers are exact and the user approves them before PRD approval |
| →  | Build it | `/development-workflow` (stages 1–8) | its own documents | its own gates. prd.md is the input |
| P7 | Measure the result | product-metrics (update) | metrics.md | you record the real numbers and the user approves the lessons, then go back to P1 |

All documents go in one folder for the initiative. One `memory.md` goes in the same
folder. The build pipeline uses the same folder.

## Context and artifact budget

Use the smallest durable context that supports the next decision. Documentation is
shared memory, not a checklist to complete.

1. Start each stage with a context card: goal, current decision, approved decisions,
   open questions, evidence links, and the next consumer. Read this card first.
2. Read only the artifact required for the current stage and any artifact that changes
   its decision. Point to evidence. Do not paste old documents into a new artifact.
3. Create or update an artifact only when a named later stage, person, or agent needs
   its decision. Record the owner, evidence, decision, and review trigger.
4. Keep the default output short: decision, evidence, risks, and next owner. Expand
   only for uncertainty, material disagreement, or a user request.
5. Escalate the product work when a decision is hard to reverse, affects user trust,
   privacy, money, access, or many user groups. State the trigger before reading more.

For a Quick-tier change, do not request approval when the behavior is minor,
reversible, and unambiguous. Ask only when the change affects visible behavior,
creates a material trade-off, crosses a risk boundary, or the user requests it.
Explicit user instructions override this default.

These rules do not remove evidence or approval gates. They prevent repeated context
loading and documents with no future consumer.

## Transition rules

1. **Enter** at the earliest product decision that can change the requested outcome.
   Start with a decision record for Quick work; start with the relevant stage artifact
   for Standard or High-risk work.
2. **Skip** a stage only when its purpose does not apply. Skip research when current
   evidence answers the decision. Never skip proof for changed behavior.
3. **Resume** from the first decision that is missing, stale, failed, or requires an
   approval that is still pending. Read the context card and artifact status first.
4. **Escalate** when work affects trust, privacy, money, access, many user groups, or
   becomes hard to reverse. Record the trigger before loading more context.
5. **Loop back** to the owner of the changed decision: problem or outcome → P1;
   validation evidence → P3; selection or scope → P4; PRD behavior → P5; metric → P6.

Explicit user instructions override these defaults. Applicable evidence and approval
gates remain mandatory.

## Evidence quality

Every product claim records its source, date, user segment or population, method,
confidence, limitation, and supported decision. Use these levels:

- **High** — direct behavior, product analytics, controlled experiment, or verified interview.
- **Medium** — competitor use, support patterns, or reputable published research.
- **Low** — reviews, social posts, single anecdotes, or unverified claims.

Low evidence generates questions. It does not prove demand alone. Label hypotheses
until tested. Record conflicting or stale evidence instead of hiding it. Use only
authorized data, remove unnecessary personal details, and obtain consent before
storing or reusing interview quotes beyond their original purpose.

A commitment needs High evidence or an explicit owner-approved risk acceptance. Each
research artifact ends with its decision, confidence, open risk, owner, and review trigger.

## Artifact lifecycle

Every product artifact records: Lifecycle (ACTIVE, SUPERSEDED, or ARCHIVED), Owner,
Next consumer, and Review trigger. Keep its existing approval and status fields.
Mark an artifact SUPERSEDED when a newer approved decision replaces it; do not erase
history. Archive only when the initiative ends or the document has no future consumer.
Review an ACTIVE artifact when scope, evidence, user behavior, or its measurement date changes.

## Stage P0: make the folder

Do these steps one time for each initiative:

1. Read what exists now: the README, old specs, and earlier discovery or research notes.
2. Read `.spectrum.json` in the project root, if the file exists. It sets which model
   does which role. The meaning of each field is in the "Configuration: .spectrum.json"
   part of the `development-workflow` skill. In this repository that skill is
   `skills/development/development-workflow/`.
3. Make the folder `{artifacts.specsRoot|specs}/{initiative-kebab-name}/`.
4. Make `memory.md` in that folder from the template
   `../development-workflow/templates/memory.md` (a folder next to this skill).
   Write the folder path in it. If `memory.md` exists, add to it. Do not make it
   again. Stage 1 of the build pipeline must use this same folder.
5. Find which model providers are on the machine. Run the `development-workflow`
   skill's `bin/agent.sh list`.
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
- **To give work to another model**: use `/orchestrator`. It owns delegation policy;
  provide the product stage, decision, evidence, and next gate as the brief.
- **Out of scope**: price, market size, sales plans, and unit economics. This loop is
  about what to build and why.
- **Keep the user informed**: write one line for each stage change —
  `{stage}: {result} → {next step}`.
