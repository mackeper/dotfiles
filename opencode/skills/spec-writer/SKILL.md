---
name: spec-writer
description: Create detailed specifications for features. Specs follow a strict template and enable two developers to implement the same thing independently.
---

## What I do

Create a specification document for a feature using the template below.

## When to use me

Use this when the user wants to document a feature before implementation. The spec must be detailed enough that two different developers would produce essentially the same implementation, but must NOT contain actual code.

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
- Use schema/pseudocode format, NOT actual code

### API Interface
- Describe endpoints, parameters, responses
- Use structure/contract format, NOT actual code

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

## Principles

- **Parsimony**: Use imperative language. "MUST/SHOULD/DO NOT" not "you might want to consider"
- **Traceability**: Each requirement should be uniquely identifiable
- **Implementation detail**: Describe *what* and *how it behaves*, not *how to write it*
  - GOOD: "Function accepts user ID and returns user profile object"
  - BAD: `def get_user(id): return User.objects.get(id)`