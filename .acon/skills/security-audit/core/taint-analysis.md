# Taint Analysis Guide

Taint analysis is the process of tracing untrusted data (sources) as it flows through an application to potentially dangerous functions (sinks) without adequate validation or sanitization.

## 1. Sources (Where Data Enters)
Sources are any locations where user-controlled or untrusted data enters the application context.

*   **HTTP Request Data:** `GET` / `POST` parameters, request body, headers (e.g., `User-Agent`, `Referer`), cookies.
*   **Database/External Systems:** Data retrieved from databases, external APIs, or file systems that may have been previously tampered with (Second-order vulnerabilities).
*   **Environment:** Environment variables or command-line arguments in certain execution contexts.

## 2. Sinks (Where Data is Executed)
Sinks are dangerous functions or operations that can cause harm if executed with malicious payloads.

*   **SQL Injection (SQLi):** `mysqli_query()`, `PDO::query()`, `DB::raw()`.
*   **Cross-Site Scripting (XSS):** `echo`, `print`, `innerHTML`, `document.write()`.
*   **Command Injection:** `system()`, `exec()`, `shell_exec()`, `child_process.exec()`.
*   **Code Injection:** `eval()`, `assert()`, `setTimeout()` (with string arguments).
*   **Path Traversal / LFI:** `include()`, `require()`, `file_get_contents()`, `fs.readFile()`.
*   **Insecure Deserialization:** `unserialize()`, `yaml.load()`, `pickle.loads()`.

## 3. Tracing Data Flows
To effectively perform taint analysis:

1.  **Identify the Source:** Locate where the user input is read.
2.  **Follow the Flow:** Trace the variable through assignments, function calls, and object properties. Pay attention to how the data is modified or passed around.
3.  **Check for Sanitizers:** Identify if the data passes through any sanitization or validation routines (e.g., escaping, type casting, allow-listing). If it is properly sanitized, the data is no longer "tainted".
4.  **Identify the Sink:** Check if the tainted data reaches a dangerous sink. If it does, a vulnerability exists.

## Example (PHP)
```php
// 1. Source
$userInput = $_GET['user_id'];

// 2. Flow (No sanitization)
$id = $userInput;

// 3. Sink (Vulnerable to SQL Injection)
$db->query("SELECT * FROM users WHERE id = " . $id);
```
