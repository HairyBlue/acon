# Security Coverage Matrix (D1–D10)

This matrix defines the 10 core security dimensions evaluated during a code security audit.

| # | Dimension | Key Focus & Questions | Criticality |
|---|---|---|---|
| **D1** | **Injection** | Can untrusted user input reach SQL, Command Shell, LDAP, SSTI, or Code Evaluation sinks? | **Critical** |
| **D2** | **Authentication** | Are session IDs regenerated on login? Are passwords hashed using bcrypt/argon2? Are JWT signatures verified? | **Critical** |
| **D3** | **Authorization** | Is object ownership checked on all CRUD endpoints (`findById` vs `where user_id`)? Are role middlewares applied? | **Critical** |
| **D4** | **Deserialization** | Are untrusted data sources passed to `unserialize()`, `pickle`, `BinaryFormatter`, or prototype merge functions? | **Critical** |
| **D5** | **File Operations** | Are upload file extensions restricted via strict whitelist? Are file paths sanitized against `../` path traversal? | **Critical** |
| **D6** | **SSRF** | Are outbound HTTP requests fetching user-supplied URLs? Are internal IP ranges (`127.0.0.1`, `169.254.169.254`) blocked? | **High** |
| **D7** | **Cryptography** | Are secrets or encryption keys hardcoded? Is weak PRNG (`rand()`, `mt_rand()`) used for security tokens? | **High** |
| **D8** | **Security Config** | Are debug pages (Laravel Ignition, Django Debug) enabled in production? Is CORS configured as wildcard `*` with credentials? | **High** |
| **D9** | **Business Logic** | Are mass assignment guards configured (`$fillable`)? Are pricing or parameter values validated on the server side? | **High** |
| **D10** | **Supply Chain** | Do lockfiles (`composer.lock`, `package-lock.json`, `requirements.txt`, `.csproj`) contain dependencies with known CVEs? | **Medium** |

---

## Audit Completion Criteria

- **Critical Triangular Gate**: Dimensions **D1 (Injection)**, **D2 (Authentication)**, and **D3 (Authorization)** must all be thoroughly audited before completing a report.
- **Coverage Goal**: Standard and Deep audits must cover at least **8 out of 10 dimensions**.
