---
name: filament-5x
description: Agent skill for Filament v5.x admin panel and UI development. Provides guidelines, component usage, and indexed access to official Filament 5.x documentation in docs/.
license: MIT
metadata:
  version: "5.x"
  filament: "^5.3"
  php: "^8.2"
---

# Filament v5.x Agent Skill

Use this skill when creating or modifying Filament v5.x admin panels, resources, pages, widgets, form schemas, tables, infolists, and actions.

## Official Documentation Index

Official Filament v5.x documentation is stored locally in [`docs/`](docs/). Key reference files include:

- **Getting Started**: [`docs/01-introduction/`](docs/01-introduction/), [`docs/02-getting-started.md`](docs/02-getting-started.md)
- **Panel Configuration**: [`docs/05-panel-configuration.md`](docs/05-panel-configuration.md)
- **Resources**: [`docs/03-resources/`](docs/03-resources/)
- **Navigation & Users**: [`docs/06-navigation/`](docs/06-navigation/), [`docs/07-users/`](docs/07-users/)
- **Styling & Components**: [`docs/08-styling/`](docs/08-styling/), [`docs/12-components/`](docs/12-components/)
- **Testing & Plugins**: [`docs/10-testing/`](docs/10-testing/), [`docs/11-plugins/`](docs/11-plugins/)
- **Deployment & Upgrade**: [`docs/13-deployment.md`](docs/13-deployment.md), [`docs/14-upgrade-guide.md`](docs/14-upgrade-guide.md)

## Core Guidelines

1. **Resource Architecture**:
   - Keep resources structured under `App\Filament\Resources`.
   - Separate list, create, and edit pages into `App\Filament\Resources\UserResource\Pages`.
2. **Form Schemas**:
   - Use strongly-typed Filament components inside `form(Form $form)`:
     ```php
     use Filament\Forms\Components\TextInput;
     use Filament\Forms\Components\Select;

     public static function form(Form $form): Form
     {
         return $form
             ->schema([
                 TextInput::make('name')->required()->maxLength(255),
                 TextInput::make('email')->email()->required(),
             ]);
     }
     ```
3. **Table Schemas**:
   - Use table columns (`TextColumn`, `IconColumn`), filters (`SelectFilter`, `TernaryFilter`), and actions (`EditAction`, `DeleteAction`).
4. **Widgets & Stats**:
   - Use Stats Overview widgets for dashboard metrics.
