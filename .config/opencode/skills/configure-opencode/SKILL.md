---
name: configure-opencode
description: Fetch opencode.ai docs for configuration topics including commands, skills, rules, and agents
---

## What I do
When you want to configure opencode, fetch the official docs from:
- https://opencode.ai/docs/commands/
- https://opencode.ai/docs/skills/
- https://opencode.ai/docs/rules/
- https://opencode.ai/docs/agents/

## When to use me
Use this when the user asks how to configure opencode or wants to understand opencode configuration options.

## New agents

New agents shall always define the frontmatter with all tools. true/false depends on the agent:
```markdown
---
description: "<description>"
name: "<name>"
mode: "<subagent/primary>"
tools:
  write: true        # Write to files
  edit: true         # Edit files
  bash: true         # Execute shell commands
  glob: true         # Find files by pattern
  grep: true         # Search contents in files
  ls: true           # List directory contents
  view: true         # View file contents
  patch: true        # Apply patches to files
  diagnostics: true  # Get code diagnostics/lint info
  fetch: false       # Fetch data from URLs
  sourcegraph: true  # Search code across public repositories
  agent: false       # Run sub-tasks with other agents
---
```
