---
paths:
  - "app/Models/**/*.php"
  - "database/migrations/**/*.php"
title: Eloquent Model Standards & Relationship Typing
impact: HIGH
impactDescription: Prevents runtime errors, N+1 query bugs, and broken database relationships.
tags: data, database, eloqent, models, migrations
---

# Eloquent Model Standards & Relationship Typing

**Impact: HIGH**

Eloquent models must enforce strict typehints, explicit relationship return types, and clean migration rollbacks.

## Model Rules:
- Always declare strict return types on Eloquent relationship methods (`BelongsTo`, `HasMany`, `BelongsToMany`, `HasOne`).
- Use `$casts` property or `casts()` method to cast JSON, dates, booleans, and enums.
- Eager-load relationships when fetching collections to prevent N+1 queries (`User::with('posts')->get()`).

## Migration Rules:
- Foreign keys must declare cascading rules (`onDelete('cascade')` or `nullOnDelete()`).
- Always write reversible migrations with matching `down()` methods.

## Code Example:

```php
declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

final class Post extends Model
{
    protected function casts(): array
    {
        return [
            'published_at' => 'datetime',
            'is_featured' => 'boolean',
        ];
    }

    public function author(): BelongsTo
    {
        return $this->belongsTo(User::class, 'author_id');
    }

    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);
    }
}
```
