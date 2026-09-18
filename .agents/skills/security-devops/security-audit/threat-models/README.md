# Threat Models Hub & Extension Guide

The `threat-models/` directory serves as the extensible, domain-specific rule repository for the `security-audit` skill. While the `core/` directory provides universal invariant auditing methodologies (taint analysis, AST triage, closed-loop remediation, anti-hallucination), `threat-models/` defines the specific threat surfaces, invariants, and failure modes across modern application architectures.

---

## 1. Bundled Threat Models

The skill includes the following core threat models out of the box:

| Threat Model File | Scope & Domain Focus | Key Invariants Enforced |
|---|---|---|
| [`owasp-top-10.md`](owasp-top-10.md) | Canonical OWASP Top 10 (2021) & OWASP API Security Top 10 (2023) | Universal invariants, two-tier AST triage, remediation patterns, and reproduction tests across all 20 OWASP web & API categories. |
| [`d1-d10-matrix.md`](d1-d10-matrix.md) | Universal baseline web & system security matrix (D1–D10) | Comprehensive coverage spanning Injection, Auth, Access Control, Deserialization, Supply Chain, and Misconfigurations. |
| [`api-contracts.md`](api-contracts.md) | Vendor-agnostic API contract integrity (REST, OpenAPI, Swagger, GraphQL) | Schema drift prevention, shadow endpoints, undocumented parameter discovery, type/length boundary enforcement. |
| [`webhooks-and-event-integrity.md`](webhooks-and-event-integrity.md) | Asynchronous events, webhooks, and distributed messaging | Raw body HMAC validation, constant-time comparison, replay mitigation, database idempotency tracking. |

---

## 2. Standardized Threat Model Schema

All new threat models dropped into this directory **MUST** conform to the following 6-part standardized schema:

```markdown
---
name: <kebab-case-name>
title: <Human-Readable Title>
version: <semantic-version>
domain: <e.g., smart-contracts, ai-agents, cloud-native, zero-trust>
criticality: <Critical | High | Medium>
---

# <Title>

## 1. Scope & Domain Invariants
- Define the boundaries of this threat model.
- Detail the immutable security invariants that must never be violated.

## 2. Threat Vectors & Attack Surfaces
- Catalog the distinct attack vectors specific to this domain.
- Map the trust boundaries crossed by external actors or automated systems.

## 3. Invariant Sinks & Source Boundaries
- Identify the domain-specific entry points (Sources).
- Define the critical execution, state transition, or persistence sinks.

## 4. Two-Tier Audit Procedure
- **Tier 1 (Fast Discovery)**: Heuristic regex and search patterns to scan for candidate locations.
- **Tier 2 (AST / Structural Verification)**: Exact AST, type, and control-flow checks to eliminate false positives.

## 5. Defensive Remediation & Invariant Enforcement
- Prescribe architectural mitigations (no fragile blacklists).
- Structural patterns, schema constraints, or cryptographic guarantees.

## 6. Closed-Loop Test Verification Criteria
- Native test harness specifications for reproducing and verifying fixes without offensive payloads.
- State assertions and boundary inputs.
```

---

## 3. How to Author & Drop in a New Threat Model

The architecture of `security-audit` is designed for zero-friction extensibility. To add support for a new domain (for example, `ai-agents.md` or `smart-contracts.md`):

### Step 1: Create the Threat Model File
Create a new markdown file directly in `threat-models/`:
```bash
touch .agents/skills/security-devops/security-audit/threat-models/ai-agents.md
```

### Step 2: Implement the Standardized Schema
Fill out all 6 sections defined in the schema above. Ensure that:
- Sources, Sanitizers, and Sinks are clearly defined.
- Both Tier 1 (heuristics) and Tier 2 (syntax/AST) triage criteria are documented.
- Remediation relies on structural architecture, not superficial regex filters.
- Test verification uses non-offensive boundary inputs.

### Step 3: Zero-Touch Registration
Because `SKILL.md` acts as a dynamic router over `threat-models/`, **no code modifications to `core/` or the skill orchestrator are required**. The auditing agent will automatically detect and apply the new threat model when project reconnaissance indicates matching technologies or domain requirements.

---

## 4. Extension Examples for Future Expansion

- **`smart-contracts.md`**: Reentrancy locks, integer arithmetic bounds, flash loan invariants, access-controlled state transitions, and EVM gas griefing.
- **`ai-agents.md`**: Prompt injection delimiters, tool-call execution sandboxing, untrusted context boundary separation, indirect prompt injection taint tracing, and output schema adherence.
- **`zero-trust-microservices.md`**: Mutual TLS (mTLS) enforcement, SPIFFE/SPIRE workload identities, internal token forward degradation, and cross-cluster egress restrictions.
- **`mobile-clients.md`**: Keychain/Keystore cryptographic storage, SSL certificate pinning, root/jailbreak detection integrity, and IPC intent filter boundaries.
