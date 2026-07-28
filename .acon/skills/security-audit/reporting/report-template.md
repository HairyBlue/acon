# Vulnerability Report Template

Use this template to document vulnerabilities discovered during a security audit. This format balances the attacker's perspective (exploitability, impact) with the auditor's perspective (root cause, remediation).

## 1. Executive Summary
- **Vulnerability Title**: [e.g., Unauthenticated SQL Injection in User Login]
- **Severity Level**: [Critical / High / Medium / Low]
- **CVSS 3.1 Score**: [e.g., 9.8 Critical (CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H)]
- **Affected Endpoint/Component**: [e.g., `POST /api/v1/auth/login`]
- **Impact Summary**: [Briefly describe the business impact, e.g., "An unauthenticated attacker can dump the entire user database, leading to full data compromise."]

## 2. Vulnerability Description
[Provide a clear, detailed explanation of the vulnerability. What is the flaw? Where is it located? How does it violate security principles?]

## 3. Proof of Concept (PoC)
[Detail the exact steps to reproduce the vulnerability. Include HTTP requests, payloads, and expected responses.]

**Step 1:** [Action]
**Step 2:** [Action]

**Exploit Payload / Request:**
```http
POST /api/v1/auth/login HTTP/1.1
Host: example.com
Content-Type: application/json

{
  "username": "admin' OR '1'='1",
  "password": "password"
}
```

**Observed Response (Impact):**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "success",
  "token": "eyJhb..."
}
```

## 4. Root Cause Analysis
[Explain technically *why* the vulnerability exists in the codebase. Reference specific files and line numbers if available.]

**Vulnerable Code Snippet (`src/controllers/AuthController.js:42`):**
```javascript
const query = `SELECT * FROM users WHERE username = '${req.body.username}' AND password = '${req.body.password}'`;
db.execute(query);
```
[Explanation of the flaw, e.g., "User input from `req.body.username` is directly concatenated into the SQL query string without sanitization or parameterization, allowing an attacker to manipulate the query structure."]

## 5. Secure Remediation Code
[Provide the corrected, secure version of the code. Explain *how* the fix addresses the root cause.]

**Remediated Code Snippet:**
```javascript
const query = `SELECT * FROM users WHERE username = ? AND password = ?`;
db.execute(query, [req.body.username, req.body.password]);
```
**Remediation Explanation:** [e.g., "The code has been updated to use parameterized queries (prepared statements). The database driver now treats the input strictly as data, preventing it from altering the SQL logic."]
