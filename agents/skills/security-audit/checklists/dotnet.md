# C# / .NET Core & ASP.NET Security Checklist

## D1: Injection
- **SQL Injection**:
  - String concatenation in Entity Framework: `DbContext.Database.ExecuteSqlRaw($"SELECT * FROM Users WHERE Name = '{input}'")` or `FromSqlRaw()`.
  - Raw `SqlCommand` text concatenation without `SqlParameter`.
- **Command Injection**:
  - Concatenating user input into `ProcessStartInfo.Arguments` or `Process.Start("cmd.exe", "/c " + input)`.
- **XXE (XML External Entity)**:
  - Using `XmlDocument` or `XmlTextReader` with `XmlResolver` not set to `null` (`DtdProcessing.Parse`).

## D2: Authentication
- **ASP.NET Core Identity**:
  - Controllers/Actions missing `[Authorize]` attribute.
  - JWT Authentication missing `ValidateIssuerSigningKey = true`, `ValidateLifetime = true`, or `ClockSkew`.

## D3: Authorization (IDOR)
- **Object Access**:
  - Fetching entities via `_context.Orders.FirstOrDefaultAsync(o => o.Id == id)` without verifying `UserId == currentUserId`.
- **Missing Policy Guards**:
  - Endpoint guarded by `[Authorize]` but missing specific role or claim policy check (`[Authorize(Policy = "AdminOnly")]`).

## D4: Insecure Deserialization
- **Unsafe BinaryFormatter**:
  - Using `BinaryFormatter.Deserialize()`, `NetDataContractSerializer`, or `JavaScriptSerializer` on untrusted data stream (Critical RCE risk).
- **TypeNameHandling in Newtonsoft.Json**:
  - Configuring `JsonSerializerSettings.TypeNameHandling = TypeNameHandling.All` or `Auto` when deserializing user JSON.

## D5: File Operations & Path Traversal
- **Path Traversal**:
  - `File.OpenRead()`, `File.Delete()`, or `Path.Combine()` operating on user-supplied paths without checking `Path.GetFullPath()` against base directory.
- **Zip Slip**:
  - Extracting zip archives via `ZipFile.ExtractToDirectory()` without sanitizing `ZipArchiveEntry.FullName`.

## D6: SSRF
- **Outbound HTTP**:
  - Passing user-supplied URLs to `HttpClient.GetAsync()` or `WebRequest.Create()` without validating target host against private IP ranges (`127.0.0.1`, `169.254.169.254`).

## D7: Cryptography & Secrets
- **Hardcoded Secrets**: Storing connections strings, JWT keys, or API tokens in `appsettings.json` or C# code instead of Azure Key Vault / Environment Variables.
- **Weak Randomness**: Using `System.Random` for generating cryptographic tokens (use `RandomNumberGenerator.Create()`).

## D8: Security Configuration
- **Production Exception Pages**:
  - Enabling `app.UseDeveloperExceptionPage()` in production environments.
- **Missing Anti-Forgery Tokens**:
  - ASP.NET MVC POST forms missing `[ValidateAntiForgeryToken]` attribute.

## D9: Business Logic & Mass Assignment
- **Over-Posting / Mass Assignment**:
  - Binding HTTP POST request body directly to Entity Framework data models instead of using dedicated DTOs / ViewModels.
