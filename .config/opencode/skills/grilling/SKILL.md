---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
metadata:
  source: "https://github.com/mattpocock/skills/tree/main/skills/productivity/grilling"
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: one `ask_user` call per round, then wait for the answers before the next round.

Build each round's form like so:

- The `ask_user` message holds the full context: one numbered entry per question (`Q1 - <title>: <body>`) with your recommended answer and why. The form hides reply text written before it, so everything the user needs to decide goes in the message.
- One field per question, keyed `q1`, `q2`, ..., in question order, titled `Q1 - <title>`.
- Known options: a single-select `enum`. Open-ended: a `string`. Yes/no: a `boolean`.
- Set each field's `default` to your recommended answer, so accepting the form accepts every recommendation.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
