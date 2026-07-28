# Filter & WAF Bypass Techniques

Techniques for bypassing security filters and Web Application Firewalls (WAFs), based on real-world patterns.

## 1. SQL Injection Bypass
*   **Whitespace Obfuscation**: Using alternative whitespace characters (e.g., `%0a`, `%0d`, `%09`, `/**/`) to separate keywords.
*   **Keyword Manipulation**: Using case variation (`sElEcT`), inline comments (`SEL/*1*/ECT`), or string concatenation to evade signature detection.
*   **Encoding**: Utilizing URL encoding, Hex encoding, or Unicode encoding.

## 2. Cross-Site Scripting (XSS) Bypass
*   **Tag Evasion**: Using less common HTML tags (e.g., `<svg>`, `<math>`, `<details>`) or manipulating attributes (e.g., `onload`, `onerror`).
*   **Protocol Variations**: Using `javascript:`, `data:`, or `vbscript:` pseudo-protocols.
*   **Encoding**: Exploiting HTML entity encoding, URL encoding, or mixed encoding schemes.

## 3. Command Injection Bypass
*   **Command Separators**: Utilizing different separators like `;`, `|`, `||`, `&&`, `%0a`.
*   **Whitespace Bypass**: Using `${IFS}`, `<` or `$IFS$9` instead of spaces.
*   **Variable Expansion**: Constructing commands using environment variables (e.g., `/bin/c$@at /etc/pa$@sswd`).

## 4. Path Traversal Bypass
*   **Encoding**: Using URL encoding (`%2e%2e%2f`), double URL encoding (`%252e%252e%252f`), or Unicode encoding.
*   **Path Truncation**: Appending null bytes (`%00`) or excessively long strings to bypass extension checks.
