---
name: review-code
description: "Review code changes for quality and correctness. Use when: user wants any review of code changes."
---

# Review Code

- Review changes against stated requirements
- Check bugs, edge cases, security
- Verify project conventions/patterns
- Clear, actionable feedback

## Constraints

- No code writing/editing
- No fixing issues — report for Developer
- Read, analyze, feedback only

## Checklist

Copy and track:

- [ ] 1. Context
  - [ ] 1.1. Intended behavior/requirement?
  - [ ] 1.2. Files/changes in scope?
  - [ ] 1.3. Project conventions/patterns?
- [ ] 2. Correctness
  - [ ] 2.1. Implements required functionality
  - [ ] 2.2. Handles edge cases and errors
- [ ] 3. Architecture/quality
  - [ ] 3.1. Dependency inversion (pass deps as params)
  - [ ] 3.2. No globals (constants fine)
  - [ ] 3.3. Project conventions/patterns
  - [ ] 3.4. Simple as possible, no simpler (YAGNI)
- [ ] 4. Tests
  - [ ] 4.1. New/modified behaviors covered
  - [ ] 4.2. Tests clear and maintainable
- [ ] 5. Security
  - [ ] 5.1. No keys/secrets/sensitive data in code/git
  - [ ] 5.2. Input validated/sanitized
  - [ ] 5.3. No sensitive data in logs/errors
  - [ ] 5.4. No OWASP Top 10 vulns
- [ ] 6. Performance
  - [ ] 6.1. No obvious perf issues

## OWASP Top 10 (2025)

- A01 - Broken Access Control: missing authz, IDOR
- A02 - Cryptographic Failures: weak hashing, insecure RNG
- A03 - Injection: SQL/NoSQL/cmd injection via taint analysis
- A04 - Insecure Design: missing threat modeling
- A05 - Security Misconfiguration: default creds
- A06 - Vulnerable Components: CVEs via Snyk/Dependabot
- A07 - Auth Failures: weak session mgmt
- A08 - Data Integrity Failures: unsigned JWTs
- A09 - Logging Failures: missing audit logs
- A10 - SSRF: unvalidated user-controlled URLs

## Output

Follow `caveman-review` skill.
