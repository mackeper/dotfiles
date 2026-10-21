---
name: readonly
description: Answer any question or preview proposed changes read-only, without editing, running, or committing anything. Stays active for every following turn until the user explicitly exits or asks for implementation. Use when the user says "just tell me", "don't change anything", "just answer", "read only", "/ask", "/readonly", or invokes /readonly.
---

# Readonly

Answer question. No touch file. No side-effect cmd.

Readonly mode sticky. Once on, stay on every turn after, until user say exit word.

## Rules

- No `edit`, `create`, or any disk-write cmd while skill live. No commit, no stage, no run-that-mutates.
- Investigate free: view, grep, glob, read-only powershell, web search/fetch, read-only MCP tools. Whatever need to answer right.
- Question about code/design/concept → answer straight, cite [file](/path/to/file) or [symbol](/path/to/file:42) where relevant.
- Question that implies a code change → show proposed change as unified diff (`--- a/path` / `+++ b/path`) or before/after block, one per file, each with one line why.
- Multi-file: stack under file path headers, links to real files.
- End: one line, what answer means or what applying shown diff would do.
- User say apply/do it → exit mode (see below), then apply exact shown, no silent plan swap.

## Stay in mode

- Every new user turn while mode live: re-read this skill, follow it again. No drift back to edit mode on own.
- Follow-up question, "what about X", "why", "show me other file", new topic, new task → still readonly mode. Answer read-only.
- User ask for plan, design, review, estimate → still readonly mode. Words on screen, no file write.
- Unsure if user want implement? → stay readonly mode, ask user one question: answer only, or implement?
- Each answer end with one small tail: `(readonly mode on. say "implement" or "exit readonly" to build.)`

## Exit mode

Exit only on explicit user word. Examples:

- "apply it", "do it", "make the change", "implement", "go ahead and change"
- "stop readonly mode", "exit readonly", "leave readonly", "exit ask", "back to normal"
- User approve a shown diff and tell to write it.

On exit: say readonly mode off in one line, then do the work normal.

Not exit: user thank, user ask more question, user disagree, user give more context, session get long.

## Boundaries

Read-only while mode live, always. Never `edit`, `create`, write, stage, commit, or run mutating cmd. Only explicit exit word turn write back on.
