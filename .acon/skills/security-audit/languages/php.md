# Deep PHP Language Security Guide

## 1. PHP Loose Type Comparisons & Type Confusion
PHP's dynamic type system uses loose comparison (`==`) by default, leading to critical authentication and logic bypasses.

### Hash Comparison Collision (Magic Hashes)
When comparing string hashes using `==`, strings starting with `0e` followed by numbers are evaluated as scientific notation floats (`0e12345` == `0`).

```php
// ❌ Dangerous: Loose comparison of hashes
if (md5($user_input) == $stored_hash) {
    // If md5($user_input) is "0e123..." and $stored_hash is "0e456...",
    // "0e123..." == "0e456..." evaluates to TRUE!
}

// ✓ Secure: Strict type comparison or hash_equals()
if (hash_equals($stored_hash, md5($user_input))) {
    // Safe timing-attack resistant comparison
}
```

### String vs Integer Comparisons
In PHP < 8.0, comparing a string to an integer converts the string to an integer: `"100admin" == 100` is `true`.

```php
// ❌ Loose comparison in array checking
if (in_array($user_input, [1, 2, 3])) {
    // If $user_input is "1admin", in_array() returns TRUE without strict mode!
}

// ✓ Secure: Strict in_array comparison
if (in_array($user_input, [1, 2, 3], true)) {
    // Checks both value AND type
}
```

---

## 2. PHP Object Injection & Unsafe Deserialization
Calling `unserialize()` on untrusted input allows attackers to inject arbitrary PHP objects, triggering magic methods (`__wakeup()`, `__destruct()`, `__toString()`).

### Gadget Chain Execution
Frameworks like Laravel and Symfony contain classes with dangerous magic methods (e.g., deleting files, executing commands upon destruction).

```php
// ❌ Dangerous: Unserializing user-supplied Cookie or Input
$user_data = unserialize($_COOKIE['session_data']);

// ✓ Secure: Use JSON for data exchange
$user_data = json_decode($_COOKIE['session_data'], true);

// ✓ Secure: Restrict allowed classes if unserialize is required
$user_data = unserialize($_COOKIE['session_data'], ['allowed_classes' => false]);
```

---

## 3. Phar Stream Wrapper Deserialization
PHP file functions (`file_exists()`, `is_file()`, `filesize()`, `fopen()`) parse metadata when called with the `phar://` protocol stream wrapper, automatically triggering `unserialize()` without calling `unserialize()` directly.

```php
// ❌ Dangerous: User-controlled file path passed to file_exists()
$path = $_GET['file']; // Attack payload: "phar://uploads/avatar.jpg"
if (file_exists($path)) {
    // Triggers Phar metadata deserialization & RCE!
}

// ✓ Secure: Validate path scheme and reject phar:// wrappers
if (str_starts_with(strtolower($path), 'phar://')) {
    throw new InvalidArgumentException("Phar stream wrapper not allowed");
}
```

---

## 4. Variable Overriding (`extract` & `parse_str`)
Functions that import array keys directly into the current symbol table can overwrite local variables (e.g. `$isAdmin`, `$db_config`).

```php
// ❌ Dangerous: Importing POST variables into local scope
extract($_POST); // If POST contains isAdmin=1, local $isAdmin is overwritten!

// ✓ Secure: Do not extract user data into local variable scope. Access explicitly via array keys.
```
