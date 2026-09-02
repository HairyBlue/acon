# WooYun Vulnerability Insights

Statistical insights and parameter priorities derived from over 88,000 real-world vulnerability reports from the WooYun platform.

## Top Vulnerable Parameters

When conducting security audits, prioritize testing the following parameters, as they are historically the most frequent sources of vulnerabilities:

1.  **`id`**: Highly susceptible to Insecure Direct Object References (IDOR) and SQL Injection.
2.  **`type`**: Often used in logic flows and can be manipulated for business logic bypass or path traversal.
3.  **`action`**: Frequently targeted for Cross-Site Request Forgery (CSRF) and Remote Code Execution (RCE) via command injection.
4.  **`username`**: A primary target for enumeration, brute-force attacks, and SQL Injection in authentication mechanisms.
5.  **`viewstate`**: Common in .NET applications, often vulnerable to deserialization attacks or tampering if not properly MAC-protected.

## Common Vulnerability Types

*   **SQL Injection**: Remains a prevalent issue, especially in older codebases or poorly parameterized queries.
*   **Cross-Site Scripting (XSS)**: Frequently found in user-generated content and error messages.
*   **Logic Flaws**: High impact, requiring manual analysis to identify improper state transitions and authorization bypasses.
*   **Information Disclosure**: Leaking sensitive data through verbose error messages or insecure configurations.
