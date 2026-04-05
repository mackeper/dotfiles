---
name: spec-writer
description: "Create detailed specifications for features. Specs follow a strict
template and enable two developers to implement the same thing independently."
---

## What I do

Create a specification document for a feature using the template below.

## When to use me

Use this when the user wants to document a feature before implementation. The
spec must be detailed enough that two different developers would produce
essentially the same implementation, but must NOT contain actual code.

## Naming convention

`docs/specs/YYYY-MM-DD_<order>_<feature>_spec.md`

- Example: `docs/specs/2026-04-01_01_login_spec.md`
- Use 2-digit order number (01, 02, 03...)

## Template

```markdown
# <feature name>

## Overview
1-2 paragraphs describing what this feature does and why it exists.

## Scope

### In Scope
- List of features that must be implemented

### Out of Scope
- Explicit list of what this spec does NOT cover

## Requirements

### Functional Requirements
- Each requirement describes *what* the feature does
- Describe behavior, not implementation

### Data & Structures
- Describe data entities, fields, relationships
- Use schema/code-snippets format, NOT whole code

### API Interface
- Describe endpoints, parameters, responses
- Use structure/contract format/function signature, NOT whole code

## Technical Considerations

- Technology recommendations (if any)
- Integration points
- Dependencies

## Edge Cases

- Error conditions
- Boundary conditions
- Invalid inputs
- Failure modes

## Goals (Optional)
- Success metrics
- Key performance indicators
```

## Key Principles

- Use MUST / MUST NOT / SHOULD
- No implicit assumptions
- Each requirement should be uniquely identifiable
- Reference requirement IDs everywhere applicable
- Describe *what* and *how it behaves*
  - GOOD: "Function `get_user` accepts user ID and returns `user` object"
- Exact commands with expected output
- Exact file paths always
- Prefer verbosity over ambiguity

## No Placeholders
Every step must contain the actual content an engineer needs. These are plan failures — never write them:

- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without details)
- "Similar to Task N" (repeat the information — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task

## Self-Review
After writing the complete plan, look at the spec with fresh eyes and check the
plan against it. This is a checklist you run yourself — not a subagent
dispatch.

**1. Spec coverage**
Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan**
Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Type consistency**
Do the types, method signatures, and property names you used in later tasks
match what you defined in earlier tasks? A function called clearLayers() in
Task 3 but clearFullLayers() in Task 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move
on. If you find a spec requirement with no task, add the task.
