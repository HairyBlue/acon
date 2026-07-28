---
name: security-audit
description: Static code security auditing skill covering 50+ vulnerability types across PHP, JavaScript/Node.js, Python, and C#/.NET. Use when performing security audits, code reviews for vulnerabilities, or pre-deployment security checks.
license: MIT
metadata:
  version: "1.0.0"
  supported_languages: ["php", "javascript", "typescript", "python", "csharp"]
---

# Security Audit Skill

Professional static code analysis and security auditing skill tailored for **PHP**, **JavaScript / TypeScript (Node.js)**, **Python**, and **C# (.NET)**.

## Audit Workflow

```
1. Reconnaissance   → Map project tech stack, frameworks, routers, and entry points.
2. Vulnerability Hunt → Trace data flow from user inputs to dangerous sinks across D1-D10 dimensions.
3. Verification    → Confirm exploitability, eliminate false positives, and assess severity.
4. Remediation     → Document findings with clear root cause, PoC impact, and secure code fixes.
```

---

## Audit Modes

| Mode | Use Case | Target Scope |
| :--- | :--- | :--- |
| **Quick** | CI/CD pipelines, quick PR checks | High-risk injections (SQLi, RCE), hardcoded secrets, known CVEs |
| **Standard** | Regular security code reviews | OWASP Top 10, Auth/IDOR, Cryptography, File Operations |
| **Deep** | Pre-deployment audits, critical modules | Full D1–D10 matrix coverage, business logic flaws, attack chain tracing |

---

## Security Dimensions Coverage Matrix (D1–D10)

Refer to [`checklists/coverage-matrix.md`](checklists/coverage-matrix.md) for full coverage criteria.

- **D1: Injection**: SQLi, Command Injection, SSTI, NoSQLi, Code Execution (`eval`).
- **D2: Authentication**: Weak hash comparison, missing session regeneration, broken JWT verification.
- **D3: Authorization & Access Control**: IDOR, broken object-level authorization, missing role middleware.
- **D4: Deserialization & Prototype Pollution**: Unsafe `unserialize()`, `pickle`, `BinaryFormatter`, Prototype Pollution.
- **D5: File Operations**: Path traversal, unrestricted file upload, Zip Slip, arbitrary file deletion.
- **D6: SSRF**: User-controlled URL fetching, Cloud metadata endpoint access (`169.254.169.254`).
- **D7: Cryptography**: Hardcoded secrets, ECB mode, weak PRNG (`rand()`, `mt_rand()`), broken hash algorithms (`MD5`, `SHA1`).
- **D8: Security Configuration**: Exposed debug endpoints, overly permissive CORS (`*`), detailed stack traces in production.
- **D9: Business Logic**: Mass assignment, parameter tampering, race conditions, type confusion (`==`).
- **D10: Supply Chain**: Outdated dependencies with known CVEs (`composer.lock`, `package-lock.json`, `requirements.txt`, `.csproj`).

---

## Language Specific Checklists

Query the target language checklist when auditing matching files:

- **PHP & Laravel / WordPress**: [`checklists/php.md`](checklists/php.md)
- **JavaScript / Node.js / Express / Next.js**: [`checklists/javascript.md`](checklists/javascript.md)
- **Python / Django / FastAPI / Flask**: [`checklists/python.md`](checklists/python.md)
- **C# / .NET Core / ASP.NET**: [`checklists/dotnet.md`](checklists/dotnet.md)
