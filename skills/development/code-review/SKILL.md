---
name: code-review
description: Standalone three-axis code review of the diff between HEAD and a fixed point — Spec (does it implement the intent), Standards (does it follow the repo's documented conventions), Risk (is it safe in production, judged with a Principal Engineer mindset). Axes run as parallel subagents; findings stay separated per axis and never rerank across axes. Code smells and style are a linter's job, never a review finding. Use when the user asks to review a diff, branch, or PR outside the /development-workflow pipeline (inside it, use /impl-review), or invokes /code-review.
---

# Code Review

Review the diff between `HEAD` and a fixed point the user supplies, on three independent axes:

- **Spec** — does the code faithfully implement the originating issue / spec?
- **Standards** — does the code conform to this repo's documented standards?
- **Risk** — is the change correct, safe in production, and operable? (Principal Engineer review, `references/risk-checklist.md`.)

Each axis runs as a **subagent** so they don't pollute each other's context. This skill (the coordinator) does the setup, spawns them, and aggregates — it does not review lines itself, and it does not read the `references/` files (they are for subagents only).

A change can pass one axis and fail another: perfectly styled code that implements the wrong thing (Standards pass, Spec fail); code that does exactly what the issue asked but races under retry (Spec pass, Risk fail). Keeping the axes separate stops one from masking another. Never merge or rerank findings across axes.

**Token rule** — never paste into a brief what a subagent can read itself. Briefs carry *commands and paths* (diff command, spec path, standards paths, reference-file paths, change-model path), not contents. The only pasted text is the few lines of brief-specific instructions below.

## Process

### 1. Pin and scope the fixed point

Whatever the user said is the fixed point — a SHA, branch, tag, `main`, `HEAD~5`. If they didn't give one, ask.

- `git rev-parse <fixed-point>` — must resolve; stop here if not.
- Build the pathspec excluding generated noise: `-- . ':!*.lock' ':!*lock.json' ':!*lock.yaml'` plus vendored/generated dirs and snapshot files you spot in the stat. Call the full command `DIFF_CMD` = `git diff <fixed-point>...HEAD <pathspec>` (three-dot, merge-base comparison).
- `git diff <fixed-point>...HEAD --stat <pathspec>` — must be non-empty; stop here if not. Keep the changed-file list and total line count.
- `git log <fixed-point>..HEAD --oneline` — the commit list.

A bad ref or empty diff fails here, not inside parallel subagents.

### 2. Establish context (coordinator only)

From the stat, commits, and any linked issue, write a **change model** — 5–10 lines — to a scratch file (`CHANGE_MODEL` path):

- What problem is being solved; what behavior changes; what must not change.
- The path of the change: caller → entry point → logic → persistence / external dependency → side effects → consumer.
- Which systems, contracts, or consumers depend on the touched code.

Do not start reviewing lines.

### 3. Identify the spec source

In order:

1. A feature folder from /development-workflow (`product-spec.md`, `technical-spec.md`, `contract-spec.md`) matching the branch or the user's pointer.
2. Issue references in commit messages (`#123`, `Closes #45`, `!67`) — fetch via `gh` / `glab` (or the project's documented issue-tracker workflow) **once, into a scratch file**; pass that path.
3. A path the user passed as an argument.
4. A spec file under `docs/`, `specs/`, or `.scratch/` matching the branch or feature name.
5. Ask the user. If they say there is none, skip the Spec axis and say so in the final report.

### 4. Identify the standards sources

Collect *paths* to anything documenting how code should be written: `CODING_STANDARDS.md`, `CONTRIBUTING.md`, `CLAUDE.md` code rules, lint configs with prose comments. Don't read them — the Standards subagent will.

Code smells and style opinions are a linter's job, never a review finding. The Standards axis checks only what the repo documents; if the repo documents nothing, skip the axis and say so in the final report.

### 5. Size the fan-out

- **Docs-only diff** → Standards axis only.
- **No spec found** → skip the Spec axis.
- **No documented standards found** → skip the Standards axis.
- **Small diff** (under ~150 changed lines) → one combined subagent that reads all applicable reference files and reports per-axis sections; skip the parallel fan-out.
- Otherwise → one subagent per applicable axis, all spawned in a single message.

Effort: run Spec and Standards subagents at **low reasoning effort**; Risk (or the combined small-diff agent) at normal effort.

### 6. Spawn the subagents

Every brief carries these pointers (paths/commands, never contents):

- `DIFF_CMD`, the changed-file list, and the commit list. Tell the subagent: run the diff yourself; on large diffs pull per-file hunks (`git diff <fixed-point>...HEAD -- <paths>`) instead of the whole thing.
- `CHANGE_MODEL` path — read first.
- `references/charter.md` path — read it; severity ladder, finding format, and ground rules are binding.

Then per axis:

**Spec** — add the spec path(s). Brief:
> Read the spec, then report: (a) requirements asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but wrong. Quote the spec line for each finding. Judge fidelity only — not style, not production risk.

**Standards** — add the standards-source paths. Brief:
> Read the standards sources, then report per file/hunk every place the diff violates a documented standard — cite the standard (file + rule) and quote the hunk. Only documented standards count: no code-smell hunting, no style opinions — that is a linter's job. Skip anything tooling already enforces. Judge conformance only — not spec fidelity, not production risk.

**Risk** — add `references/risk-checklist.md`. Brief:
> Read the checklist and apply it where the diff touches its areas, including the adversarial scenarios. Judge production safety only — not spec fidelity, not style.

### 7. Aggregate

Present the reports under `## Spec`, `## Standards`, `## Risk` headings, verbatim or lightly cleaned. Do **not** merge or rerank findings across axes.

End with:

- One line per axis: finding count and the worst issue *within that axis*. Never pick a single winner across axes.
- **Testing gaps** tied to concrete risk (from the Risk report), if any.
- A verdict with a short reason, derived mechanically: any P0/P1 on any axis → `REQUEST CHANGES`; spec missing or too ambiguous to judge a material behavior → `NEEDS DISCUSSION`; only P2/P3/Nit → `APPROVE WITH NON-BLOCKING COMMENTS`; nothing at all → `APPROVE`.
