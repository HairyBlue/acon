# Verification Methodology

A structured approach to verifying vulnerabilities is essential for accurate auditing, generating Proof of Concepts (PoCs), and eliminating false positives.

## 1. Static Analysis Verification
Before testing dynamic execution, statically confirm the vulnerability.

*   **Trace the complete path:** Ensure a direct path from Source to Sink.
*   **Evaluate Sanitization:** Analyze all transformations applied to the data. Does the sanitization function specifically protect against the target sink? (e.g., HTML escaping does not protect against SQL injection).
*   **Check Context:** Understand the context in which the vulnerability occurs (e.g., is the vulnerable code actually reachable? Does it require specific configurations?).

## 2. Dynamic Verification & PoC Generation
A valid PoC proves the exploitability of a vulnerability.

*   **Craft the Payload:** Create a payload specifically tailored to bypass any weak filters and trigger the sink.
*   **Test Safely:** Use benign payloads for verification (e.g., `id` or `whoami` for command injection, `alert(1)` for XSS, `sleep(5)` for blind SQLi). **Never use destructive payloads.**
*   **Observe Results:** Verify if the payload executed successfully. Check HTTP responses, application logs, or database states.

## 3. Eliminating False Positives
False positives waste time and diminish trust in the audit. Always verify:

*   **Dead Code:** Is the vulnerable function actually called anywhere in the application?
*   **Strong Typing/Casting:** Is the input strictly cast to a safe type (e.g., `(int)$_GET['id']`) before the sink?
*   **Framework Protections:** Does the framework automatically protect against this vulnerability? (e.g., ORMs often handle SQL injection automatically unless raw queries are used).
*   **Authentication/Authorization:** Is the vulnerability only accessible to highly privileged users (e.g., an admin-only feature)? While still a vulnerability, its severity may be lower.

## 4. Documentation
When reporting a verified vulnerability, include:
1.  **Vulnerability Type & Severity**
2.  **Description of the Flaw**
3.  **Affected Code Locations (File & Line Numbers)**
4.  **Data Flow Tracing (Source to Sink)**
5.  **Proof of Concept (PoC) Request/Response**
6.  **Remediation Advice**
