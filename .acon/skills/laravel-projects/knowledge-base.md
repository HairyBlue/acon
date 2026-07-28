# Knowledge Base - Laravel & Filament Domain Knowledge

This document provides technical stack context, dependency specifications, and conventions for working with `laravel-projects`.

---

## Technical Stack & Version Specifications

```json
{
  "php": "^8.2",
  "filament/filament": "^5.3",
  "laravel/framework": "^13.0"
}
```

### Scope & Flexibility

`laravel-projects` is a generic agent collection suitable for **any Laravel application**. Supported stack paradigms include:
- **Filament Admin Panels**: Filament v5.x resources, pages, widgets, form schemas, and table builders.
- **Inertia.js Monoliths**: Vue 3 or React frontends integrated via `@inertiajs/inertia-laravel`.
- **Livewire 3 Applications**: Full-stack interactive components powered by Alpine.js.
- **API Services**: RESTful or GraphQL endpoints utilizing Eloquent API Resources, Sanctum/Passport authentication, and JSON responses.

---

## Architectural Patterns & Conventions

### 1. Action Classes & Domain Isolation
- Keep Controllers and Filament Resource classes lightweight.
- Encapsulate business workflows into single-purpose **Action** classes (e.g., `CreateOrderAction`, `ProcessPaymentAction`).

### 2. Request Validation
- Use dedicated **FormRequest** classes for validation rather than inline validation inside controllers.
- Ensure strict typehints and return types on all methods.

### 3. Database & Eloquent
- Use strict types and declare proper return types for Eloquent relationships (`BelongsTo`, `HasMany`, etc.).
- Always write migration scripts that support clean rollbacks.

### 4. Filament 5.x Component Practices
- Declare form schemas inside `form(Form $form): Form` using Filament components (`TextInput`, `Select`, `Toggle`, etc.).
- Declare table columns, filters, and actions inside `table(Table $table): Table`.
- Utilize Filament Infolists for read-only record views.

---

## Environment & Configuration

- Use `.env.example` as the canonical template for environment keys.
- Store private credentials in `.env` and never commit secrets to version control.
