---
name: quiz-me
description: Quiz the user on a topic to check and strengthen their understanding. Default source is the current session — quiz on topics that stayed unresolved or unanswered. Use when the user says "quiz me", "test me", "check my understanding", or invokes /quiz-me.
---

# Quiz Me

Turn a topic into a short quiz, run it one question at a time, and explain every answer.
Use `simplified-english` for all quiz text.

## Interactive mode

Run the quiz as interactively as the agent harness allows. Prefer, in this order:

1. A native question tool with selectable options (for example `AskUserQuestion` in Claude Code) — present the options as choices the user can click or select. Use it for every multiple-choice question, the level pick, and the retry offer.
2. If no question tool exists, ask in plain text and wait for the user's reply before you continue.

Never fall back to a non-interactive dump of all questions because a tool is missing — the one-question-at-a-time flow is the minimum, not optional. Short-answer and open questions always go through plain text, even when a question tool exists.

## Pick the source

1. If the user gives a topic, quiz on that topic.
2. If the user gives no topic, scan the current session for material that stayed open:
   - Questions the user asked but did not fully close.
   - Concepts the assistant explained but the user never confirmed.
   - Decisions made where the reason was not stated.
   - Errors or surprises that were fixed but not explained.
3. If the session has no such material and no topic is given, ask: "What topic do you want the quiz on?" Do not invent a topic.

Before you start, state the source in one line: "Quiz source: {topic or session summary}."

## Pick the level

Three levels. If the user names one, use it. If not, recommend one and give the reason
(for example: "I recommend **medium** because you already used these terms correctly in this session").
Never base the recommendation on a guess about the user — if the session gives no signal, ask which level they want.

| Level | Questions | Question style | Answer style |
| ----- | --------- | -------------- | ------------ |
| `eli5` | 3–5 | One idea per question, asked with the `eli5` skill's Shape: a familiar comparison first, the real technical terms after. Yes/no or pick A/B. | One-sentence explanation with a familiar comparison. |
| `medium` | 5–7 | One idea per question, some with a short scenario. Multiple choice (A–C) or short answer. Correct technical terms. | 2–3 sentence explanation: why the right answer is right, why the closest wrong one is wrong. |
| `comprehensive` | 7–10 | Scenarios, edge cases, and "what happens if" questions. Multiple choice (A–D), short answer, and one open question. May combine two related ideas. | Full explanation: the rule, the reason behind the rule, the trade-off, and one real example. |

All three levels keep the same principle: short questions, one clear correct answer (except the open question), and an explanation the user can learn from even when they answer correctly.

## Question template

Use this shape for every question:

> **Q{n} of {total}** — {topic tag}
>
> {question, max 2 sentences}
>
> A. {option}
> B. {option}
> C. {option — medium and up}
> D. {option — comprehensive only}

For short-answer and open questions, drop the options and say what a good answer must contain.

### eli5 question shape

At the `eli5` level, never open a question with a technical term. Follow the `eli5` skill's Shape: state the idea in common words with a familiar comparison first, then attach the real technical terms after it. The question tests the idea; the terms only give it a name.

> **Q{n} of {total}** — {topic tag}
>
> **Think of it like:** {familiar comparison in common words}
>
> **The question:** {ask about the idea, still in common words}
>
> **The real names:** {the technical terms this maps to, one line}
>
> A. {option in common words}
> B. {option in common words}

Example — instead of "`useEffect` runs AFTER the browser shows the new picture, `useLayoutEffect` runs BEFORE. True or false?":

> **Think of it like:** you can fix a poster either before or after people walk past the wall. If you fix it after, some people see the wrong poster for a moment.
>
> **The question:** one of React's two "run my code" hooks works before people see the screen, the other after. Does the "after" one risk a visible flicker?
>
> **The real names:** the "before" hook is `useLayoutEffect`, the "after" hook is `useEffect`.
>
> A. Yes, the "after" one can flicker
> B. No, both look the same

## Run the quiz

1. Ask one question. Wait for the answer.
2. After each answer, respond with this shape:

   > **{Correct / Not correct}.** The answer is {X}.
   >
   > **Why:** {explanation at the level's answer style}
3. Track the score. Do not repeat a question the user got right.
4. After the last question, give a result:

   > **Score:** {right}/{total}
   >
   > **Strong:** {what the user clearly knows}
   >
   > **Review:** {topics missed, each with a one-line pointer to what to reread or retry}
5. If the user missed 2 or more questions on one topic, offer a short retry round on that topic only.

## Rules

- One question at a time. Never dump the full quiz.
- Use the harness's interactive question tool for choices whenever one is available (see Interactive mode).
- Never mark an answer wrong for wording. Judge the idea.
- If the user's answer shows a different but valid understanding, say so and give credit.
- If you are not sure what the user meant, ask before you grade.
- Every recommendation (level, retry, what to review) must name its reason and its evidence. No reason from assumption — when unsure, ask what or why.
- Keep exact commands, code, and values in a visible code block when a question uses them.
