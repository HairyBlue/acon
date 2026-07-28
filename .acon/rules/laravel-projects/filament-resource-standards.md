---
paths:
  - "app/Filament/**/*.php"
title: Filament v5.x Resource & UI Standards
impact: HIGH
impactDescription: Ensures consistent admin UI components, clean resource pages, and optimized queries.
tags: filament, ui, admin, resources, forms, tables
---

# Filament v5.x Resource & UI Standards

**Impact: HIGH**

Build Filament v5.x resources using strongly-typed form components, structured tables, infolists, and separated page classes.

## Resource Standards:
- Place resource pages in `App\Filament\Resources\UserResource\Pages` (`ListUsers`, `CreateUser`, `EditUser`, `ViewUser`).
- Declare form schemas using `Filament\Forms\Components` (`TextInput`, `Select`, `Toggle`, `Section`).
- Declare table columns using `Filament\Tables\Columns` (`TextColumn`, `IconColumn`, `ImageColumn`).
- Eager load relationship data on tables (`modifyQueryUsing(fn ($query) => $query->with(['role', 'department']))`).
- Use Filament `Infolists` for read-only record views rather than disabling form fields.

## Code Example:

```php
public static function form(Form $form): Form
{
    return $form
        ->schema([
            Forms\Components\Section::make('User Details')
                ->schema([
                    Forms\Components\TextInput::make('name')
                        ->required()
                        ->maxLength(255),
                    Forms\Components\TextInput::make('email')
                        ->email()
                        ->required()
                        ->unique(ignoreRecord: true),
                ])->columns(2),
        ]);
}
```
