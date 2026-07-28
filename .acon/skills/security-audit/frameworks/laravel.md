# Laravel Security Audit Guide

When auditing Laravel applications, focus on these common framework-specific vulnerability patterns.

## 1. SQL Injection (Eloquent & Query Builder)
While Eloquent protects against SQLi by default, raw queries introduce SQLi risks.

*   **Sinks to Check:** `DB::raw()`, `->selectRaw()`, `->whereRaw()`, `->havingRaw()`, `->orderByRaw()`.
*   **Vulnerable Pattern:**
    ```php
    // BAD
    User::whereRaw("name = '" . request('name') . "'")->get();
    ```
*   **Secure Pattern:** Use parameter binding.
    ```php
    // GOOD
    User::whereRaw('name = ?', [request('name')])->get();
    ```

## 2. Mass Assignment
Mass assignment occurs when a user updates unintended database columns by sending unexpected HTTP parameters.

*   **Sinks to Check:** `User::create($request->all())`, `$user->update($request->all())`.
*   **Vulnerable Pattern:** Missing or misconfigured `$fillable` or `$guarded` properties on Eloquent models.
*   **Secure Pattern:** Always explicitly define `$fillable` to restrict which attributes can be mass-assigned, or use `$request->validated()` with Form Requests.

## 3. Cross-Site Scripting (XSS) in Blade
Blade automatically escapes output using `{{ $variable }}`, but raw output tags do not.

*   **Sinks to Check:** `{!! $variable !!}`
*   **Vulnerable Pattern:** Outputting user-controlled data using raw tags.
    ```blade
    <!-- BAD if $userInput is untrusted -->
    {!! $userInput !!}
    ```
*   **Secure Pattern:** Always use `{{ }}` for untrusted data. Only use `{!! !!}` when rendering intentionally trusted HTML.

## 4. Insecure Deserialization
PHP's native `unserialize()` can lead to Remote Code Execution (RCE) if an attacker can control the serialized string and suitable "gadget chains" exist.

*   **Sinks to Check:** `unserialize()`.
*   **Vulnerable Pattern:**
    ```php
    // BAD
    $data = unserialize($request->cookie('data'));
    ```
*   **Secure Pattern:** Use JSON (`json_decode()`) for serialization of data structures instead of PHP serialization.

## 5. Environment Exposure
Ensure sensitive configuration is not exposed.
*   Check if `.env` files are accessible via the web server (misconfigured document root).
*   Check for `APP_DEBUG=true` in production, which can leak sensitive stack traces and credentials on error pages.
