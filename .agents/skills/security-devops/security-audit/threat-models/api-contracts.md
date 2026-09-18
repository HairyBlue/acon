---
name: api-contracts
title: Vendor-Agnostic API Contract Integrity & Drift Audit
version: 1.0.0
domain: api-security
criticality: High
---

# Vendor-Agnostic API Contract Integrity & Drift Audit

In modern distributed systems, API specifications (OpenAPI, Swagger, JSON Schema, GraphQL schemas, gRPC Protobuf definitions) define the authoritative trust contract between clients, gateways, and backend services. 

Security vulnerabilities frequently emerge from **Contract Drift**: discrepancies between what the formal contract declares and what the underlying controller or resolver actually executes.

---

## 1. Scope & Domain Invariants

- **The Contract Authority Invariant**: Every incoming request payload, parameter, and header must be strictly validated against the authoritative contract schema before passing into domain business logic.
- **The Zero-Shadow Invariant**: No endpoint or route handler may be accessible in production without corresponding representation and authorization policy in the documented API catalog.
- **The Closed-Schema Invariant**: Payloads must strictly disallow unspecified fields (`additionalProperties: false`), preventing mass assignment, prototype pollution, and property injection.

---

## 2. Threat Vectors & Attack Surfaces

```text
                     API CONTRACT (OpenAPI / GraphQL Schema)
                                     │
                 ┌───────────────────┴───────────────────┐
                 ▼                                       ▼
       [ CONTRACT DRIFT ]                     [ MISSING BOUNDS ]
  • Shadow Endpoints                     • Unbounded String Lengths (DoS)
  • Undocumented Parameters              • Unbounded Arrays / Allocations
  • Permissive Additional Properties     • Missing Regex / Format Enforcers
                 │                                       │
                 └───────────────────┬───────────────────┘
                                     ▼
                   [ CONTROLLER IMPLEMENTATION REALITY ]
                     • Mass Assignment / Field Tampering
                     • Unchecked Type Coercion
                     • Resource Exhaustion
```

### Key Attack Vectors:
1. **Shadow & Zombie Endpoints**: Legacy or undocumented routes left active in routing tables that bypass gateway-level authentication, rate limiting, or logging policies.
2. **Undocumented Parameters (Mass Assignment)**: Controllers extracting the entire request body (`req.body`, `$request->all()`) into ORM update methods, allowing attackers to overwrite administrative fields (e.g., `role`, `is_admin`, `verified`).
3. **Missing Type & Length Bounds**: Fields declared as generic `type: string` or `type: array` without `maxLength`, `pattern`, or `maxItems`, leading to memory exhaustion or denial of service when supplied with megabyte-scale payloads.
4. **GraphQL Over-Fetching & Circular Complexity**: Unbounded nested queries or missing query depth limits that allow recursive relationship queries to consume all database connections.

---

## 3. Invariant Sinks & Source Boundaries

| Element | Contract Invariant | Vulnerable Implementation Pattern |
|---|---|---|
| **Route Registration** | Every controller route matches a documented OpenAPI/GraphQL operation. | Router mounts `/api/v1/internal/reset` or `/debug/state` not defined in published API specifications. |
| **Object Update Sink** | Only explicitly whitelisted attributes are accepted for entity mutation. | `User.update(req.body)` or `user.fill(request.all())` accepting unconstrained input. |
| **String / Text Input** | Explicit length constraints (`maxLength`) and format checks. | Accepting unbounded strings into database text columns or memory buffers without length checking. |
| **Numeric Bounds** | Explicit minimum, maximum, and integer boundaries. | Passing unvalidated numeric strings directly into pagination limits (`limit`, `offset`) or financial amounts. |
| **Enum Enforcement** | Allowed values must strictly match defined set. | Relying on client to send valid statuses; backend defaults to insecure branch on unknown value. |

---

## 4. Two-Tier Audit Procedure

### Tier 1: Fast Heuristic Discovery (Regex / Scanning)
1. **Extract Declared Routes**: Parse `openapi.yaml`, `swagger.json`, `schema.graphql`, or gRPC `.proto` files to build the set of documented endpoints and accepted fields.
2. **Extract Implemented Routes**: Scan codebase router files (`routes/`, `controllers/`, `@Controller`, `@Get`, `@Post`, `app.use()`).
3. **Scan for Blanket Object Assignments**: Grep for patterns like `.update(req.body)`, `.assign(entity, data)`, `repo.save(request.data)`.
4. **Identify Unbounded Array / String Inputs**: Check schema definitions for properties with `type: string` lacking `maxLength` or `type: array` lacking `maxItems`.

### Tier 2: AST & Structural Confirmation
1. **Route Diffing**: Compare the set of implemented route endpoints against declared contract paths. Flag any implemented route missing from the schema as a `[CONTRACT MISMATCH]`.
2. **Parameter Whitelist Check**: For each controller mutation handler, inspect the AST to verify whether request data is destructured via an explicit DTO or schema validator:
   - *Safe*: `const { name, bio } = req.body;` or `const validated = schema.parse(req.body);`
   - *Vulnerable*: Direct pass-through of raw body dictionary into persistence layer.
3. **Runtime Middleware Verification**: Check if schema validation middleware (e.g., OpenAPI validator, Zod/Joi validation pipe) is registered in the request lifecycle prior to controller execution.

---

## 5. Defensive Remediation & Invariant Enforcement

### 1. Enforce Strict Schemas with `additionalProperties: false`
In OpenAPI / JSON Schema, explicitly forbid unknown properties:
```yaml
UserUpdateRequest:
  type: object
  additionalProperties: false
  required:
    - displayName
  properties:
    displayName:
      type: string
      minLength: 1
      maxLength: 50
      pattern: '^[a-zA-Z0-9_\-\s]+$'
```

### 2. Mandatory Data Transfer Objects (DTOs)
Never pass raw request bodies directly to persistence models. Use explicit, strongly typed DTOs:
```typescript
// Safe DTO pattern
export class UpdateProfileDto {
  @IsString()
  @Length(1, 50)
  @Matches(/^[a-zA-Z0-9_\-\s]+$/)
  displayName!: string;

  // Unlisted fields like 'role' or 'isSuperAdmin' are stripped at the boundary
}
```

### 3. Gateway / Framework Schema Enforcement
Configure API gateway or routing middleware to automatically reject requests with a `400 Bad Request` before they reach the controller if they violate the schema.

---

## 6. Closed-Loop Test Verification Criteria

Reproduction tests must assert contract boundary adherence using standard test fixtures:

1. **Mass Assignment Boundary Test**:
   - Send payload containing both a valid field (`displayName: "New Name"`) and an unauthorized field (`role: "admin"`).
   - Assert response status is `400 Bad Request` or assert that the persisted entity's `role` property remains unchanged.
2. **Length Boundary Test**:
   - Send a string field exceeding declared `maxLength` (e.g., 51 characters when limit is 50).
   - Assert request is rejected deterministically with validation error.
3. **Shadow Endpoint Verification**:
   - Assert test suite includes an automated check comparing router table outputs with API schema documents, failing build if undocumented routes exist.
