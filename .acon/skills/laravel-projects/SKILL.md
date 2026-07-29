---
name: laravel-projects
description: Master skill for Laravel 13.x and Filament 5.x projects. Provides quick reference to Laravel and Filament docs, commands, stack dependencies (PHP 8.2+, Filament 5.3+, Laravel 13.0+), and architectural standards.
license: MIT
metadata:
  version: "1.1.0"
  php: "^8.2"
  filament: "^5.3"
  laravel: "^13.0"
---

# Laravel Projects Master Skill

Use this skill when working on any Laravel application (Filament admin panels, Inertia Vue/React, Livewire 3, or RESTful/GraphQL APIs).

## Technical Stack & Version Specifications

```json
{
  "php": "^8.2",
  "filament/filament": "^5.3",
  "laravel/framework": "^13.0"
}
```

---

## Architectural Conventions & Guidelines

1. **Action Classes & Domain Isolation**: Keep controllers and Filament Resource classes lightweight. Encapsulate business workflows into single-purpose **Action** classes (e.g. `CreateOrderAction`).
2. **FormRequest Validation**: Use dedicated `FormRequest` classes for input validation rather than inline controller validation.
3. **Strict Eloquent Typing**: Declare strict return types on Eloquent relationship methods (`BelongsTo`, `HasMany`).
4. **Filament 5.x Component Practices**: Declare form schemas in `form(Form $form)` and table columns/actions in `table(Table $table)`.

---

## Sub-Skills & Documentation Links

- **Laravel 13.x**: [`laravel/v13.x/SKILL.md`](laravel/v13.x/SKILL.md) (Official docs in [`laravel/v13.x/docs/`](laravel/v13.x/docs/))
- **Filament 5.x**: [`filament/v5.x/SKILL.md`](filament/v5.x/SKILL.md) (Official docs in [`filament/v5.x/docs/`](filament/v5.x/docs/))
- **Command Reference**: [`commands.md`](commands.md) (Artisan, Filament, Composer, NPM, Pest)
