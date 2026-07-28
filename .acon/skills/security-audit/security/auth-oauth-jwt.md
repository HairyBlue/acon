# Authentication & Authorization Security

This document covers common vulnerabilities in authentication mechanisms and authorization controls.

## 1. OAuth2 & OIDC
*   **Open Redirects (Redirect URI)**: Manipulating the `redirect_uri` parameter to steal authorization codes or tokens.
*   **State Parameter Missing/Predictable**: Lack of or predictable `state` parameter leading to Cross-Site Request Forgery (CSRF).
*   **Implicit Flow Misuse**: Exposing tokens in URLs or lacking proper validation of token audience.

## 2. JSON Web Tokens (JWT)
*   **'none' Algorithm**: Accepting JWTs with the `alg` header set to `none`, allowing signature bypass.
*   **Algorithm Confusion**: Forcing the server to use a public key as an HMAC symmetric key.
*   **Weak Secrets**: Using brute-forceable secrets for HMAC signatures.
*   **Lack of Expiration**: Missing `exp` claims, allowing stolen tokens to be used indefinitely.

## 3. Insecure Direct Object References (IDOR)
*   **Predictable Identifiers**: Using sequential integers instead of UUIDs for resource identification.
*   **Missing Access Controls**: Failing to verify if the authenticated user has permission to access the requested object.
*   **IDOR Matrix**: Testing all CRUD operations on objects across different user roles to ensure isolation.

## 4. Role-Based Access Control (RBAC)
*   **Privilege Escalation**: Modifying role parameters during registration or profile updates to gain administrative privileges.
*   **Missing Role Checks**: Failing to validate authorization on administrative or sensitive endpoints.
