---
name: security-audit
description: Universal, language-agnostic defensive security audit skill. Orchestrates a 3-tier architecture (core methodologies, extensible threat models, evidence-based reporting) for static code analysis, closed-loop remediation, and anti-hallucination verification across any tech stack. Use when performing security audits, architectural code reviews, or pre-deployment security verification.
license: MIT
metadata:
  version: "2.0.0"
  architecture: "3-tier-modular"
  universal: true
---

# Security Audit Skill

A 100% universal, language-agnostic, and vendor-neutral defensive security principle engine. 

This skill transforms security code review from ad-hoc offensive guessing into an evidence-based engineering discipline: tracking untrusted taint across syntax trees, verifying control-flow reachability, enforcing domain invariants, proving defects with non-offensive native reproduction tests, applying architectural root patches, and honestly documenting verification boundaries.

---

## 1. Clean Three-Tier Modular Architecture

```text
.agents/skills/security-devops/security-audit/
├── SKILL.md                          # Master Orchestrator & Dynamic Router
├── core/                             # Universal Invariant Methodologies
│   ├── anti-hallucination.md         # Evidence-first rules, verified sinks, line numbers
│   ├── taint-analysis.md             # Universal Source -> Sanitizer -> Sink data flow
│   ├── ast-triage.md                 # Two-tier triage (Heuristic regex -> AST confirmation)
│   ├── closed-loop-remediation.md    # Native reproduction test -> Root patch -> Regression
│   └── negative-reporting.md         # Limits of static analysis, confidence tiers
├── threat-models/                    # Universal Invariants & Extension Hub
│   ├── README.md                     # Formal extension guide & threat model schema
│   ├── owasp-top-10.md               # Canonical OWASP Top 10 (2021) & API Security Top 10 (2023)
│   ├── d1-d10-matrix.md              # Universal baseline matrix (D1–D10)
│   ├── api-contracts.md              # OpenAPI/GraphQL contract drift & shadow endpoints
│   └── webhooks-and-event-integrity.md # HMAC, constant-time, replay & idempotency
└── reporting/                        # Evidence-Based Reporting
    └── report-template.md            # Standardized template with findings matrix
```

### Tier Descriptions:
1. **`core/` (Universal Invariant Methodologies)**: Foundational principles that never vary across programming languages, frameworks, or deployment environments.
2. **`threat-models/` (Universal Invariants & Extension Hub)**: Declarative, domain-specific threat surfaces and security invariants. Easily extended with new domains without touching core logic.
3. **`reporting/` (Evidence-Based Reporting)**: Standardized, actionable deliverables emphasizing closed-loop test harnesses, architectural patches, and honest confidence tiers.

---

## 2. The Dynamic Documentation Standard

Rather than maintaining fragile, static, bundled language and framework files that quickly become outdated, this skill mandates the **Dynamic Documentation Standard**:

> [!IMPORTANT]
> **Dynamic Manifest Inspection**:
> 1. The auditing agent inspects the target repository's dependency manifests (`package.json`, `Cargo.toml`, `pyproject.toml`, `composer.json`, `go.mod`, `pom.xml`, `.csproj`, etc.) to dynamically determine the exact language version, web framework, ORM, and cryptographic libraries in use.
> 2. The agent looks up language-specific sink signatures, API semantics, and framework configuration defaults dynamically using project context or web documentation, then applies the invariant principles defined in `core/` and `threat-models/`.

---

## 3. End-to-End Audit Workflow

```text
┌─────────────────────────────────────────────────────────────┐
│ 1. RECONNAISSANCE & MANIFEST INSPECTION                     │
│    • Identify tech stack via manifest files                 │
│    • Map routers, controllers, gateways, and trust zones    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. THREAT MODEL ROUTING & MAPPING                           │
│    • Load `threat-models/owasp-top-10.md` (canonical)       │
│    • Load `threat-models/d1-d10-matrix.md` (baseline)       │
│    • Load `threat-models/api-contracts.md` (if APIs/schemas)│
│    • Load `threat-models/webhooks-and-event-integrity.md`   │
│    • Load any custom models in `threat-models/`             │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. TWO-TIER AST TRIAGE                                      │
│    • Tier 1: Fast heuristic regex discovery (Candidate sinks)│
│    • Tier 2: Surgical AST confirmation (Eliminate literals) │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. TAINT ANALYSIS & CONTROL-FLOW REACHABILITY               │
│    • Trace Source -> Sanitizer -> Sink chain                │
│    • Verify router registration and branch conditions       │
│    • Apply strict `anti-hallucination.md` rules             │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. CLOSED-LOOP DEFENSIVE REMEDIATION                        │
│    • Write non-offensive reproduction test (RED)            │
│    • Implement architectural root patch at sink             │
│    • Run test suite to verify regression pass (GREEN)       │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. REPORTING & BOUNDARY DECLARATION                         │
│    • Categorize findings into standardized Confidence Tiers │
│    • Document unverified scope via `negative-reporting.md`  │
│    • Generate deliverable using `reporting/report-template` │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Threat Model Catalog & Routing Table

The dynamic router matches target codebase architecture against the appropriate threat models:

| Threat Model | Domain & Scope | Activation Condition | Key Invariants Enforced |
|---|---|---|---|
| [`owasp-top-10.md`](threat-models/owasp-top-10.md) | Canonical OWASP Top 10 (2021) & OWASP API Security Top 10 (2023) | **Always Active** for Web Applications, REST/GraphQL APIs, and Backend Services | Broken Access Control, BOLA, Injection, Insecure Design, SSRF, BFLA, Mass Assignment, Rate Limiting, Component Integrity. |
| [`d1-d10-matrix.md`](threat-models/d1-d10-matrix.md) | Universal baseline web & system security matrix (D1–D10) | **Always Active** as foundational baseline across any codebase | Comprehensive coverage spanning Injection, Auth, Access Control, Deserialization, Supply Chain, and Misconfigurations. |
| [`api-contracts.md`](threat-models/api-contracts.md) | Vendor-agnostic API contract integrity (OpenAPI, Swagger, GraphQL, gRPC) | Detected API schemas or controller routing suites | Schema drift prevention, shadow endpoints, undocumented parameters, type/length boundary enforcement. |
| [`webhooks-and-event-integrity.md`](threat-models/webhooks-and-event-integrity.md) | Asynchronous events, webhooks, and distributed messaging | Detected webhook routes, event handlers, or message queues | Raw body HMAC validation, constant-time comparison, replay mitigation (<300s), database idempotency tracking. |

---

## 5. Extending Threat Models

To add a new domain or architectural threat model (e.g., `smart-contracts.md`, `ai-agents.md`, `zero-trust.md`):

1. Navigate to [`threat-models/`](threat-models/).
2. Review [`threat-models/README.md`](threat-models/README.md) for the standardized 6-section schema.
3. Author your threat model file (e.g., `threat-models/ai-agents.md`).
4. The router automatically discovers and utilizes new models during the threat model selection phase. Zero core code modifications are required.

---

## 6. Confidence Tiers Quick Reference

Every documented finding must carry one of three explicit confidence labels:
- **`[VERIFIED STATIC FLAW]`**: Proven Source-to-Sink taint flow with verified dangerous sink and reachable control flow.
- **`[CONTRACT MISMATCH]`**: Discrepancy between interface/schema contracts and controller implementation (shadow endpoints, unconstrained fields, missing validation).
- **`[MANUAL REVIEW REQUIRED]`**: High-risk pattern traversing dynamic reflection, external microservices, or uninspected third-party libraries that cannot be mathematically proven statically.
