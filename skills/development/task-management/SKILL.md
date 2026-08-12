---
name: task-management
description: Break a plan, spec, or conversation into atomic, dependency-ordered tickets (tracer-bullet vertical slices), or review tasks against their specs. Use for "break down this plan/spec into tasks", "create tickets", "task breakdown", or "review task T00X against the spec".
---

# Task Management

Two modes. Pick by the argument the user passes.

- `create` — Break a plan, spec, or conversation into a set of tickets. Each ticket is a tracer-bullet vertical slice that declares the tickets that block it. Group tickets by user story (if any exist) or by subset of a large feature work group.
- `review` — Review each task (or a specific task the user names) — its requirements and acceptance criteria — against the provided specs.

## Principles

**Context budget**: apply the "Risk and token budget" protocol in
../development-workflow/SKILL.md; load more only when it changes the current decision.

- List small, atomic tasks.
- Order work from trivial and lowest-risk to most complex.
- Use checkboxes and stable task ids (`T001`, `T002`, ...).
- Keep checklist status updated immediately whenever a task is done, blocked, or changed.
- Add dependency notes on tasks when relevant: `backend required`, `frontend required`, `desktop required`, `web required`, `cross-platform`, `infra`, `blocked`.
- Add a **Reflection** block after every 10 tasks.

## Execution Rules

- Work tasks in order unless blocked.
- Mark tasks complete as work lands.
- Keep reflections short: done, surprises, follow-up, verification, context note.
- Keep retros short: what changed, what got easier, what created risk, what remains.
- Do not bloat docs. Prefer concise evidence and links over long prose.

## Process

1. **Context Gathering** — Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.
2. **Explore Codebase** — ONLY IF you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the project's domain glossary vocabulary and respect ADRs in the area you're touching.
3. **Break Down the Task** — Apply the principles above using the templates below.

## Ticket Template

```md
Title: <task title>
User Stories: <reference to available user stories; attach path if needed>
Context Reference: <reference into existing conversation or any other file>
Blocked by: <task dependencies>
Goal: <goal of this task>
Acceptance criteria: <criteria based on the context you have>
What it delivers: <the end-to-end behaviour this ticket makes work>
```

## Quiz the User When

1. You don't have enough context to break down the task.
2. A path is unclear or you are relying on an assumption — assumptions are not allowed here.
3. A ticket is too large; propose breaking it into smaller parts and confirm.
4. Any other point where clarification is needed.

## Publish

### Local Document

If the tasks live as a local markdown document, use this layout:

```md
{existing spec path}/
  tasks/
    tasks.md                      # main task checklist
    {specific-task-number}-task.md  # one file per ticket, using the ticket template above
```

`tasks.md` holds the checklist:

```md
# Tasks: <task name>

## Queue

- [ ] T001 <trivial / lowest-risk task>  `backend required`
- [ ] T002 <low-risk edit>
- [ ] T003 <main edit>  `blocked` (T002)
- ...

**Reflection After T010**

- Done:
- Surprises:
- Follow-up:
- Verification:
- Context note:
```

### Jira / Linear / GitHub Issue

Publish one issue per ticket in dependency order (blockers first) so each ticket's blocking edges can reference real identifiers.

- Use the platform's native blocking / sub-issue relationship where it has one.
- Otherwise, set each ticket's "Blocked by" to the blocking issues.

## Review Mode

When invoked with `review`:

1. Load the target tasks — all of them, or the specific task the user names.
2. Load the referenced specs.
3. For each task, check its requirements and acceptance criteria against the spec: is the criteria complete, correct, testable, and consistent with the spec? Flag gaps, contradictions, missing edge cases, and unstated assumptions.
4. Report concisely per task: pass / gaps found, with links to the spec section.
