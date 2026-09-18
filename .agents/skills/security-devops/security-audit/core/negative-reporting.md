# Negative Reporting & Verification Boundaries

A security audit is only as credible as its honesty about what it *cannot* prove. Static code analysis operates within strict mathematical and practical boundaries: it cannot execute code, inspect runtime memory, evaluate real network topology, or resolve arbitrary dynamic dispatch.

**Negative Reporting** is the discipline of explicitly declaring unverified areas, documenting static analysis limitations, and categorizing findings into unambiguous confidence tiers to eliminate false senses of security.

---

## 1. The Standardized Confidence Tiers

Every finding documented in an audit report must be explicitly tagged with one of three confidence tiers:

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                       STANDARDIZED CONFIDENCE TIERS                     │
├──────────────────────────┬──────────────────────────┬───────────────────┤
│  [VERIFIED STATIC FLAW]  │   [CONTRACT MISMATCH]    │  [MANUAL REVIEW]  │
│  Unbroken Taint & Sink   │  Interface vs Code Drift │  Unprovable Path  │
│  Reachable Control Flow  │  Missing Bounds / Schema │  Dynamic Dispatch │
└──────────────────────────┴──────────────────────────┴───────────────────┘
```

### Tier 1: `[VERIFIED STATIC FLAW]`
- **Definition**: A deterministic vulnerability where the complete Source $\rightarrow$ Sanitizer $\rightarrow$ Sink data flow is visible, control flow is provably reachable, and the dangerous sink operation is verified via AST analysis.
- **Criteria**:
  - Exact file path and line numbers for Source and Sink.
  - Absence of neutralizing sanitization or validation.
  - Reachable entry point (e.g., registered router endpoint).
- **Remediation**: Immediate architectural patch backed by a closed-loop reproduction test.

### Tier 2: `[CONTRACT MISMATCH]`
- **Definition**: A structural discrepancy between declared interface specifications (OpenAPI/Swagger schemas, GraphQL type definitions, TypeScript interfaces, configuration contracts) and the actual implementation logic.
- **Criteria**:
  - Schemas declaring fields as constrained or non-nullable, but controllers permitting arbitrary payloads.
  - Endpoints exposing undocumented parameters (shadow parameters / mass assignment vectors).
  - Client contracts that lack runtime validation middleware.
- **Remediation**: Synchronize contract and runtime enforcement, adding strict schema validation at entry boundaries.

### Tier 3: `[MANUAL REVIEW REQUIRED]`
- **Definition**: A high-risk structural pattern or suspicious data flow that cannot be definitively proven or disproven via static analysis alone.
- **Criteria**:
  - The flow passes through dynamic reflection, dynamic imports, or third-party binary libraries.
  - Sanitization depends on external microservices or uninspected database stored procedures.
  - Reachability is conditional on external infrastructure configuration (e.g., API gateway authorization headers, WAF rewrites, cloud IAM roles).
- **Action**: Provide clear, specific verification instructions for dynamic testing or human code inspection.

---

## 2. Inherent Limits of Static Verification

The auditor must never guarantee that a codebase is "100% secure" or that "no vulnerabilities exist." The following vectors are statically unprovable and must be recorded in the Unverified Scope section:

| Unprovable Domain | Why Static Analysis Cannot Prove It |
|---|---|
| **Runtime Environment & Secrets** | Production environment variables, key management services (KMS), secret rotation policies, and container configurations cannot be confirmed from static source alone. |
| **Network & Perimeter Defenses** | Cloud firewalls, ingress controllers, WAF rules, and VPC network isolation policies operate out-of-band from the application source code. |
| **Dynamic Dispatch & Reflection** | Dynamic method invocation (`call_user_func`, `eval()`, Java/C# reflection, dynamic `import()`) hides execution targets from static syntax trees. |
| **Third-Party Upstream Integrity** | While dependency manifests list versions, the internal behavior and security of compiled or uninspected third-party packages are beyond the local audit boundary. |
| **Race Conditions & Concurrency** | High-concurrency interleaving, distributed locks, database transaction isolation anomalies (dirty reads, phantom reads) require runtime load simulation. |

---

## 3. Negative Findings Section Protocol

Every security report produced by this skill must include an **Unverified Scope & Negative Findings** section structured as follows:

```markdown
## Unverified Scope & Negative Findings

### 1. Statically Unverifiable Vectors
- **Dynamic Configuration**: The JWT signing algorithm is configured via `process.env.JWT_ALG`. Statically, the fallback is `HS256`, but production environments could supply insecure values.
- **External RPC Services**: The user authorization check delegates to `auth-service.internal/verify`. The internal implementation of this service was not part of the audit scope.

### 2. Files & Directories Excluded from Scope
- `vendor/` or `node_modules/` (third-party dependencies audited solely via lockfile manifest analysis, not deep source inspection).
- `tests/` and `fixtures/` (test harness files excluded from taint sink analysis).
- `build/` and compiled artifacts.

### 3. Areas Flagged for Dynamic / Penetration Testing
- **Rate Limiting & Brute Force**: Login route `POST /api/v1/auth/login` does not show application-level rate limiting. If rate limiting is not enforced at the ingress/API gateway layer, it is susceptible to brute force.
- **Replay Window Tolerance**: Webhook signature timestamp validation was observed, but clock skew tolerances between upstream webhooks and the host server must be verified in staging.
```

---

## 4. Auditor Rules of Engagement

1. **Never Mark "Safe" Without Proof**: If you cannot trace a path, do not mark it safe. Mark it as `[MANUAL REVIEW REQUIRED]`.
2. **State Specific Conditions**: When reporting an unverified risk, state the exact hypothesis and condition needed to prove it (e.g., "If `config.enable_debug` is true in production, endpoint `/debug/pprof` exposes runtime memory").
3. **Protect Auditor Trust**: False negatives are dangerous; false positives erode developer trust. Clear confidence tiers preserve integrity and prioritize remediation effort effectively.
