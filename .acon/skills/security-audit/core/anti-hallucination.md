# Anti-Hallucination Guidelines

When performing AI-assisted security audits, it is critical to adhere to evidence-based reporting to prevent hallucinations (false claims or fabricated code).

## 1. Strict Evidence Requirements
Every reported vulnerability **MUST** be backed by concrete evidence from the source code.

*   **Line Numbers:** Always provide exact file paths and line numbers for the source, the sink, and key points in the data flow.
*   **Verified Sinks:** Only report vulnerabilities when a known, dangerous sink is explicitly present in the code. Do not assume a function is vulnerable without verifying its implementation.
*   **Actual Data Flows:** You must prove that the data actually flows from the source to the sink. Do not assume connectivity.

## 2. "Show, Don't Tell"
Instead of simply stating a vulnerability exists, demonstrate it by citing the code.

**Bad (Hallucination Risk):**
> "The application is vulnerable to SQL injection because user input is passed to the database."

**Good (Evidence-Based):**
> "In `app/Controllers/UserController.php` on line 45, the `$_GET['username']` source is directly concatenated into the SQL query at line 50 (`$db->query("SELECT * FROM users WHERE user = '$username'")`), resulting in SQL Injection."

## 3. Handling Ambiguity
If you cannot definitively trace the data flow or verify the sink:

*   **Do Not Report as a Definite Vulnerability:** Report it as a "Potential Risk" or "Area for Manual Review".
*   **State the Missing Information:** Clearly explain what prevents you from confirming the vulnerability (e.g., "The definition of the `sanitizeInput()` function could not be found, so it is unclear if the data is safe.").

## 4. Prohibition on Fabricating Code
*   **Never invent code snippets** that do not exist in the provided repository.
*   When citing code, use the exact syntax found in the files.
*   Do not hallucinate framework versions or dependencies unless explicitly stated in configuration files (e.g., `package.json`, `composer.json`).
