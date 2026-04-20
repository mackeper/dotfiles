---
name: review-code
description: "Review code changes for quality and correctness. Use when: user wants any review of code changes."
---

# Review code

- Review code changes against the stated requirements
- Check for bugs, edge cases, and security issues
- Verify adherence to project conventions and patterns
- Provide clear, actionable feedback

## Constraints

- **DO NOT** write or edit code
- **DO NOT** fix issues yourself — report them for the Developer
- **ONLY** read, analyze, and provide feedback

## Review checklist:

Copy this checklist and track progress:

- [ ] 1. Understand the context and stated problem
- [ ] 2. Correctness
  - [ ] 2.1. Implements the required functionality
  - [ ] 2.2. Handles edge cases and errors
- [ ] 3. Architecture and quality
  - [ ] 3.1. Dependencies inversion (pass dependencies as parameters)
  - [ ] 3.2. No global variables (Constants are fine)
  - [ ] 3.3. Project conventions and patterns
  - [ ] 3.4. As simple as possible, but no simpler (YAGNI)
- [ ] 4. Tests
  - [ ] 4.1. New/modified behaviors are covered by tests
  - [ ] 4.2. Tests are clear and maintainable
- [ ] 5. Security
  - [ ] 5.1. No API keys, secrets, or sensitive data in code or git
  - [ ] 5.3. User input is validated/sanitized
  - [ ] 5.4. No sensitive data exposure in logs or error messages
  - [ ] 5.5. No OWASP Top 10 vulnerabilities
- [ ] 6. Performance
    - [ ] 6.1. No obvious performance issues

## Resources

### OWASP Top 10 (2025)

- A01 - Broken Access Control: Missing authorization, IDOR
- A02 - Cryptographic Failures: Weak hashing, insecure RNG
- A03 - Injection: SQL, NoSQL, command injection via taint analysis
- A04 - Insecure Design: Missing threat modeling
- A05 - Security Misconfiguration: Default credentials
- A06 - Vulnerable Components: Snyk/Dependabot for CVEs
- A07 - Authentication Failures: Weak session management
- A08 - Data Integrity Failures: Unsigned JWTs
- A09 - Logging Failures: Missing audit logs
- A10 - SSRF: Unvalidated user-controlled URLs

## Output

- **Follow** the caveman-review skill.
