---
name: debugging
description: Investigates bugs, test failures, and unexpected behavior. Use when encountering errors, crashes, build failures, or incorrect output.
---

# Debug

## Phases

### Phase 1: Root Cause Investigation

1. Read error message carefully

   * Do not skip past errors or warnings
   * Read stack traces completely
   * Note line numbers, file paths, error codes

2. Reproduce consistently

   * Can you trigger it reliably?
   * What are the exact steps?
   * Does it happen every time?
   * If not reproducible -> gather more data, do not guess

3. Check recent changes

   * What changed that could cause this?
   * Git diff, recent commits
   * New dependencies, config changes
   * Environmental differences

4. Trace data flow

   * Where does bad value originate?
   * What called this with bad value?
   * Keep tracing up until you find the source
   * Fix at source, not at symptom

### Phase 2: Pattern Analysis

Find the pattern before fixing.

1. Find working examples
2. Compare and identify differences
3. Do not assume a difference cannot matter
4. Understand dependencies

### Phase 3: Hypothesis and Testing

1. Form a single hypothesis.
2. Make the SMALLEST possible change to test hypothesis.
3. Verify before continuing, else form new hypothesis.
4. When you do not know:
   * Admit you do not know
   * Do not pretend to know
   * Ask for help
   * Search codebase, docs, or web for relevant information

### Phase 4: Implementation

```
Debug Progress:
- [ ] Phase 1: Root cause identified
- [ ] Phase 2: Pattern understood
- [ ] Phase 3: Hypothesis tested
- [ ] Phase 4: Fix verified
```

1. Create smallest test to reproduce the problem
2. Implement single fix for the root cause
3. Verify fix
4. If the fix does not work:
   * STOP
   * Count: How many fixes have you tried?
   * If < 3: Return to Phase 1, re-analyze with new information
   * If ≥ 3: STOP, question the architecture, report back, and ABORT.
