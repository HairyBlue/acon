# Universal Taint Analysis & Control-Flow Reachability

Taint analysis is the formal, language-agnostic methodology for tracking the propagation of untrusted data from entry boundaries (Sources) through internal transformations (Propagators & Sanitizers) to security-critical execution points (Sinks). 

A static vulnerability requires two concurrent conditions:
1. **Data-Flow Taint Propagation**: Untrusted data reaches a dangerous sink without neutralizing sanitization.
2. **Control-Flow Reachability**: The execution path containing the taint flow is reachable under real runtime conditions (not dead code, guarded by failing preconditions, or shielded by early aborts).

---

## 1. The Universal Triad Model

```text
┌────────────────┐       ┌────────────────────────┐       ┌─────────────────┐
│     SOURCE     │ ───►  │ SANITIZER / TRANSFORM  │ ───►  │      SINK       │
│ Untrusted Data │       │   Validation / Escaping│       │ Sensitive Exec  │
└────────────────┘       └────────────────────────┘       └─────────────────┘
                                     │
                             (Sanitizer Absent
                              or Ineffective)
                                     │
                                     ▼
                          ┌───────────────────────┐
                          │   VULNERABILITY PATH  │
                          │ Statically Confirmed  │
                          └───────────────────────┘
```

---

## 2. Universal Source Taxonomy

Sources represent any interface boundary where data crossing trust zones enters the application context.

| Source Category | Invariant Boundary | Manifestations Across Stacks |
|---|---|---|
| **HTTP / Transport Requests** | Untrusted client network payload | Request URL path, query parameters, body payloads (JSON/XML/form-data), HTTP headers (`Cookie`, `User-Agent`, `Authorization`, `X-Forwarded-*`). |
| **RPC / IPC / Message Queues** | Untrusted external service messages | gRPC method arguments, RabbitMQ / Kafka message payloads, Redis pub/sub messages, WebSocket frame data. |
| **Persistent Storage (Second-Order)** | Previously stored external inputs | Database query results containing user-submitted content, cache values, file read contents from shared directories. |
| **Filesystem / Uploads** | External file contents and metadata | Uploaded file bytes, client-supplied file names, MIME type headers, archive entry paths (`tar`, `zip`). |
| **Environment & Configuration** | Shared host or container state | Environment variables modifiable in shared tenancy, unverified CLI arguments, dynamic config files. |

---

## 3. Sanitizers & Safe Transformers

A sanitizer neutralizes taint only if it is mathematically or semantically guaranteed to eliminate the specific hazard of the downstream sink.

### Effective Sanitizer Classes:
1. **Type Coercion & Narrowing**:
   - Forcing untrusted strings into bounded primitive types (e.g., parsing integers, floats, booleans, or matching strict enums).
   - *Example*: Parsing `id` as an integer ensures it cannot carry SQL injection or path traversal payloads.
2. **Strict Whitelisting / Allowlisting**:
   - Matching input against an explicit set of known safe values.
   - *Example*: Checking sort order parameter against `["asc", "desc"]` only.
3. **Structured Schema Validation**:
   - Validating shape, type, length, regex pattern, and disallowing extra properties via declarative schemas before passing to domain logic.
4. **Structural Decoupling / Parameter Binding**:
   - Separating code from data by passing input through driver-level parameters rather than string concatenation.
   - *Example*: Prepared statements with parameter placeholders, structured CLI argument arrays (e.g. `execFile(['prog', arg])`).
5. **Canonicalization Before Check**:
   - Resolving paths (`realpath`), Unicode normalization, and URL decoding *prior* to boundary checks, preventing double-encoding and traversal bypasses.

> [!WARNING]
> **Blacklists & Naive Filtering**: Replacing single quotes or removing `../` substrings iteratively without recursion is **NOT** an effective sanitizer. Such patterns fail taint clearance.

---

## 4. Universal Sink Taxonomy

Sinks are operations where executing untrusted data causes security violations.

| Sink Category | Risk Invariant | Unsafe Operational Pattern | Safe Alternative |
|---|---|---|---|
| **Command / Shell Execution** | Untrusted input passed to OS command interpreter | Passing input to subshells or concatenating strings into shell commands. | Pass arguments as isolated array elements to process execution without subshell. |
| **Code Evaluation** | Dynamic interpretation of application code | Dynamically evaluating strings, regex replacement code modifiers, or dynamic symbol lookup. | Use static lookup maps, strict dispatch tables, or pure data configuration. |
| **Query / Persistence** | Dynamic query structure manipulation | String concatenation or template interpolation into database query strings. | Parameterized queries, prepared statements, type-safe ORM query builders. |
| **Client Rendering / Markup** | Unescaped injection into DOM/HTML contexts | Rendering raw untrusted HTML, unescaped template variables, or unsafe DOM insertion. | Context-aware HTML escaping, native text nodes, strict Content Security Policy. |
| **Filesystem Pathing** | Arbitrary read, write, or inclusion of files | Concatenating untrusted filenames into file paths without canonicalization against base directory. | Resolve canonical path (`realpath`) and verify base directory prefix boundary. |
| **Object Deserialization** | Execution during object reconstitution | Passing untrusted byte streams or text to polymorphic native object deserializers. | Use language-neutral data formats (strict JSON) with explicit validation. |
| **Outbound Network (SSRF)** | Arbitrary destination request issuance | Fetching URLs supplied by client without protocol, port, and IP range validation. | Whitelist domains, resolve DNS, and block private/loopback/link-local IP addresses. |

---

## 5. Control-Flow Reachability Verification

A taint flow from Source to Sink is only a confirmed flaw if the path is reachable:

### Reachability Checks:
1. **Route & Entrypoint Accessibility**:
   - Is the entrypoint registered in the application router?
   - Is it exposed to the relevant trust level (public unauthenticated vs. authenticated administrator)?
2. **Branch Guard Evaluation**:
   - Are there preceding `if/else` guards, guard clauses, or validation statements that throw exceptions or return early if input violates constraints?
3. **Dead Code Elimination**:
   - Is the sink located in an uncalled private method, deprecated module not mounted in the application lifecycle, or disabled feature flag?
4. **Exception Handling Boundaries**:
   - Does an intermediate operation fail and redirect flow into an abort handler before reaching the sink?

---

## 6. Systematic Tracing Protocol

```text
Step 1: Locate candidate Sink in target code.
Step 2: Trace backwards through assignments, function arguments, and return values.
Step 3: Check each node in the path for an effective Sanitizer:
        - If an effective sanitizer is present, mark TAINT_CLEARED.
        - If no sanitizer is present, continue backwards.
Step 4: Reach Source boundary:
        - If Source is untrusted, mark TAINT_PRESENT.
Step 5: Verify Control-Flow Reachability from route entrypoint to Sink:
        - If reachable without blocking preconditions, confirm [VERIFIED STATIC FLAW].
        - If reachability depends on unprovable external runtime state, mark [MANUAL REVIEW REQUIRED].
```
