---
name: owasp-top-10
title: Canonical OWASP Top 10 (2021) & OWASP API Security Top 10 (2023) Threat Model
version: 1.0.0
domain: web-and-api-security
criticality: Critical
---

# Canonical OWASP Top 10 & OWASP API Top 10 Threat Model

This threat model establishes the canonical reference standard for defensive security auditing across modern web applications and distributed API services. It unifies the **OWASP Web Application Security Top 10 (2021)** and the **OWASP API Security Top 10 (2023)** into an actionable, language-agnostic engineering framework.

Rather than treating vulnerabilities as disparate bugs, this model enforces universal architectural invariants, surgical two-tier Abstract Syntax Tree (AST) triage, non-offensive defensive unit test reproduction, and structural remediation patterns.

---

## 1. Scope & Domain Invariants

The scope of this threat model spans the entire HTTP/RPC request-response lifecycle, inter-service communication, background queues, and third-party integrations across web backends and API architectures.

### Unified Master Invariants Matrix

| Category ID | Standard & Taxonomy | Primary CWEs | Universal Architectural Invariant | Criticality |
|---|---|---|---|---|
| **A01:2021** | Broken Access Control | CWE-200, CWE-284, CWE-639 | Authorization must be enforced at the domain/data layer for every operation; access decisions must be bound to the authenticated principal's verified tenant/ownership boundary, never relying on client-controlled identifiers. | **Critical** |
| **A02:2021** | Cryptographic Failures | CWE-259, CWE-327, CWE-331 | All sensitive data at rest and in transit must be protected using modern, authenticated cryptographic primitives (AEAD) with high-entropy keys; passwords must use adaptive memory-hard hashing; zero hardcoded secrets. | **Critical** |
| **A03:2021** | Injection | CWE-79, CWE-89, CWE-94, CWE-77 | Untrusted data must never be concatenated into command interpreters or structured language parsers; code and data must remain strictly isolated via parameterized interfaces or context-aware encoding. | **Critical** |
| **A04:2021** | Insecure Design | CWE-209, CWE-256, CWE-501 | Systems must implement defensive-by-default architectural threat boundaries; error handling must never expose internal state/stack traces to clients; trust transitions must be validated rather than assumed. | **High** |
| **A05:2021** | Security Misconfiguration | CWE-16, CWE-611 | Systems and parsers must operate in a minimal, hardened state; external entity resolution and diagnostic interfaces must be disabled by default; security headers and strict CORS must be enforced. | **High** |
| **A06:2021** | Vulnerable & Outdated Components | CWE-1104 | All third-party dependencies must be pinned, validated against cryptographic hashes, continuously audited for known CVEs, and kept within maintained lifecycle support. | **Medium** |
| **A07:2021** | Identification & Auth Failures | CWE-287, CWE-384 | Authentication credentials must be cryptographically verified on every invocation; sessions must be rotated upon privilege escalation, time-limited, and invalidated on logout. | **Critical** |
| **A08:2021** | Software & Data Integrity Failures | CWE-502, CWE-829 | Serialized byte streams and external dependencies must be cryptographically signed; data parsing must deserialize strictly into inert schemas rather than executable polymorphic objects. | **Critical** |
| **A09:2021** | Security Logging & Monitoring Failures | CWE-117, CWE-778 | Security-relevant events must emit structured, immutable audit logs with correlation IDs, masking sensitive fields and sanitizing input to prevent log forging/splitting. | **Medium** |
| **A10:2021** | Server-Side Request Forgery (SSRF) | CWE-918 | Outbound network requests initiated from user-supplied URLs must resolve to IP addresses verified as non-internal (blocking RFC 1918, loopback, link-local, and cloud metadata) prior to socket connection. | **Critical** |
| **API1:2023** | Broken Object Level Authorization (BOLA) | CWE-639, CWE-284 | Every API endpoint accepting an object identifier must validate that the authenticated principal possesses explicit permission to access that specific entity instance. | **Critical** |
| **API2:2023** | Broken Authentication | CWE-287, CWE-384 | API authentication tokens and keys must be validated on every request via unforgeable signatures, strictly bounded in time, and immune to credential stuffing. | **Critical** |
| **API3:2023** | Broken Object Property Level Authorization | CWE-915, CWE-213 | APIs must enforce property-level whitelisting for both input mutations (preventing mass assignment) and output responses (preventing excessive data exposure). | **High** |
| **API4:2023** | Unrestricted Resource Consumption | CWE-770, CWE-400 | APIs must restrict incoming request rates, payload sizes, execution timeouts, memory allocations, and pagination page sizes to deterministic maximum boundaries. | **High** |
| **API5:2023** | Broken Function Level Authorization (BFLA) | CWE-285 | Every API function and route handler must enforce role-based or attribute-based authorization corresponding to the required privilege level, denying access by default. | **Critical** |
| **API6:2023** | Unrestricted Access to Sensitive Business Flows | CWE-799 | High-impact business workflows (checkout, coupon redemption, reservation) must enforce transactional state machines, velocity limits, and bot mitigation. | **High** |
| **API7:2023** | Server Side Request Forgery (SSRF) | CWE-918 | Webhooks and remote resource fetching must be routed through isolated egress proxies with pre-flight DNS and IP validation against private CIDR blocks. | **Critical** |
| **API8:2023** | Security Misconfiguration | CWE-16, CWE-209 | API endpoints, gateways, and reverse proxies must return sanitized machine-readable errors (RFC 7807), enforce strict CORS origin allowlists, and strip server fingerprint headers. | **High** |
| **API9:2023** | Improper Inventory Management | CWE-1059 | Every deployed API route and version must be registered in the authoritative contract catalog (OpenAPI); legacy and shadow endpoints must be decommissioned. | **Medium** |
| **API10:2023** | Unsafe Consumption of APIs | CWE-20 | Data received from third-party APIs or upstream microservices must be validated against strict schemas before consumption, with enforced TLS, timeouts, and circuit breakers. | **High** |

---

## 2. Threat Vectors & Attack Surfaces

Modern applications bridge untrusted public networks with internal databases and microservices across distinct trust boundaries:

```text
  [ Untrusted Clients / Attackers ]
         │          │
   Public HTTPS   Public API Calls
         │          │
         ▼          ▼
┌─────────────────────────────────────────────────────────────────┐
│ TRUST BOUNDARY 1: Edge & Ingress Layer                          │
│ • Reverse Proxy / CDN / API Gateway                             │
│ • Rate Limiting, WAF, TLS Termination, CORS Policy              │
└────────────────┬────────────────────────────────────────────────┘
                 │ Forwarded Request (with Headers, Cookies, Body)
                 ▼
┌─────────────────────────────────────────────────────────────────┐
│ TRUST BOUNDARY 2: Application Controllers & Route Handlers      │
│ • Authentication Token Validation (API2, A07)                   │
│ • Function-Level Authorization / RBAC (API5, A01)               │
│ • Input Parsing & DTO Boundary Validation (API3, A03, A05)      │
└────────────────┬────────────────────────────────────────────────┘
                 │ Validated Domain Commands & Entity IDs
                 ▼
┌─────────────────────────────────────────────────────────────────┐
│ TRUST BOUNDARY 3: Domain Services & Business Logic              │
│ • Object-Level Authorization / Tenant Scoping (BOLA / API1, A01)│
│ • State Machine Integrity & Velocity Checks (API6)              │
│ • Safe Cryptography & Key Management (A02)                      │
└───────┬─────────────────────────┬───────────────────────┬───────┘
        │ Sanitized Query         │ Safe Inert Object     │ Guarded Outbound URL
        ▼                         ▼                       ▼
┌───────────────┐       ┌─────────────────┐     ┌─────────────────┐
│ Data Layer    │       │ Serialization   │     │ Outbound Client │
│ • SQL / NoSQL │       │ • Safe JSON     │     │ • Egress Proxy  │
│ • ORM Scope   │       │ • No Eval/Pickle│     │ • SSRF Guard    │
│ (A03, API1)   │       │ (A08)           │     │ (A10, API7)     │
└───────────────┘       └─────────────────┘     └────────┬────────┘
                                                         │
                                                         ▼
                                                ┌─────────────────┐
                                                │ Upstream APIs   │
                                                │ Schema Checked  │
                                                │ (API10)         │
                                                └─────────────────┘
```

### Key Attack Surface Transitions

1. **Client to Ingress**: Attackers manipulate HTTP headers, route paths, query strings, and payloads to bypass edge filters, invoke undocumented routes (API9), or exhaust server resources (API4).
2. **Controller to Domain**: Unvalidated object identifiers trigger Broken Object Level Authorization (BOLA/API1, A01). Unfiltered payload dictionaries trigger mass assignment (API3).
3. **Domain to Persistence**: Unparameterized string interpolation triggers Injection (A03). Queries lacking tenant predicates leak records across tenant boundaries (A01).
4. **Backend to External Networks**: Unvalidated outbound webhooks and URLs trigger Server-Side Request Forgery (SSRF/A10, API7) into cloud metadata (`169.254.169.254`) or internal microservices.
5. **Upstream Services to Core Logic**: Unvalidated third-party API responses corrupt domain state or inject unexpected payload properties (API10).

---

## 3. Invariant Sinks & Source Boundaries

### Untrusted Source Catalog

Every data element originating from outside the application's verified trust domain must be classified as untrusted taint:
- **Route Parameters**: `req.params`, `@PathVariable`, `$routeParams`, URL path segments (`/api/items/:id`).
- **Query Strings**: `req.query`, `@RequestParam`, `$_GET`, search parameters, sorting flags, pagination offsets.
- **Request Bodies**: `req.body`, `@RequestBody`, JSON, XML, multipart form data, file uploads.
- **HTTP Headers**: `Authorization`, `Cookie`, `Host`, `X-Forwarded-*`, `Origin`, `Referer`, custom headers.
- **Asynchronous Ingress**: Webhook payloads, message queue items (RabbitMQ, Kafka, SQS), Redis pub/sub events.
- **Upstream Network Responses**: JSON/XML responses from third-party REST, SOAP, or GraphQL services.

### Dangerous Sinks Taxonomy

| Failure Class | Vulnerable Sinks & Functions | Invariant Violation |
|---|---|---|
| **SQL / NoSQL Injection** | `db.query("${val}")`, `db.raw()`, `Collection.find({ $where: val })`, `repository.query()` | Code and data mixed in database query syntax. |
| **Command Injection** | `child_process.exec()`, `os.system()`, `Runtime.getRuntime().exec()`, `shell_exec()` | Untrusted input altering shell token parsing. |
| **Code Evaluation** | `eval()`, `new Function()`, `vm.runInContext()`, `pickle.loads()`, `unserialize()` | Untrusted strings parsed as executable byte code. |
| **Object Authorization** | `Entity.findById(req.params.id)` without tenant/owner predicate | Relying on client-supplied ID without authorization check. |
| **Property Assignment** | `entity.update(req.body)`, `Object.assign(model, req.body)`, `User.create(params)` | Unconstrained dictionary fields altering privileged attributes. |
| **Output Reflection / XSS** | `dangerouslySetInnerHTML`, `innerHTML`, `res.send("<div>" + input + "</div>")` | Unencoded strings interpreted as browser markup. |
| **Network Egress (SSRF)** | `fetch(url)`, `axios.get(url)`, `http.get(url)`, `urllib.request.urlopen(url)` | Unverified destination IP allowing intranet access. |
| **Cryptographic Primitives** | `crypto.createCipher('des')`, `Math.random()`, `md5()`, `jwt.decode()` | Broken algorithms, zero entropy, or skipped verification. |
| **XML Parsers (XXE)** | `DOMParser.parseFromString()`, `xml2js.parseString()`, `ET.fromstring()` | Entity expansion enabled by default. |
| **Logging Facilities** | `logger.info("User: " + input)`, `console.log(rawErr)` | CRLF log forging or plaintext credential exposure. |

---

## 4. Two-Tier Audit Procedure

The audit engine utilizes a strict two-tier verification workflow:
- **Tier 1 (Fast Discovery)**: High-speed heuristic search patterns to locate candidate call sites.
- **Tier 2 (AST & Structural Confirmation)**: Deep syntax tree, type, and reachability inspection to eliminate false positives and prove exploitability.

---

### Coverage 1: OWASP Web Application Security Top 10 (2021)

#### A01:2021 — Broken Access Control (CWE-200, CWE-284, CWE-639 IDOR)
- **Universal Invariant**: Every operation on a resource must verify that the requesting principal possesses authorized ownership or permission for that specific resource instance.
- **Dangerous Sinks & Patterns**:
  - Direct database lookups using only client-supplied primary keys (e.g. `Order.findById(req.params.id)`).
  - Controller actions lacking route authorization guards (`@UseGuards(AuthGuard)`).
  - Path traversal in file downloads (`fs.readFile(path.join(uploadDir, req.query.filename))`).
- **Tier 1 Discovery**:
  - Regex: `(findById|findOne|delete|destroy)\s*\(\s*(req\.params|params)\.[a-zA-Z0-9_]+`
  - Search: `router\.(get|post|put|delete)\s*\([^,]+,\s*(async\s*)?\([^)]*\)\s*=>` lacking guard middleware.
- **Tier 2 AST Triage**:
  - Inspect the AST of the controller function:
    1. Check if the database query AST node includes a `where` clause with tenant/user ID (e.g. `{ id: params.id, userId: session.user.id }`).
    2. Check if a route-level authorization decorator or middleware is attached to the route declaration.
    3. If neither is present and client parameter feeds the lookup key, flag as `[VERIFIED STATIC FLAW]`.

#### A02:2021 — Cryptographic Failures (CWE-259, CWE-327, CWE-331)
- **Universal Invariant**: Sensitive data at rest and in transit must use modern authenticated ciphers (AEAD); zero hardcoded keys; adaptive password hashing.
- **Dangerous Sinks & Patterns**:
  - Hardcoded string literals assigned to keys (`const KEY = "secret123"`).
  - Weak hash algorithms (`crypto.createHash('md5')`, `crypto.createHash('sha1')`).
  - Deprecated ciphers (`crypto.createCipher('des')`, `aes-128-ecb`).
  - Insecure random generators (`Math.random()`) used for tokens or session IDs.
- **Tier 1 Discovery**:
  - Regex: `(createHash|createCipher|createCipheriv)\s*\(\s*['"](md5|sha1|des|rc4|aes-[0-9]+-ecb)`
  - Regex: `(const|let|var)\s+[A-Za-z0-9_]*(SECRET|KEY|PASSWORD|TOKEN)\s*=\s*['"][^'"]{4,}['"]`
  - Regex: `Math\.random\(\)` inside token or session generation logic.
- **Tier 2 AST Triage**:
  - Check AST CallExpression arguments:
    1. Verify algorithm string literal against approved set (`aes-256-gcm`, `chacha20-poly1305`, `sha256`, `sha512`).
    2. Check variable declarations: if key identifier resolves to a string literal instead of `process.env` or secret manager call, flag as `[VERIFIED STATIC FLAW]`.
    3. Verify random byte generators use `crypto.randomBytes` or `crypto.getRandomValues`.

#### A03:2021 — Injection (CWE-79, CWE-89, CWE-94, CWE-77)
- **Universal Invariant**: Interpreters must receive invariant program syntax, with untrusted variables passed strictly out-of-band via parameters or context-aware encoding.
- **Dangerous Sinks & Patterns**:
  - SQL concatenation: `db.raw("SELECT * FROM users WHERE id = " + id)`.
  - Command injection: `child_process.exec("ping -c 1 " + host)`.
  - Eval & dynamic code: `eval(req.body.code)`, `new Function(code)`.
  - Client-side XSS: `element.innerHTML = userInput`, `dangerouslySetInnerHTML={{ __html: userInput }}`.
- **Tier 1 Discovery**:
  - Regex: `\.(query|raw|execute)\s*\(\s*(`[^`]*\$\{[^}]+\}[^`]*`|["'][^"']*\s*\+\s*)`
  - Regex: `(child_process|exec|execSync)\s*\(`
  - Regex: `(dangerouslySetInnerHTML|innerHTML\s*=)`
- **Tier 2 AST Triage**:
  - Inspect query/execution CallExpression AST:
    1. Check if first argument is a `BinaryExpression` (string concatenation) or `TemplateLiteral` with non-empty `expressions`.
    2. Trace expression variables back to function parameters. If parameter originates from request source, confirm taint.
    3. Verify if parameterized replacement array is present as a secondary argument. If absent, flag as `[VERIFIED STATIC FLAW]`.

#### A04:2021 — Insecure Design (CWE-209, CWE-256, CWE-501)
- **Universal Invariant**: Error handlers must never leak stack traces or system state to untrusted callers; trust boundaries must be explicitly validated.
- **Dangerous Sinks & Patterns**:
  - Returning raw error objects in responses: `res.status(500).json({ error: err.stack })`.
  - Storing plaintext credentials in configuration objects.
  - Relying on client-supplied trust state (e.g. `req.headers['x-is-admin'] === 'true'`).
- **Tier 1 Discovery**:
  - Regex: `res\.(status\([0-9]+\)\.)?(json|send)\s*\(\s*\{[^}]*(stack|message:\s*err\.)`
  - Regex: `req\.headers\[['"]x-(role|admin|user|privilege)`
- **Tier 2 AST Triage**:
  - Inspect CatchClause and error handler AST:
    1. Check CallExpression nodes on response objects (`res.json()`, `res.send()`).
    2. Check if property accessed is `stack` or raw `err` without sanitization/mapping.
    3. Verify presence of centralized RFC 7807 Problem Details transformer.

#### A05:2021 — Security Misconfiguration (CWE-16, CWE-611)
- **Universal Invariant**: Systems must run in a minimal, secure-by-default posture; XML entity resolution and debug features must be explicitly disabled in all environments.
- **Dangerous Sinks & Patterns**:
  - XML parsers without DTD/external entity suppression (`resolveExternals: true`).
  - Overly permissive CORS: `Access-Control-Allow-Origin: *` combined with `Allow-Credentials: true`.
  - Missing security headers (Helmet, CSP, HSTS).
  - Debug mode enabled: `DEBUG = true`, `NODE_ENV = 'development'` in production manifests.
- **Tier 1 Discovery**:
  - Regex: `(DOMParser|xml2js|parseXml|libxml)\s*\(`
  - Regex: `origin:\s*['"]\*['"]` alongside `credentials:\s*true`
  - Regex: `app\.use\s*\(\s*cors\s*\(\s*\)\s*\)` without configuration.
- **Tier 2 AST Triage**:
  - Inspect parser instantiation AST:
    1. Check options object for `noent: false` (libxml) or `disallowDoctype: true`.
    2. Check CORS middleware AST options: flag wildcard origin with credentials.
    3. Verify registration of security header middleware prior to router mounting.

#### A06:2021 — Vulnerable and Outdated Components (CWE-1104)
- **Universal Invariant**: All third-party dependencies must be pinned, validated against cryptographic hashes, continuously audited for known CVEs, and kept within maintained lifecycle support.
- **Dangerous Sinks & Patterns**:
  - Unpinned dependency versions (`*`, `latest`, `^` with broad ranges).
  - Outdated components with published high/critical CVEs.
  - External script tags without Subresource Integrity (SRI) hashes.
- **Tier 1 Discovery**:
  - Search package manifests (`package.json`, `Cargo.toml`, `requirements.txt`) for wildcard versions.
  - Scan HTML/JSX templates for `<script src="http` lacking `integrity=`.
- **Tier 2 AST Triage**:
  - Parse lockfiles (`package-lock.json`, `pnpm-lock.yaml`, `Cargo.lock`):
    1. Confirm every package entry includes a cryptographic checksum (`sha512-...`).
    2. Cross-reference dependency AST import statements to verify if vulnerable library functions are reachable in application code.

#### A07:2021 — Identification and Authentication Failures (CWE-287, CWE-384)
- **Universal Invariant**: Caller identity must be verified using unforgeable credentials; sessions must rotate upon authentication and invalidate on logout.
- **Dangerous Sinks & Patterns**:
  - Session fixation: retaining session identifier across login transitions.
  - Unverified JWTs: `jwt.decode()` used instead of `jwt.verify()`, or missing algorithm whitelisting.
  - Missing rate limiting on login/auth routes.
- **Tier 1 Discovery**:
  - Regex: `jwt\.decode\s*\(`
  - Regex: `jwt\.verify\s*\([^,]+,[^,]+\)` without algorithm options.
  - Regex: Session creation in login handler without `session.regenerate()`.
- **Tier 2 AST Triage**:
  - Inspect login controller AST:
    1. Check for `req.session.regenerate()` call node prior to setting user ID.
    2. Inspect `jwt.verify` options: verify that `algorithms` array is explicitly declared and excludes `none`.

#### A08:2021 — Software and Data Integrity Failures (CWE-502, CWE-829)
- **Universal Invariant**: Untrusted data must be parsed into inert data structures rather than reconstituted into polymorphic live objects with executable bindings.
- **Dangerous Sinks & Patterns**:
  - Insecure deserialization: `pickle.loads()`, `unserialize()`, `yaml.load()` without SafeLoader.
  - Ingestion of unverified external code or plugins.
- **Tier 1 Discovery**:
  - Regex: `(pickle\.loads|unserialize|yaml\.load|node-serialize)`
  - Regex: `JSON\.parse\s*\([^)]*\)` with custom reviver invoking dynamic constructors.
- **Tier 2 AST Triage**:
  - Inspect CallExpression node:
    1. Check if argument to deserializer originates from network input.
    2. Confirm whether safe alternatives (e.g. `yaml.safeLoad`, `zod.parse`) are used. If dangerous polymorphic loader is invoked on untrusted data, flag as `[VERIFIED STATIC FLAW]`.

#### A09:2021 — Security Logging and Monitoring Failures (CWE-117, CWE-778)
- **Universal Invariant**: Security-relevant events must produce structured, tamper-evident audit logs without recording sensitive credentials or permitting CRLF log injection.
- **Dangerous Sinks & Patterns**:
  - Empty catch blocks swallowing security errors silently.
  - String concatenation in loggers: `logger.info("Failed login: " + username)`.
  - Logging passwords, authorization tokens, or credit cards.
- **Tier 1 Discovery**:
  - Regex: `catch\s*\([^)]*\)\s*\{\s*\}`
  - Regex: `(logger|console)\.(info|error|warn)\s*\([^)]*\+[^)]*\)`
  - Regex: `logger\.(info|debug)\s*\([^)]*(password|token|secret|authorization)`
- **Tier 2 AST Triage**:
  - Inspect Logger CallExpression AST:
    1. Verify argument is a structured object node (`{ event: 'auth_fail', user }`) rather than a binary expression.
    2. Verify log inputs are sanitized of `\r` and `\n` characters to prevent CRLF splitting.

#### A10:2021 — Server-Side Request Forgery (SSRF) (CWE-918)
- **Universal Invariant**: Outbound network requests initiated from user-supplied URLs must resolve to IP addresses verified as non-internal prior to socket connection.
- **Dangerous Sinks & Patterns**:
  - Calling HTTP clients directly with user-supplied URLs (`fetch(req.query.url)`, `axios.get(req.body.webhook)`).
  - PDF or image generators rendering remote URLs.
- **Tier 1 Discovery**:
  - Regex: `(fetch|axios|http\.get|request|got)\s*\(\s*(req\.|params\.|body\.)`
  - Regex: `urllib\.request\.urlopen\s*\(`
- **Tier 2 AST Triage**:
  - Trace target URL parameter in AST:
    1. Confirm URL originates from external request source.
    2. Check if request passes through an SSRF validation guard or custom DNS-resolving HTTP agent before the network call. If called directly, flag as `[VERIFIED STATIC FLAW]`.

---

### Coverage 2: OWASP API Security Top 10 (2023)

#### API1:2023 — Broken Object Level Authorization (BOLA)
- **Universal Invariant**: Every API endpoint accepting an object identifier must validate that the authenticated principal possesses explicit permission to access that specific entity instance.
- **Dangerous Sinks & Patterns**:
  - Route handlers querying entities by primary key alone (`GET /api/documents/:id` -> `db.find({ id })`).
  - Missing tenant scope in database update/delete statements.
- **Tier 1 Discovery**:
  - Regex: `router\.(get|put|patch|delete)\s*\(['"][^'"]*:(id|uuid|accountId)[^'"]*`
  - Search: ORM lookup calls using parameter without user/tenant session filter.
- **Tier 2 AST Triage**:
  - Check controller AST:
    1. Extract the entity lookup query node.
    2. Verify the presence of an authorization filter matching authenticated principal (`{ id: params.id, tenantId: user.tenantId }`) or an explicit authorization check function (`authService.canAccess(user, entity)`).
    3. If query relies solely on client parameter, flag as `[VERIFIED STATIC FLAW]`.

#### API2:2023 — Broken Authentication
- **Universal Invariant**: API authentication tokens and keys must be validated on every request via unforgeable signatures, strictly bounded in time, and immune to credential stuffing.
- **Dangerous Sinks & Patterns**:
  - Endpoints lacking authentication middleware.
  - Accepting API keys via URL query strings (`req.query.api_key`).
  - Weak JWT verification (allowing `alg: none` or skipping expiration checks).
- **Tier 1 Discovery**:
  - Regex: `req\.query\.(api_key|token|access_token|secret)`
  - Regex: `router\.(get|post|put|delete)` on non-public paths without auth middleware.
- **Tier 2 AST Triage**:
  - Check router hierarchy AST:
    1. Confirm all non-exempt routes inherit authentication guards.
    2. Check JWT verification options AST: assert `ignoreExpiration: false` and algorithms whitelist.

#### API3:2023 — Broken Object Property Level Authorization
- **Universal Invariant**: APIs must enforce property-level whitelisting for both input mutations (preventing mass assignment) and output responses (preventing excessive data exposure).
- **Dangerous Sinks & Patterns**:
  - Passing unconstrained request body directly to ORM: `User.update(req.body)`.
  - Returning raw database entity directly in API response: `res.json(userEntity)` containing `password_hash`.
- **Tier 1 Discovery**:
  - Regex: `\.(update|create|save|assign)\s*\([^,]*req\.body`
  - Regex: `res\.json\s*\(\s*(user|account|record|entity)\s*\)` without serialization filter.
- **Tier 2 AST Triage**:
  - Inspect controller mutation AST:
    1. Check if request body passes through a DTO schema parser (e.g. Zod, Joi, Class-Validator) with `stripUnknown: true` or `additionalProperties: false`.
    2. Inspect serialization AST: verify entity is transformed via a presentation DTO / resource mapper before output.

#### API4:2023 — Unrestricted Resource Consumption
- **Universal Invariant**: APIs must restrict incoming request rates, payload sizes, execution timeouts, memory allocations, and pagination page sizes to deterministic maximum boundaries.
- **Dangerous Sinks & Patterns**:
  - Unbounded pagination: `SELECT * FROM items LIMIT req.query.limit` without upper bound.
  - Missing rate limiting on computational or external API endpoints.
  - Unbounded body parser configurations (`bodyParser.json({ limit: '100mb' })`).
- **Tier 1 Discovery**:
  - Regex: `(limit|take|size)\s*:\s*(req\.query|query)\.[a-zA-Z0-9_]+`
  - Regex: `bodyParser\.(json|urlencoded)\s*\(\s*\{[^}]*limit:\s*['"][0-9]+(mb|gb)`
- **Tier 2 AST Triage**:
  - Inspect pagination AST:
    1. Check if `limit` parameter is clamped via `Math.min(limit, MAX_PAGE_SIZE)`.
    2. Check route middleware chain for rate limiter registration (e.g. `rateLimit()`).

#### API5:2023 — Broken Function Level Authorization (BFLA)
- **Universal Invariant**: Every API function and route handler must enforce role-based or attribute-based authorization corresponding to the required privilege level, denying access by default.
- **Dangerous Sinks & Patterns**:
  - Administrative routes (`/api/admin/*`, `/api/v1/users/:id/role`) accessible without role checks.
  - Relying on hidden client UI controls rather than server-side role guards.
- **Tier 1 Discovery**:
  - Regex: `router\.[a-z]+\s*\(['"][^'"]*(admin|manage|settings|export|delete)[^'"]*`
  - Search: Routes lacking `@Roles('admin')` or `requireRole()` middleware.
- **Tier 2 AST Triage**:
  - Inspect route declaration AST:
    1. Verify presence of role/permission check middleware in the handler chain.
    2. Flag any administrative route lacking explicit role validation as `[VERIFIED STATIC FLAW]`.

#### API6:2023 — Unrestricted Access to Sensitive Business Flows
- **Universal Invariant**: High-impact business workflows (checkout, coupon redemption, reservation) must enforce transactional state machines, velocity limits, and bot mitigation.
- **Dangerous Sinks & Patterns**:
  - Coupon redemption or transfer endpoints executable in rapid automated loops without idempotency or rate limits.
  - Non-atomic inventory deductions susceptible to race conditions.
- **Tier 1 Discovery**:
  - Regex: `(redeem|checkout|transfer|purchase|vote)\s*\(`
  - Search: Business transaction handlers lacking idempotency keys or distributed locks.
- **Tier 2 AST Triage**:
  - Inspect business workflow handler AST:
    1. Verify presence of atomic database locks or conditional updates (`WHERE status = 'active'`).
    2. Check for idempotency key validation middleware.

#### API7:2023 — Server Side Request Forgery (SSRF)
- **Universal Invariant**: Webhooks and remote resource fetching must be routed through isolated egress proxies with pre-flight DNS and IP validation against private CIDR blocks.
- **Dangerous Sinks & Patterns**:
  - Webhook registration endpoints that immediately dispatch payloads to user-provided URLs.
  - Remote media import endpoints (`POST /api/import-avatar { url }`).
- **Tier 1 Discovery**:
  - Regex: `(webhookUrl|callbackUrl|targetUrl)\s*:`
  - Search: HTTP client calls inside webhook dispatch handlers.
- **Tier 2 AST Triage**:
  - Inspect dispatch function AST:
    1. Check whether destination URL is checked against an IP allowlist before socket connection.
    2. Verify egress proxy configuration.

#### API8:2023 — Security Misconfiguration
- **Universal Invariant**: API endpoints, gateways, and reverse proxies must return sanitized machine-readable errors (RFC 7807), enforce strict CORS origin allowlists, and strip server fingerprint headers.
- **Dangerous Sinks & Patterns**:
  - Stack traces returned in JSON API responses.
  - Wildcard CORS headers (`Access-Control-Allow-Origin: *`) on endpoints processing credentials.
- **Tier 1 Discovery**:
  - Regex: `res\.(status\([0-9]+\)\.)?json\s*\(\s*err\s*\)`
  - Regex: `origin:\s*['"]\*['"]`
- **Tier 2 AST Triage**:
  - Inspect global exception filter AST:
    1. Confirm responses follow standardized schema without exposing internal fields.
    2. Verify CORS middleware AST contains explicit origin allowlist.

#### API9:2023 — Improper Inventory Management
- **Universal Invariant**: Every deployed API route and version must be registered in the authoritative contract catalog (OpenAPI); legacy and shadow endpoints must be decommissioned.
- **Dangerous Sinks & Patterns**:
  - Unregistered debug routes (`/api/debug/*`, `/api/test/*`).
  - Active legacy API versions (`/api/v1/`) running with unpatched vulnerabilities.
- **Tier 1 Discovery**:
  - Regex: `router\.[a-z]+\s*\(['"][^'"]*(v1|beta|test|debug|temp)[^'"]*`
- **Tier 2 AST Triage**:
  - Compare route AST inventory against declared OpenAPI specification:
    1. Flag any implemented route missing from OpenAPI contract as `[CONTRACT MISMATCH]`.
    2. Flag any deprecated route active without `Sunset` header.

#### API10:2023 — Unsafe Consumption of APIs
- **Universal Invariant**: Data received from third-party APIs or upstream microservices must be validated against strict schemas before consumption, with enforced TLS, timeouts, and circuit breakers.
- **Dangerous Sinks & Patterns**:
  - Consuming third-party API responses directly without schema validation.
  - Disabling TLS certificate validation (`rejectUnauthorized: false`).
- **Tier 1 Discovery**:
  - Regex: `rejectUnauthorized:\s*false`
  - Search: `const res = await fetch(...); const data = await res.json();` without schema parsing.
- **Tier 2 AST Triage**:
  - Inspect upstream HTTP client AST:
    1. Verify TLS verification option is true or omitted (default secure).
    2. Verify upstream response data is parsed through a validation schema (e.g. `schema.parse(data)`).

---

## 5. Defensive Remediation & Invariant Enforcement

### Architectural Remediation Patterns for Web App Top 10 (2021)

#### A01: Scoped Tenant Repository & Safe Path Resolution
```typescript
// 1. Invariant: Multi-tenant repository forces tenant boundary
export class TenantScopedOrderRepository {
  constructor(private readonly db: Database, private readonly tenantId: string) {}

  async findOrder(orderId: string): Promise<Order | null> {
    // Invariant: Tenant ID predicate is structurally mandatory
    return this.db.orders.findOne({
      where: { id: orderId, tenantId: this.tenantId }
    });
  }
}

// 2. Invariant: Path traversal prevention via canonical root boundary assertion
export function resolveSafeUploadPath(baseDir: string, userFileName: string): string {
  const safeBase = path.resolve(baseDir);
  const targetPath = path.resolve(safeBase, userFileName);
  if (!targetPath.startsWith(safeBase + path.sep)) {
    throw new SecurityBoundaryViolation("Path traversal attempt detected");
  }
  return targetPath;
}
```

#### A02: Authenticated Cryptographic Envelope (AEAD)
```typescript
import { createCipheriv, createDecipheriv, randomBytes } from "crypto";

const ALGORITHM = "aes-256-gcm";
const IV_LENGTH = 12;
const TAG_LENGTH = 16;

export function encryptSecret(plaintext: Buffer, key: Buffer): Buffer {
  const iv = randomBytes(IV_LENGTH);
  const cipher = createCipheriv(ALGORITHM, key, iv);
  const encrypted = Buffer.concat([cipher.update(plaintext), cipher.final()]);
  const tag = cipher.getAuthTag();
  // Wire format: [IV (12B)] [Tag (16B)] [Ciphertext]
  return Buffer.concat([iv, tag, encrypted]);
}

export function decryptSecret(payload: Buffer, key: Buffer): Buffer {
  const iv = payload.subarray(0, IV_LENGTH);
  const tag = payload.subarray(IV_LENGTH, IV_LENGTH + TAG_LENGTH);
  const ciphertext = payload.subarray(IV_LENGTH + TAG_LENGTH);
  const decipher = createDecipheriv(ALGORITHM, key, iv);
  decipher.setAuthTag(tag);
  return Buffer.concat([decipher.update(ciphertext), decipher.final()]);
}
```

#### A03: Parameterized SQL & Argument Vector Command Execution
```typescript
import { execFile } from "child_process";
import { promisify } from "util";

const execFileAsync = promisify(execFile);

// Safe SQL Invariant: Strict query parameters
export async function getUserById(db: Database, userId: string): Promise<User> {
  return db.query("SELECT id, username, email FROM users WHERE id = $1", [userId]);
}

// Safe Command Invariant: ExecFile with argument vector (no shell interpolation)
export async function pingSafe(host: string): Promise<string> {
  // Validate host format strictly first
  if (!/^[a-zA-Z0-9.-]+$/.test(host)) {
    throw new InvalidArgumentError("Invalid hostname format");
  }
  const { stdout } = await execFileAsync("/bin/ping", ["-c", "1", host], { timeout: 5000 });
  return stdout;
}
```

#### A04: RFC 7807 Standardized Problem Details Error Transformer
```typescript
import { Request, Response, NextFunction } from "express";

export function rfc7807ErrorHandler(err: Error, _req: Request, res: Response, _next: NextFunction) {
  const correlationId = crypto.randomUUID();
  // Internal structured log retains details
  logger.error({ correlationId, message: err.message, stack: err.stack });

  // Outward response contains opaque correlation ID and sanitized message
  res.status(500).contentType("application/problem+json").json({
    type: "https://api.example.com/errors/internal-error",
    title: "An internal server error occurred",
    status: 500,
    detail: "Contact support with correlation ID if problem persists.",
    instance: `/errors/${correlationId}`
  });
}
```

#### A05: Hardened XML Parser & Security Headers
```typescript
import helmet from "helmet";
import { XMLParser } from "fast-xml-parser";

// 1. Security Headers Configuration
export const securityHeaders = helmet({
  contentSecurityPolicy: { directives: { defaultSrc: ["'self'"] } },
  crossOriginEmbedderPolicy: true,
  hsts: { maxAge: 31536000, includeSubDomains: true, preload: true }
});

// 2. Safe XML Parser: Entity expansion and external DTDs explicitly disabled
export const safeXmlParser = new XMLParser({
  processEntities: false,
  allowBooleanAttributes: false,
  stopNodes: ["*.doctype", "*.dtd"]
});
```

#### A06: Dependency Integrity & Audit CI Gate
```bash
# Package manifest lockfile verification gate
npm ci --ignore-scripts --audit
npm audit --audit-level=high
```

#### A07: Session Regeneration & Strict JWT Verification
```typescript
import jwt from "jsonwebtoken";

// Safe Login Invariant: Session ID regenerated upon authentication
export async function handleLogin(req: Request, res: Response, user: User) {
  req.session.regenerate((err) => {
    if (err) throw err;
    req.session.userId = user.id;
    res.status(200).json({ status: "authenticated" });
  });
}

// Strict JWT Invariant: Explicit algorithm whitelist and expiration check
export function verifyAuthToken(token: string, publicKey: string): TokenPayload {
  return jwt.verify(token, publicKey, {
    algorithms: ["RS256"],
    ignoreExpiration: false
  }) as TokenPayload;
}
```

#### A08: Inert Schema-Enforced Deserialization
```typescript
import { z } from "zod";

const UserProfileSchema = z.object({
  displayName: z.string().min(1).max(50),
  bio: z.string().max(200).optional()
}).strict(); // Invariant: rejects unexpected keys/prototypes

export function parseInertUserData(rawJson: string) {
  const parsed = JSON.parse(rawJson); // Inert JSON only, no polymorphic class execution
  return UserProfileSchema.parse(parsed);
}
```

#### A09: Structured Log Sanitizer & Audit Channel
```typescript
export function sanitizeLogInput(input: string): string {
  // Invariant: Strip CRLF to prevent log line injection
  return input.replace(/[\r\n]/g, "_");
}

export function logSecurityEvent(event: string, principalId: string, metadata: Record<string, unknown>) {
  logger.info({
    timestamp: new Date().toISOString(),
    event,
    principalId,
    metadata
  });
}
```

#### A10: Egress SSRF Guard with DNS/IP Pinning
```typescript
import dns from "dns/promises";
import net from "net";

const PRIVATE_RANGES = [
  /^127\./, /^10\./, /^172\.(1[6-9]|2[0-9]|3[0-1])\./, /^192\.168\./, /^169\.254\./
];

export async function assertPublicDestination(targetUrl: string): Promise<URL> {
  const parsed = new URL(targetUrl);
  if (parsed.protocol !== "https:" && parsed.protocol !== "http:") {
    throw new SecurityBoundaryViolation("Unsupported protocol");
  }
  const { address } = await dns.lookup(parsed.hostname);
  if (!net.isIP(address)) {
    throw new SecurityBoundaryViolation("Unable to resolve valid IP address");
  }
  for (const range of PRIVATE_RANGES) {
    if (range.test(address)) {
      throw new SecurityBoundaryViolation(`Destination IP ${address} is in private/internal range`);
    }
  }
  return parsed;
}
```

---

### Architectural Remediation Patterns for OWASP API Security Top 10 (2023)

#### API1: BOLA Ownership Scoping
```typescript
export async function getDocumentById(userId: string, documentId: string, repo: DocumentRepository) {
  // Invariant: Scoped lookup by both entity ID and owner ID
  const document = await repo.findOne({ where: { id: documentId, ownerId: userId } });
  if (!document) {
    throw new NotFoundError("Document not found or access denied");
  }
  return document;
}
```

#### API2: API Gateway Token Guard
```typescript
export function apiTokenGuard(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Missing or invalid authorization header" });
  }
  const token = authHeader.substring(7);
  try {
    req.user = verifyAuthToken(token, JWT_PUBLIC_KEY);
    next();
  } catch {
    res.status(401).json({ error: "Invalid or expired token" });
  }
}
```

#### API3: Strict DTO Whitelisting & Presentation Projection
```typescript
import { z } from "zod";

export const UpdateProfileDto = z.object({
  displayName: z.string().min(1).max(50),
  bio: z.string().max(250).optional()
}).strict(); // Invariant: additionalProperties forbidden

export function serializePublicUser(user: UserEntity) {
  // Invariant: Explicit projection; sensitive fields (passwordHash, roles) omitted
  return {
    id: user.id,
    displayName: user.displayName,
    bio: user.bio,
    avatarUrl: user.avatarUrl
  };
}
```

#### API4: Distributed Token-Bucket & Page Bounds Clamp
```typescript
export const MAX_PAGE_LIMIT = 100;
export const DEFAULT_PAGE_LIMIT = 20;

export function clampPagination(rawLimit?: string, rawOffset?: string) {
  const limit = Math.min(Math.max(parseInt(rawLimit || `${DEFAULT_PAGE_LIMIT}`, 10), 1), MAX_PAGE_LIMIT);
  const offset = Math.max(parseInt(rawOffset || "0", 10), 0);
  return { limit, offset };
}
```

#### API5: Declarative RBAC Route Guard
```typescript
export function requireRoles(...allowedRoles: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    if (!req.user || !allowedRoles.includes(req.user.role)) {
      return res.status(403).json({ error: "Insufficient function permissions" });
    }
    next();
  };
}
// Usage: router.delete('/users/:id', apiTokenGuard, requireRoles('admin'), deleteUserHandler);
```

#### API6: Transactional State Machine & Lock
```typescript
export async function redeemCoupon(db: Database, couponCode: string, userId: string) {
  return db.transaction(async (trx) => {
    // Invariant: Atomic conditional update prevents concurrent double-redemption
    const affected = await trx("coupons")
      .where({ code: couponCode, is_redeemed: false })
      .update({ is_redeemed: true, redeemed_by: userId, redeemed_at: new Date() });

    if (affected === 0) {
      throw new ConflictError("Coupon already redeemed or invalid");
    }
  });
}
```

#### API7: Isolated Egress Webhook Worker
```typescript
export async function dispatchWebhook(targetUrl: string, eventPayload: Record<string, unknown>) {
  // Invariant: Verify destination does not point to internal network
  const safeUrl = await assertPublicDestination(targetUrl);
  // Dispatch via timeout-constrained HTTP client
  await fetch(safeUrl.toString(), {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(eventPayload),
    signal: AbortSignal.timeout(5000)
  });
}
```

#### API8: Hardened CORS & Header Masking
```typescript
import cors from "cors";

export const apiCors = cors({
  origin: ["https://app.example.com", "https://admin.example.com"],
  methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
  allowedHeaders: ["Authorization", "Content-Type"],
  credentials: true,
  maxAge: 86400
});
```

#### API9: OpenAPI Contract Synchronizer & Drift Gate
```typescript
import { OpenApiValidator } from "express-openapi-validator";

export const contractValidationMiddleware = OpenApiValidator.middleware({
  apiSpec: "./contracts/openapi.yaml",
  validateRequests: true,
  validateResponses: true,
  ignoreUndocumented: false // Invariant: Rejects shadow endpoints
});
```

#### API10: Upstream API Client with Schema Parsing & Circuit Breaker
```typescript
import { z } from "zod";

const UpstreamPaymentStatusSchema = z.object({
  transactionId: z.string().uuid(),
  status: z.enum(["SETTLED", "PENDING", "FAILED"]),
  amount: z.number().positive()
});

export async function fetchUpstreamPayment(txId: string) {
  const response = await fetch(`https://upstream-gateway.example.com/tx/${txId}`, {
    signal: AbortSignal.timeout(4000)
  });
  if (!response.ok) throw new UpstreamServiceError("Upstream call failed");
  const rawData = await response.json();
  // Invariant: Strict schema parsing guarantees upstream data integrity
  return UpstreamPaymentStatusSchema.parse(rawData);
}
```

---

## 6. Closed-Loop Test Verification Criteria

Every security defect must be validated via closed-loop non-offensive unit/integration tests following the Red-Green lifecycle:
1. **Red Test**: Write a test executing the boundary condition or unauthorized state transition. The test must fail prior to remediation.
2. **Green Test**: Implement the architectural patch. The test must pass without regression.

### Test Verification Matrix & Non-Offensive Harness Patterns

#### Web Application Top 10 (2021) Verification Harnesses

```typescript
describe("OWASP Web Top 10 Invariant Verification", () => {
  // A01: Broken Access Control / IDOR
  it("A01: rejects cross-tenant object access without permission", async () => {
    const tenantARepo = new TenantScopedOrderRepository(db, "tenant-A");
    const result = await tenantARepo.findOrder("order-belonging-to-tenant-B");
    expect(result).toBeNull();
  });

  // A02: Cryptographic Failures
  it("A02: AEAD envelope decrypt fails when ciphertext is tampered", () => {
    const key = randomBytes(32);
    const encrypted = encryptSecret(Buffer.from("sensitive_pii"), key);
    // Tamper single byte in ciphertext
    encrypted[encrypted.length - 1] ^= 0xff;
    expect(() => decryptSecret(encrypted, key)).toThrow();
  });

  // A03: Injection
  it("A03: SQL parameterization treats syntax metacharacters as inert literals", async () => {
    const user = await getUserById(db, "1' OR '1'='1");
    // Assert query executed with literal match, returning no user
    expect(user).toBeUndefined();
  });

  // A04: Insecure Design
  it("A04: internal server error returns RFC 7807 opaque detail without stack trace", async () => {
    const response = await request(app).get("/api/simulate-crash");
    expect(response.status).toBe(500);
    expect(response.body.stack).toBeUndefined();
    expect(response.body.instance).toMatch(/^\/errors\/[0-9a-f-]+$/);
  });

  // A05: Security Misconfiguration
  it("A05: XML parser ignores external DTD entity declarations", () => {
    const xml = `<?xml version="1.0"?><!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><root>&xxe;</root>`;
    const parsed = safeXmlParser.parse(xml);
    expect(parsed.root).not.toContain("root:x:0:0");
  });

  // A06: Vulnerable Components
  it("A06: CI lockfile audit reports zero high/critical vulnerabilities", async () => {
    const auditStatus = runNpmAuditCheck();
    expect(auditStatus.vulnerabilities.critical).toBe(0);
    expect(auditStatus.vulnerabilities.high).toBe(0);
  });

  // A07: Identification & Auth Failures
  it("A07: login transitions regenerate session identifier", async () => {
    const agent = request.agent(app);
    const preLoginCookie = (await agent.get("/api/session")).header["set-cookie"];
    const postLoginCookie = (await agent.post("/api/login").send(validCredentials)).header["set-cookie"];
    expect(preLoginCookie).not.toEqual(postLoginCookie);
  });

  // A08: Software & Data Integrity
  it("A08: schema validator rejects payloads with prototype pollution attributes", () => {
    const maliciousJson = '{"displayName":"Alice","__proto__":{"isAdmin":true}}';
    expect(() => parseInertUserData(maliciousJson)).toThrow();
  });

  // A09: Security Logging Failures
  it("A09: log sanitizer replaces CRLF characters with underscores", () => {
    const sanitized = sanitizeLogInput("user\r\nINJECTED_LOG_ENTRY");
    expect(sanitized).toBe("user__INJECTED_LOG_ENTRY");
    expect(sanitized).not.toContain("\n");
  });

  // A10: SSRF
  it("A10: SSRF guard blocks connection attempts to private cloud metadata IP", async () => {
    await expect(assertPublicDestination("http://169.254.169.254/latest/meta-data/"))
      .rejects.toThrow(SecurityBoundaryViolation);
  });
});
```

#### API Security Top 10 (2023) Verification Harnesses

```typescript
describe("OWASP API Security Top 10 Invariant Verification", () => {
  // API1: BOLA
  it("API1: accessing another user's document yields 404 or 403", async () => {
    const userA = { id: "user-101" };
    await expect(getDocumentById(userA.id, "doc-owned-by-user-202", docRepo))
      .rejects.toThrow(NotFoundError);
  });

  // API2: Broken Authentication
  it("API2: expired JWT token returns 401 Unauthorized", async () => {
    const expiredToken = signToken({ sub: "user-1" }, { expiresIn: "-1s" });
    const res = await request(app)
      .get("/api/protected")
      .set("Authorization", `Bearer ${expiredToken}`);
    expect(res.status).toBe(401);
  });

  // API3: Broken Object Property Level Authorization
  it("API3: mass assignment attempt on role attribute is stripped or rejected", () => {
    const payload = { displayName: "ValidName", role: "superadmin" };
    expect(() => UpdateProfileDto.parse(payload)).toThrow();
  });

  // API4: Unrestricted Resource Consumption
  it("API4: pagination limit parameter is clamped to maximum bound", () => {
    const { limit } = clampPagination("999999", "0");
    expect(limit).toBe(MAX_PAGE_LIMIT);
  });

  // API5: Broken Function Level Authorization
  it("API5: non-admin principal accessing admin route yields 403 Forbidden", async () => {
    const regularUserToken = signToken({ sub: "user-1", role: "user" });
    const res = await request(app)
      .delete("/api/admin/users/999")
      .set("Authorization", `Bearer ${regularUserToken}`);
    expect(res.status).toBe(403);
  });

  // API6: Unrestricted Access to Sensitive Business Flows
  it("API6: duplicate concurrent coupon redemption triggers ConflictError on second attempt", async () => {
    const firstRedeem = redeemCoupon(db, "PROMO2026", "user-1");
    const secondRedeem = redeemCoupon(db, "PROMO2026", "user-2");
    const results = await Promise.allSettled([firstRedeem, secondRedeem]);
    const fulfilled = results.filter(r => r.status === "fulfilled");
    const rejected = results.filter(r => r.status === "rejected");
    expect(fulfilled).toHaveLength(1);
    expect(rejected).toHaveLength(1);
  });

  // API7: SSRF
  it("API7: webhook registration rejecting loopback IP", async () => {
    await expect(assertPublicDestination("http://127.0.0.1:8080/internal-status"))
      .rejects.toThrow(SecurityBoundaryViolation);
  });

  // API8: Security Misconfiguration
  it("API8: unlisted CORS origin is rejected and does not return allow-origin header", async () => {
    const res = await request(app)
      .get("/api/data")
      .set("Origin", "https://unauthorized-attacker.com");
    expect(res.header["access-control-allow-origin"]).toBeUndefined();
  });

  // API9: Improper Inventory Management
  it("API9: undocumented endpoint access is blocked by contract gateway", async () => {
    const res = await request(app).get("/api/v1/undocumented-shadow-route");
    expect(res.status).toBe(404);
  });

  // API10: Unsafe Consumption of APIs
  it("API10: upstream payload with missing required fields throws validation exception", async () => {
    const invalidUpstreamData = { transactionId: "not-a-uuid", status: "INVALID_STATUS" };
    expect(() => UpstreamPaymentStatusSchema.parse(invalidUpstreamData)).toThrow();
  });
});
```

---

## 7. Operational Audit Integration

When executing an audit with this threat model:
1. **Reconnaissance**: Read project manifests to detect web frameworks (Express, Fastify, Spring, FastAPI, Django, Gin) and API protocols (REST, OpenAPI, GraphQL).
2. **Scan & Triage**: Run Tier 1 heuristics followed immediately by Tier 2 AST confirmations for each of the 20 categories.
3. **Classify**: Assign confidence tiers (`[VERIFIED STATIC FLAW]`, `[CONTRACT MISMATCH]`, `[MANUAL REVIEW REQUIRED]`).
4. **Reproduce & Remediate**: Write a non-offensive Red unit test, apply the architectural remediation pattern, and assert Green pass.
