<dotnet-asp-guidelines>
=== foundation rules ===

# .NET & ASP.NET Core Guidelines

The .NET and ASP.NET Core guidelines are specifically curated for this application to ensure robust, enterprise-grade C# services.

## Foundational Context

This application is a .NET 8/9 ASP.NET Core application running on C# 12/13. Always use APIs that match the installed framework and package versions — do not assume a version.

Before relying on a package's API, confirm its installed version:
- SDK version: run `dotnet --version` or `dotnet --info`.
- Packages: check `.csproj` or run `dotnet list package`.

## Skills Activation

This project has domain-specific skills available in `**/skills/**`. You MUST activate the relevant skill whenever you work in that domain—don't wait until you're stuck.

## Conventions

- Follow all existing code conventions in this application. When creating or editing a file, check sibling files for structure, naming, and patterns.
- Use explicit, descriptive names for classes, interfaces, and methods (`GetUserByIdAsync`, not `GetUser()`).
- Reuse existing MediatR handlers, repository abstractions, validators, and extension methods before authoring new ones.

## Verification Scripts

- Do not create standalone console apps or ad-hoc scripts when automated unit and integration tests prove functionality. Automated tests are the primary source of truth.

## Application Structure & Architecture

- Follow Clean Architecture / Vertical Slice Architecture:
  - **Presentation / API**: Controllers or Minimal API endpoints, routing, status codes, OpenAPI annotations.
  - **Application / Core**: Commands, queries, MediatR handlers, FluentValidation rules, DTOs.
  - **Domain**: Entities, value objects, domain events, business invariants.
  - **Infrastructure**: Entity Framework Core `DbContext`, migrations, external API clients, repositories.
- Stick to the existing directory layout; do not create arbitrary base folders without approval.
- Do not modify `.csproj` dependencies without approval.

## Documentation Files

- You must only create documentation files if explicitly requested by the user.

## Replies

- Be concise in your explanations - focus on architectural decisions and non-obvious details rather than repeating boilerplate code.

=== csharp rules ===

# C# Standards

- **Modern C# Idioms**: Use primary constructors, collection expressions (`[...]`), file-scoped namespaces (`namespace MyProject.Users;`), and pattern matching.
- **Nullable Reference Types**: Keep nullable reference types enabled (`<Nullable>enable</Nullable>`). Never suppress warnings with `!` unless null checks have been thoroughly proven.
- **Asynchronous Programming**: Always use `async Task` / `async Task<T>` with `CancellationToken` propagation. Never use `.Result` or `.Wait()`.

=== efcore rules ===

# Entity Framework Core & Data Standards

- **Read-Only Queries**: Always append `.AsNoTracking()` for read-only queries to prevent change tracker overhead.
- **Avoid N+1 & Client Evaluation**: Use `.Include()` / `.ThenInclude()` or project directly into DTOs via `.Select()`.
- **Transactions**: Wrap multi-aggregate or multi-table updates in an explicit transaction (`using var transaction = await context.Database.BeginTransactionAsync();`).
- **Migrations**: Generate and apply migrations via dotnet CLI (`dotnet ef migrations add <Name>`, `dotnet ef database update`).

=== testing rules ===

# Testing (xUnit / NUnit)

- This project uses xUnit with FluentAssertions and Moq/NSubstitute.
- Unit tests cover domain logic and application handlers in isolation.
- Integration tests use `WebApplicationFactory<Program>` with a test database container or in-memory provider.
- Run tests narrowly during development:
  ```bash
  dotnet test --filter "FullyQualifiedName~UserControllerTests"
  ```
- Do not delete or disable existing tests without approval.

=== formatting rules ===

# Code Formatter & Linter

- Run formatting before finalizing changes:
  ```bash
  dotnet format
  ```

</dotnet-asp-guidelines>
