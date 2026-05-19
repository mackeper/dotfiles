---
name: "review-csharp"
description: "Review C# changes for correctness, style, and adherence to requirements. Use when: reviewing C# code, checking a C# implementation, validating C# changes against conventions."
user-invocable: true
---

# Review C# Code

Review C# changes for correctness, quality, consistency. No writing/fixing — report only.

## Prerequisites

Read active `.instructions.md` first. They define project style, test patterns, conventions — override generic rules. Flag deviations as issues.

## Steps

1. **Scope** — which files changed, intended behavior
2. **Correctness** — logic errors, off-by-one, missing branches, wrong returns
3. **Null safety** — nullable ref types correct, null checks at boundaries
4. **Async/await** — no `.Result`/`.Wait()`, cancellation token propagation, `ConfigureAwait(false)` in libs
5. **Disposables** — `IDisposable` via `using`
6. **LINQ** — no multiple enumeration, no LINQ in hot paths
7. **Thread safety** — shared mutable state protected, concurrent collections where needed
8. **Exceptions** — specific catches, nothing swallowed, `ExceptionDispatchInfo` when rethrowing
9. **Naming/style** — per active instructions
10. **Tests** — new/modified behavior covered, naming/structure per instructions
11. **Simplicity** — no over-engineering, dead code, unnecessary abstractions

## Output

```
Verdict: Approve | Request Changes

Issues:
- (01) [critical] <file>: <description>
- (02) [minor] <file>: <description>
- (03) [nit] <file>: <description>

Good:
- <what was done well>
```

One line per item. Omit empty sections.
