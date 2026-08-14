---
name: retro
description: Feature retrospective after a feature ships (or after any finished piece of work) — collect retro points, review them one by one, quiz the user when useful, and with the user's permission write each lesson into the right place (spec, skill, repo constitution, or memory). Use when the user asks for a retro, a retrospective, "what did we learn", or invokes /retro.
---

# Retro

Close the loop after work is done: find what the plan got wrong, what worked, and what must change — then put each lesson where the next feature will actually find it.
Use `simplified-english` for all retro text. Run interactively (same rule as `/quiz-me`): prefer the harness's native question tool for every choice; if none exists, ask in plain text and wait.

## Collect the retro points

Gather candidate points from, in this order:

1. The feature folder, if one exists: `memory.md` (decisions, tried-and-failed, open questions), `review-report.md`, `qa-report.md`, `implementation-report.md`, and diffs between what the specs said and what was built.
2. The current session: reworks, surprises, wrong assumptions, repeated corrections from the user.
3. The user: ask "What else went well, went wrong, or surprised you?"

Merge duplicates. Keep 3–7 points — if you have more, ask the user which ones matter. Each point gets one line: `{what happened} → {what it suggests}`.

Show the full list once, numbered, and confirm it with the user before the review starts. Do not review anything the user removes.

## Review the points one by one

Never process the list in bulk. For each point, in order, run this loop and finish it completely before moving to the next point:

### 1. Retro summary

State, in a few short sentences:

- **What happened** — the fact, with evidence (file, report line, or session moment). No assumption: if you cannot point at evidence, ask the user what happened or drop the point.
- **Why it happened** — the cause, as far as the evidence shows. If the cause is unclear, ask why instead of guessing.
- **Lesson** — one sentence a future feature can act on.

### 2. Quiz (only when useful)

If the point involves a concept the user may want to lock in — a root cause, a pattern, a rule — offer a 1–2 question check via the `quiz-me` skill (level `eli5` or `medium`). Give the reason for offering it (for example: "this same cause appeared twice this feature"). Skip the quiz for points that are pure process notes; do not quiz for the sake of it.

### 3. Propose where the lesson lives

Recommend one or more targets, each with the reason it fits:

| Target | Use when the lesson is... |
| ------ | ------------------------- |
| **Spec** (product/technical/contract spec in the feature folder) | a gap or error in this feature's own documents that would mislead a later reader. |
| **Repo skill** (a `SKILL.md` this repo owns, when the lesson is about how a skill/stage should work) | a process fix — a stage asked the wrong question, missed a check, or needed a rule. |
| **Repo constitution** (`CLAUDE.md` / `AGENTS.md` / contributing docs) | a project-wide rule every future session must follow. |
| **Memory** (feature `memory.md`, or the global memory when the lesson crosses features) | context worth remembering that is not a rule — decisions, tried-and-failed, gotchas. |
| **Nowhere** | one-time noise. Say so and give the reason. |

Rules for the recommendation:

- Name the exact file and show the exact text you would add or change, before asking.
- Only propose a target that exists — check first. If a natural target does not exist (no constitution file, no matching skill), say so and ask the user whether to create it.
- Never edit based on assumption about intent. If the lesson could be read two ways, ask which one the user means before drafting the text.

### 4. Ask permission, then apply

Ask the user per point (interactive choices): **apply to {X}**, **apply to {Y}**, **edit the wording first**, or **skip**. Multi-select when several targets fit.

- Apply only what the user approved, exactly as approved.
- Writes to the repo constitution or to repo skills always require this explicit per-point permission — never batch-approve them, and never treat approval for one point as approval for the next.
- After applying, show a one-line confirmation with the file path.

Then move to the next point.

## Close the retro

After the last point, give a short summary:

> **Retro: {feature or topic}**
>
> **Points reviewed:** {n}
> **Changes applied:** {list of `file — one-line change`, or "none"}
> **Skipped:** {points with the user's reason}
> **Open:** {anything the user deferred, with where it was noted}

If any point was deferred, record it in `memory.md` (with permission) so the next session can pick it up.

## Rules

- One point at a time, full loop each — summary, optional quiz, targets, permission — before the next.
- Every recommendation names its reason and its evidence. Unsure → ask what or why; never fill the gap with an assumption.
- Never write to any file without per-point permission. Show the diff-level text before asking.
- Keep the retro blameless: describe what the process and documents did, not what a person failed at.
