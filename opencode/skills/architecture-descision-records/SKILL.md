---
description: "Use when: A significant architectural decision has been made."
---

# Architecture decision records (ADRs)

## Use when

* Making a significant architectural decision
* Documenting technology choices
* Recording design trade-offs

## Do not use this skill when

* Only need to document small implementation details
* The change is a minor patch or routine maintenance
* There is no architectural decision to capture

## Instructions
* Capture the decision context, constraints, and drivers.
* Document considered options with trade-offs.
* Record the decision, rationale, and consequences.
* Link related ADRs and update status over time.

## Naming

- <id>: 4 digits, e.g. 0012
- <name>: 1-3 words of the decision
- `docs/adr/ADR-<id>-<name>.md`

## Core concepts

## Template (lightweight)

```markdown
# ADR-0012: Adopt TypeScript for Frontend Development

**Status**: Accepted
**Date**: 2024-01-15
**Deciders**: @alice, @bob, @charlie

## Context

Our React codebase has grown to 50+ components with increasing bug reports
related to prop type mismatches and undefined errors. PropTypes provide
runtime-only checking.

## Decision

Adopt TypeScript for all new frontend code. Migrate existing code incrementally.

## Consequences

**Good**: Catch type errors at compile time, better IDE support, self-documenting
code.

**Bad**: Learning curve for team, initial slowdown, build complexity increase.

**Mitigations**: TypeScript training sessions, allow gradual adoption with
`allowJs: true`.
```
## Best Practices

### Do's

* Write ADRs early - Before implementation starts
* Keep them short - 1-2 pages maximum
* Be honest about trade-offs - Include real cons
* Link related decisions - Build decision graph
* Update status - Deprecate when superseded

### Don'ts

* Don't change accepted ADRs - Write new ones to supersede
* Don't skip context - Future readers need background
* Don't hide failures - Rejected decisions are valuable
* Don't be vague - Specific decisions, specific consequences
* Don't forget implementation - ADR without action is waste
