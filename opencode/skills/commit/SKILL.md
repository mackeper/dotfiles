---
name: commit
description: "ALWAYS use this skill when committing code changes — never commit directly without it."
---

# commit

## Format

The header is required. All lines must stay under 100 characters.
Exclamation mark after type indicates a breaking change.

```
<type>(<scope>): <subject>

<optional body>

<optional footer>
```

### Commit Types

| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `ref` | Refactoring (no behavior change) |
| `perf` | Performance improvement |
| `docs` | Documentation only |
| `test` | Test additions or corrections |
| `build` | Build system or dependencies |
| `ci` | CI configuration |
| `chore` | Maintenance tasks |
| `style` | Code formatting (no logic change) |
| `meta` | Repository metadata |
| `license` | License changes |

### Header Line Rules

- Use imperative, present tense: "Add feature" not "Added feature"
- Capitalize the first letter
- No period at the end
- Maximum 70 characters

### Body Guidelines

- Explain **what** and **why**, not how
- Use imperative mood and present tense
- Include motivation for the change
- Contrast with previous behavior when relevant

### Footer: Issue References

Reference issues in the footer using these patterns:

```
Fixes GH-1234
Fixes #1234
Fixes SENTRY-1234
Refs LINEAR-ABC-123
```

- `Fixes` closes the issue when merged
- `Refs` links without closing

## Examples

### Simple fix

```
fix(api): Handle null response in user endpoint

The user API could return null for deleted accounts, causing a crash
in the dashboard. Add null check before accessing user properties.

Fixes SENTRY-5678
```

### Breaking change

```
feat(api)!: Remove deprecated v1 endpoints

Remove all v1 API endpoints that were deprecated in version 23.1.
Clients should migrate to v2 endpoints.

BREAKING CHANGE: v1 endpoints no longer available
Fixes SENTRY-9999
```

## Revert Format

```
revert: feat(api): Add new endpoint

This reverts commit abc123def456.

Reason: Caused performance regression in production.
```

## Principles

- Each commit should be a single, stable change
- Commits should be independently reviewable
- The repository should be in a working state after each commit

## Workflow

Copy this checklist and verify before committing:

```
Commit Checklist:
- [ ] Review staged changes: git diff --cached
- [ ] Check recent commits for style: git log --oneline -5
- [ ] Subject line under 70 characters
- [ ] Body explains what and why, not how
- [ ] Issue reference in correct format (if applicable)
```

### Validation

After drafting the commit message:
1. Verify subject line length
2. Confirm imperative mood
3. Check issue references match expected patterns
