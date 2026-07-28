# ASP.NET Core & C# Security Audit Guide

Security review patterns for .NET applications.

## 1. SQL Injection (Entity Framework Core)
EF Core uses parameterization by default, but raw SQL methods can be vulnerable.

*   **Sinks to Check:** `FromSqlRaw()`, `ExecuteSqlRaw()`.
*   **Vulnerable Pattern:** String interpolation or concatenation in raw SQL methods.
    ```csharp
    // BAD
    var users = context.Users.FromSqlRaw("SELECT * FROM Users WHERE Name = '" + userInput + "'");
    ```
*   **Secure Pattern:** Use `FromSqlInterpolated()` which automatically parameterizes interpolated strings, or pass parameters explicitly to `FromSqlRaw()`.
    ```csharp
    // GOOD
    var users = context.Users.FromSqlInterpolated($"SELECT * FROM Users WHERE Name = {userInput}");
    ```

## 2. Insecure Deserialization (BinaryFormatter & JSON.NET)
Deserializing untrusted data can lead to Remote Code Execution.

*   **Sinks to Check:** `BinaryFormatter.Deserialize()`, `JsonConvert.DeserializeObject()` (with specific settings).
*   **Vulnerable Pattern:** Using `BinaryFormatter` (which is inherently unsafe and deprecated).
*   **Vulnerable Pattern (JSON.NET):** Setting `TypeNameHandling = TypeNameHandling.All` or `Auto` allows the attacker to specify arbitrary types to instantiate during deserialization.
    ```csharp
    // BAD
    var settings = new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All };
    var obj = JsonConvert.DeserializeObject(userInput, settings);
    ```
*   **Secure Pattern:** Avoid `BinaryFormatter`. In JSON.NET, use `TypeNameHandling.None` (the default) or strictly validate allowed types using a custom `ISerializationBinder`.

## 3. Authorization Policies (`[Authorize]`)
Ensure endpoints are properly protected.

*   **Check:** Verify that sensitive controllers and actions have the `[Authorize]` attribute.
*   **Check:** Ensure custom Authorization Policies are correctly implemented and evaluated.
*   **Vulnerable Pattern:** Missing `[Authorize]` on administrative endpoints, or policies that fail to check the correct claims/roles.

## 4. Cross-Site Request Forgery (CSRF / Anti-Forgery)
ASP.NET Core provides built-in mechanisms for CSRF protection.

*   **Check:** Ensure `[ValidateAntiForgeryToken]` is applied to state-changing actions (POST, PUT, DELETE), or that the global `AutoValidateAntiforgeryTokenAttribute` filter is active.
*   **Vulnerable Pattern:** Forms submitted without an anti-forgery token, or API endpoints relying solely on cookie authentication without CSRF protections.
