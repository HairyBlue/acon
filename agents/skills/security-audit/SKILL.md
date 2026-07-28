---
name: security-audit
description: Static code security auditing skill covering 50+ vulnerability types across PHP, JavaScript/Node.js, Python, and C#/.NET. Orchestrates sub-directories for core logic, frameworks, checklists, languages, security principles, case studies, wooyun archives, and reporting templates. Use when performing security audits, code reviews for vulnerabilities, or pre-deployment security checks.
license: MIT
metadata:
  version: "1.2.0"
  supported_languages: ["php", "javascript", "typescript", "python", "csharp"]
---

# Security Audit Skill

Professional static code analysis and security auditing skill tailored for **PHP**, **JavaScript / TypeScript (Node.js)**, **Python**, and **C# (.NET)**.

## Directory Orchestration

This skill utilizes a modular directory structure to organize auditing resources:

- **`core/`**: Core auditing methodologies, data flow analysis techniques (`taint-analysis.md`), and anti-hallucination rules.
- **`frameworks/`**: Framework-specific security configurations and common pitfalls (`laravel.md`, `express-nextjs.md`, `django-fastapi.md`, `dotnet-asp.md`).
- **`checklists/`**: Language checklists and the D1-D10 security coverage matrix (`coverage-matrix.md`).
- **`languages/`**: Deep language security guides (`php.md`, `javascript.md`, `python.md`, `dotnet.md`).
- **`security/`**: In-depth explanations of security concepts (`business-logic.md`, `auth-oauth-jwt.md`, `graphql-realtime.md`, `supply-chain-infra.md`).
- **`cases/`**: Real-world vulnerability case studies and exploit analysis (`cases/real-world-vulns.md`).
- **`wooyun/`**: Historical vulnerability archives, bug bounty reports, and parameter priority statistics (`INDEX.md`, `bypass-techniques.md`).
- **`reporting/`**: Standardized vulnerability reporting templates (`reporting/report-template.md`).

## Audit Workflow

```text
1. Reconnaissance   → Map project tech stack, frameworks, routers, and entry points.
2. Vulnerability Hunt → Trace data flow from user inputs to dangerous sinks across D1-D10 dimensions. Consult `languages/` and `frameworks/`.
3. Verification    → Confirm exploitability, eliminate false positives, and assess severity.
4. Remediation     → Document findings using `reporting/report-template.md` with clear root cause, PoC impact, and secure code fixes.
```

---

## Language Specific Guides (`languages/`)

Query the target language guide when auditing matching files:

- **PHP & Laravel / WordPress**: [`languages/php.md`](languages/php.md)
- **JavaScript / Node.js / Express / Next.js**: [`languages/javascript.md`](languages/javascript.md)
- **Python / Django / FastAPI / Flask**: [`languages/python.md`](languages/python.md)
- **C# / .NET Core / ASP.NET**: [`languages/dotnet.md`](languages/dotnet.md)

---

## References & Inspiration

- **[3stoneBrother Code Audit Repository](https://github.com/3stoneBrother/code-audit)**: Source inspiration for multi-language security audit checklists, D1-D10 coverage matrix, taint analysis methodology, and WooYun real-world vulnerability insights.
