---
name: d1-d10-matrix
title: Universal D1-D10 Security Matrix
version: 2.0.0
domain: web-and-systems
criticality: Critical
---

# Universal D1–D10 Security Matrix

The D1–D10 Security Matrix establishes the universal baseline of software security invariants across modern application architectures. Each dimension represents a critical failure mode where untrusted input or unvalidated state violates core software guarantees.

---

## Dimension Summary Table

| Dimension | Invariant Focus | Primary Failure Mode | Criticality |
|---|---|---|---|
| **D1: Injection** | Strict separation of code and data | Untrusted input altering query or interpreter syntax | **Critical** |
| **D2: Broken Authentication** | Unforgeable, verified principal identity | Session fixation, weak hashing, invalid token verification | **Critical** |
| **D3: Sensitive Data Exposure** | Confidentiality of secrets and PII | Plaintext storage, credential leakage in logs or code | **High** |
| **D4: XML / Parser Flaws** | Safe document and object parsing | XXE entity expansion, prototype/schema pollution | **High** |
| **D5: Broken Access Control / IDOR** | Explicit authorization on every data read/write | Missing tenant/user ownership validation on object IDs | **Critical** |
| **D6: Security Misconfiguration** | Hardened, minimal attack surface | Exposed debug tooling, wildcard CORS, default credentials | **High** |
| **D7: XSS & Client Injection** | Context-aware encoding of client outputs | Rendering raw untrusted input in HTML/DOM contexts | **High** |
| **D8: Insecure Deserialization** | Explicit, schema-validated data exchange | Polymorphic instantiation of untrusted byte streams | **Critical** |
| **D9: Supply Chain & Dependencies** | Known provenance and vulnerability-free tree | Vulnerable lockfile packages, unpinned dependencies | **Medium** |
| **D10: Logging & Audit Integrity** | Tamper-evident, non-sensitive audit trail | Unlogged security events, log forging/injection | **Medium** |

---

## Detailed Dimension Invariants & Triage

### D1: Injection (SQL, NoSQL, Command, SSTI, Code Eval)
- **Universal Invariant**: Code and data must remain strictly decoupled. Interpreters must receive invariant program syntax, with variable data supplied strictly out-of-band.
- **Entry Sources**: URL query parameters, request bodies, HTTP headers, RPC payloads.
- **Dangerous Sinks**: `db.raw()`, `db.query("${var}")`, `child_process.exec()`, `system()`, `eval()`, `render_template_string()`.
- **Two-Tier Triage**:
  - *Tier 1*: Search for raw query methods, shell spawners, or template string interpolations in query locations.
  - *Tier 2*: Verify via AST whether arguments are string literals/tuples (safe) or concatenated/interpolated expressions (vulnerable).
- **Remediation**: Use parameterized queries, prepared statements, ORM abstractions, and array-based process execution (`execFile(['cmd', arg])`).
- **Defensive Test**: Pass inputs containing literal quote boundaries (e.g. `user'name`) and assert query execution completes without syntax errors.

---

### D2: Broken Authentication
- **Universal Invariant**: Proof of identity must be mathematically verifiable, unforgeable, time-bound, and securely stored.
- **Entry Sources**: Login routes, token refresh endpoints, password reset flows.
- **Dangerous Sinks**: Insecure password hashing (MD5, SHA1, plaintext), unverified JWT signatures (accepting `alg: none` or skipping signature checks), lack of session regeneration post-authentication.
- **Two-Tier Triage**:
  - *Tier 1*: Grep for hash algorithms (`md5`, `sha1`), JWT decoding calls without verify options, and session creation.
  - *Tier 2*: Verify AST options passed to JWT verify methods (`algorithms` whitelist enforced) and password hashing library usage (Argon2id, bcrypt with sufficient cost).
- **Remediation**: Use standard cryptographic password hashing algorithms (bcrypt/Argon2id); enforce strict algorithm whitelisting and signature verification on all tokens; regenerate session identifiers upon privilege level change.
- **Defensive Test**: Present a token with `alg: "none"` or mismatched signature and assert `401 Unauthorized`.

---

### D3: Sensitive Data Exposure
- **Universal Invariant**: Secrets, cryptographic keys, and PII must never exist in plaintext in persistent code, VCS history, unencrypted storage, or operational logs.
- **Entry Sources**: Configuration files, environment loading logic, error logging hooks.
- **Dangerous Sinks**: Hardcoded API keys, logging full request payloads containing passwords/tokens, returning sensitive database columns (`password_hash`, `ssn`) in API serialization.
- **Two-Tier Triage**:
  - *Tier 1*: Scan for entropy spikes, string literals matching API key prefixes (`sk_live_`, `ghp_`, `AKIA...`), and logger calls referencing `req.body`.
  - *Tier 2*: Check variable assignments against environment loaders and verify ORM model serialization hides private fields (e.g., `hidden = ['password']`).
- **Remediation**: Store secrets in external vault or environment variables; use DTOs/serializers that explicitly whitelist public fields; apply automated log redaction filters.
- **Defensive Test**: Invoke user serialization endpoint and assert returned JSON schema does not contain sensitive attributes.

---

### D4: XML / External Entity & Parser Flaws
- **Universal Invariant**: Parsers must restrict document structures to data-only trees, explicitly disabling entity expansion, external DTD retrieval, and prototype mutation.
- **Entry Sources**: XML file uploads, SAML payloads, SOAP endpoints, untrusted JSON merge objects.
- **Dangerous Sinks**: XML parsers configured without disabling external entities (`resolveExternals: false`, `disallow-doctype-decl`), deep recursive object merge utilities without prototype protection.
- **Two-Tier Triage**:
  - *Tier 1*: Grep for XML parser initialization, `DOMParser`, `xml2js`, and deep-merge / recursive assign calls.
  - *Tier 2*: Check AST options for DTD/entity flags; inspect merge functions for `__proto__` and `constructor` property guards.
- **Remediation**: Disable DTD processing and external entity resolution in XML parsers; use `Object.create(null)` or freeze prototypes to prevent pollution.
- **Defensive Test**: Provide an XML snippet containing a local DTD declaration and assert parser rejects DTDs without resolving external entities.

---

### D5: Broken Access Control / IDOR
- **Universal Invariant**: Every operation on a resource must verify that the requesting principal possesses authorized ownership or permission for that specific resource instance.
- **Entry Sources**: URL path IDs (`/orders/:id`), request body foreign keys (`tenant_id`, `account_id`).
- **Dangerous Sinks**: Direct database lookups using only client-supplied primary keys (e.g., `Order.findById(req.params.id)`) without scoping by the authenticated user's ID (`where user_id = auth.user.id`).
- **Two-Tier Triage**:
  - *Tier 1*: Find route handlers taking entity IDs and trace to ORM retrieval calls.
  - *Tier 2*: Check if retrieval query includes an authorization scope predicate or if route is wrapped in an authorization policy/guard.
- **Remediation**: Scope all tenant/user queries by the authenticated session identity; enforce policy-based access control (ABAC/RBAC) before executing business logic.
- **Defensive Test**: Issue a request under User $B$'s authenticated session requesting a resource created by User $A$; assert `403 Forbidden` or `404 Not Found`.

---

### D6: Security Misconfiguration
- **Universal Invariant**: Systems must run in a least-privilege, fully hardened operational state, with diagnostic interfaces disabled in non-development environments.
- **Entry Sources**: Framework configuration files, environment definitions, CORS middleware setups.
- **Dangerous Sinks**: Enabling debug modes in production (`DEBUG=True`, `APP_DEBUG=true`), CORS configurations reflecting untrusted origins with credentials (`Access-Control-Allow-Origin: *` with credentials), missing security headers (`Content-Security-Policy`, `X-Content-Type-Options`).
- **Two-Tier Triage**:
  - *Tier 1*: Search configuration files for debug flags, CORS wildcards, and cookie security flags.
  - *Tier 2*: Verify whether debug flags are conditionally bound to environment variables and whether cookies enforce `Secure`, `HttpOnly`, and `SameSite`.
- **Remediation**: Set default configurations to secure-by-default; disable debug tooling when `NODE_ENV === 'production'`; restrict CORS to explicit origin allowlists.
- **Defensive Test**: Query an API endpoint with an arbitrary `Origin` header and verify response does not echo the origin alongside `Access-Control-Allow-Credentials: true`.

---

### D7: XSS & Client-Side Injection
- **Universal Invariant**: Client-rendered outputs must be contextually encoded or bound to text-only DOM nodes to prevent untrusted data from executing as markup or script.
- **Entry Sources**: User profile fields, comments, search query reflections, URL parameters.
- **Dangerous Sinks**: `dangerouslySetInnerHTML`, `v-html`, unescaped template expressions (`{{{ var }}}`, `<%- var %>`), `document.write()`, `element.innerHTML`.
- **Two-Tier Triage**:
  - *Tier 1*: Search for unsafe HTML rendering attributes and unescaped template delimiters across template and UI files.
  - *Tier 2*: Verify via AST whether the data bound to these sinks is a hardcoded constant string or dynamic user-controlled state.
- **Remediation**: Rely on framework default auto-escaping; use DOM `textContent` instead of `innerHTML`; apply a strict Content Security Policy (CSP).
- **Defensive Test**: Pass boundary characters `<b>"text"</b>` into user input and verify the rendered DOM output contains escaped HTML entities (`&lt;b&gt;`).

---

### D8: Insecure Deserialization
- **Universal Invariant**: Untrusted data must be parsed into inert data structures (such as plain objects or primitives) rather than reconstituted into polymorphic live objects with executable bindings.
- **Entry Sources**: Binary request payloads, base64-encoded cookie state, serialized session stores.
- **Dangerous Sinks**: `unserialize()`, `pickle.loads()`, `yaml.load()` (without SafeLoader), `BinaryFormatter.Deserialize()`.
- **Two-Tier Triage**:
  - *Tier 1*: Grep for native deserialization function calls across the codebase.
  - *Tier 2*: Confirm whether the argument originates from external network or storage boundaries, and whether safe schema-based alternatives are available.
- **Remediation**: Migrate to inert serialization formats (JSON, Protocol Buffers); if object serialization is mandatory, require cryptographic HMAC signing and strict class allowlists.
- **Defensive Test**: Provide an invalid or schema-mismatched serialized string and assert the parser safely rejects the payload without instantiating arbitrary classes.

---

### D9: Known Vulnerable Components & Supply Chain
- **Universal Invariant**: Third-party dependencies must be pinned, tracked via deterministic lockfiles, and free of known vulnerabilities (CVEs).
- **Entry Sources**: Manifest files (`package.json`, `Cargo.toml`, `requirements.txt`, `composer.json`, `.csproj`, `go.mod`).
- **Dangerous Sinks**: Unpinned wildcard versions (`*`, `^latest`), dependencies with known high/critical CVE advisories, unverified package sources.
- **Two-Tier Triage**:
  - *Tier 1*: Inspect lockfiles for package versions against national vulnerability databases and security advisories.
  - *Tier 2*: Check whether vulnerable package functions are actually imported and invoked in reachable application code.
- **Remediation**: Upgrade affected packages to patched versions; enable automated vulnerability scanning in CI/CD pipelines (e.g. `audit`, Dependabot); pin exact versions in production lockfiles.
- **Defensive Test**: Run native package manager security audit (`npm audit`, `cargo audit`, `composer audit`) and assert zero critical or high vulnerabilities.

---

### D10: Insufficient Logging & Monitoring
- **Universal Invariant**: Security-relevant events (authentication failures, authorization rejections, critical state changes) must produce structured, tamper-evident audit logs without recording sensitive data or permitting log injection.
- **Entry Sources**: Authentication handlers, role change endpoints, payment and transactional workflows.
- **Dangerous Sinks**: Catch blocks that swallow exceptions silently without logging, unescaped user input written directly to text log files (log injection / forging), missing audit logs on privileged admin actions.
- **Two-Tier Triage**:
  - *Tier 1*: Scan catch blocks and authorization failure branches for empty handlers or missing logging statements.
  - *Tier 2*: Verify that loggers output structured JSON formats (preventing CRLF log splitting) and that sensitive parameters are masked.
- **Remediation**: Implement structured JSON logging; record principal ID, timestamp, action, and outcome for all security events; sanitize newline characters from any log entries containing user input.
- **Defensive Test**: Simulate a failed login attempt and assert that an audit record with timestamp and failure status is emitted to the logging stream.
