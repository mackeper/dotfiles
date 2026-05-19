---
name: "review-security"
description: "Review code for security vulnerabilities in a medical device service. Use when: security reviewing code changes, auditing for PHI leaks, checking deserialization safety, validating trust boundaries."
user-invocable: true
---

# Security Review

Review changes for security vulns in stateless medical device Windows service. No writing/fixing — report only.

## Prerequisites

Read active `.instructions.md` for language conventions. Understand trust boundaries from project context.

## Context

- **Stateless Windows service** — no DB, no persistent state
- **Medical device** — patient safety critical; data integrity failures → harm
- **No PHI in logs** — never in log output, exceptions, error messages

## Do NOT Flag

- XSS, CSRF, SQL injection, cookie security — N/A
- Style, readability, general correctness — out of scope

## Steps

1. **Scope** — files changed, security-relevant behavior affected
2. **Deserialization** — no `BinaryFormatter`, `TypeNameHandling.None` in Newtonsoft, no polymorphic deser of untrusted input
3. **Cmd/process injection** — no `Process.Start()` with unsanitized input, no `cmd /c` + concatenation
4. **Path traversal** — file paths validated with containment checks, no user-controlled paths to file I/O
5. **PHI in logs** — patient names/IDs/treatment/DICOM tags never logged; exception msgs sanitized
6. **Secrets** — no hardcoded creds/keys/certs; sensitive config encrypted
7. **Memory safety** — bounds checking in buffer ops, no unjustified unsafe, disposables handled
8. **Exceptions** — no stack traces/internals leaked to callers, specific catches
9. **Concurrency** — thread-safe shared state, no races, proper locking
10. **Crypto** — secure RNG for security values, TLS 1.2+, proper key sizes
11. **Access control** — endpoints restricted, least privilege for service account
12. **Config** — no secrets in committed config, permissions minimally scoped

## Output

```
Verdict: Secure | Concerns Found

Findings:
- [critical] <file>: <description> | Safety impact: <yes/no>
- [high] <file>: <description> | Safety impact: <yes/no>
- [medium] <file>: <description> | Safety impact: <yes/no>
- [low] <file>: <description> | Safety impact: <yes/no>

Good:
- <what was done well>
```

One line per item. Omit empty sections.
