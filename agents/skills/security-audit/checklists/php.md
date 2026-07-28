# PHP & Laravel / WordPress Security Checklist

## D1: Injection
- **SQL Injection**:
  - Raw string concatenation in `$pdo->query("... $user_input ...")` or `mysqli_query()`.
  - Laravel: User input passed to `DB::raw()`, `whereRaw()`, `orderByRaw()`, `havingRaw()`.
- **Command Injection**:
  - User input passed directly to `exec()`, `system()`, `shell_exec()`, `passthru()`, `popen()`, or backtick operator ``` ` ```.
- **Code Execution**:
  - `eval()`, `assert()`, or `preg_replace()` with `/e` modifier operating on untrusted input.
- **File Inclusion (LFI / RFI)**:
  - `include`, `require`, `include_once`, `require_once` receiving un-sanitized variable paths (`include $_GET['page']`).

## D2: Authentication
- **Session Management**: Missing `session_regenerate_id()` call immediately following successful user authentication.
- **Weak Password Checks**: Using loose equality `==` or `strcmp()` for password hash comparisons (vulnerable to type confusion / null return bypass).
- **Missing Middleware**: Laravel routes missing `auth` or `auth:sanctum` middleware guards on API endpoints.

## D3: Authorization (IDOR)
- **Object Ownership**: Fetching models directly via `Model::find($id)` without verifying `$id` belongs to `auth()->user()`.
- **Inconsistent Access**: Read endpoints guarded by policy, but `destroy` or `update` actions missing policy checks.

## D4: Insecure Deserialization
- **Unsafe Unserialize**: Passing untrusted data (from Cookie, URL, DB) to `unserialize()` without `allowed_classes => false`.
- **Phar Deserialization**: Passing user-controlled paths (`phar://`) to file functions like `file_exists()`, `is_file()`, or `fopen()`.

## D5: File Operations & Uploads
- **File Uploads**: Validating only `$_FILES['type']` (MIME spoofable) instead of verifying strict extension whitelist (`.jpg`, `.png`).
- **WebShell Risk**: Uploading files directly into publicly accessible directories (`public/uploads/`) with executable extension preservation.
- **Path Traversal**: `file_get_contents()`, `readfile()`, `unlink()` receiving paths with un-sanitized `../` sequences.

## D6: Server-Side Request Forgery (SSRF)
- **Outbound HTTP**: Passing user-supplied URLs to `curl_exec()`, `file_get_contents()`, or Guzzle without validating against internal IP ranges (`127.0.0.1`, `169.254.169.254`).

## D7: Cryptography & Randomness
- **Weak Randomness**: Using `rand()` or `mt_rand()` for generating security tokens or password reset keys (use `random_bytes()` or `random_int()`).
- **Hardcoded Secrets**: Storing `APP_KEY`, API secrets, or DB credentials directly in PHP files instead of `.env`.

## D8: Security Configuration
- **Production Debugging**: `APP_DEBUG=true` enabled in production (exposing environment variables via Ignition error pages).
- **Exposed Files**: Direct Web access to `.env`, `.git`, or backup files (`.bak`, `.sql`).

## D9: Business Logic & Mass Assignment
- **Mass Assignment**: Invoking `Model::create($request->all())` without explicit `$fillable` property guards.
- **Loose Type Comparisons**: `in_array($input, $array)` without setting strict parameter to `true` (`in_array("1abc", [1, 2])` evaluates to `true`).
