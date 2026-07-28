---
name: laravel-13x
description: Agent skill for Laravel 13.x development. Provides guidelines, best practices, and indexed access to official Laravel 13.x documentation files located in docs/.
license: MIT
metadata:
  version: "13.x"
  php: "^8.2"
  laravel: "^13.0"
---

# Laravel 13.x Agent Skill

Use this skill when developing, refactoring, or debugging Laravel 13.x applications.

## Official Documentation Index

Official Laravel 13.x markdown documentation is stored locally in [`docs/`](docs/). Key reference files include:

- **Routing & Controllers**: [`docs/routing.md`](docs/routing.md), [`docs/controllers.md`](docs/controllers.md), [`docs/middleware.md`](docs/middleware.md)
- **Database & Eloquent**: [`docs/eloquent.md`](docs/eloquent.md), [`docs/eloquent-relationships.md`](docs/eloquent-relationships.md), [`docs/migrations.md`](docs/migrations.md), [`docs/queries.md`](docs/queries.md)
- **Authentication & Security**: [`docs/authentication.md`](docs/authentication.md), [`docs/authorization.md`](docs/authorization.md), [`docs/sanctum.md`](docs/sanctum.md)
- **Validation & Requests**: [`docs/validation.md`](docs/validation.md), [`docs/requests.md`](docs/requests.md)
- **Testing**: [`docs/testing.md`](docs/testing.md), [`docs/http-tests.md`](docs/http-tests.md), [`docs/database-testing.md`](docs/database-testing.md)
- **Queues & Jobs**: [`docs/queues.md`](docs/queues.md)
- **Artisan & Console**: [`docs/artisan.md`](docs/artisan.md)
- **MCP Integration**: [`docs/mcp.md`](docs/mcp.md)

## Core Guidelines

1. **Strict Type Hinting**: Use PHP 8.2+ strict typing (`declare(strict_types=1);`), property types, parameter types, and method return types.
2. **Eloquent Relationships**: Always specify explicit return types on Eloquent relationship methods:
   ```php
   public function posts(): HasMany
   {
       return $this->hasMany(Post::class);
   }
   ```
3. **Form Request Validation**: Validate input using dedicated `FormRequest` classes.
4. **Action Classes**: Prefer dedicated action classes for business logic over bloated controllers or models.
5. **Testing**: Write Pest or PHPUnit tests for all business actions and endpoints.
