---
name: debugging
description: Investigates bugs, test failures, and unexpected behavior. Use when encountering errors, crashes, build failures, or incorrect output.
---

# Debug

## Phase 1: Root Cause

1. Read error message carefully
   * No skipping errors/warnings
   * Read full stack traces
   * Note line numbers, file paths, error codes

2. Reproduce consistently
   * Trigger reliably?
   * Exact steps?
   * Every time?
   * Not reproducible → gather more data, no guessing

3. Check recent changes
   * What changed?
   * Git diff, recent commits
   * New deps, config changes
   * Environmental differences

4. Trace data flow
   * Where does bad value originate?
   * What called with bad value?
   * Trace up to source
   * Fix at source, not symptom

## Phase 2: Pattern Analysis

Find pattern before fixing.

1. Find working examples
2. Compare, identify differences
3. No difference too small to matter
4. Understand dependencies

## Phase 3: Hypothesis Testing

1. Single hypothesis
2. SMALLEST possible change to test
3. Verify before continuing, else new hypothesis
4. When don't know:
   * Admit it
   * No pretending
   * Ask for help
   * Search codebase/docs/web

## Phase 4: Implementation

```
Debug Progress:
- [ ] Phase 1: Root cause identified
- [ ] Phase 2: Pattern understood
- [ ] Phase 3: Hypothesis tested
- [ ] Phase 4: Fix verified
```

1. Smallest test to reproduce
2. Single fix for root cause
3. Verify fix
4. Fix doesn't work:
   * STOP
   * Count fix attempts
   * < 3: Return to Phase 1, re-analyze with new info
   * ≥ 3: STOP, question architecture, report back, ABORT
