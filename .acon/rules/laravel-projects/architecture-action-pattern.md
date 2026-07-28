---
paths:
  - "app/Actions/**/*.php"
  - "app/Services/**/*.php"
title: Single-Responsibility Action Pattern
impact: HIGH
impactDescription: Encapsulates domain logic into reusable, testable single-purpose classes.
tags: architecture, actions, domain, refactoring
---

# Single-Responsibility Action Pattern

**Impact: HIGH**

Encapsulate business workflows into single-purpose **Action** classes. Each Action class should perform one clear domain operation and expose an `execute()` method.

## Action Guidelines:
- Place Action classes under `App\Actions` or domain subfolders (`App\Actions\Users\CreateUserAction`).
- Expose a public `execute(...)` method with strict typing.
- Wrap database state changes inside `DB::transaction(...)` when multiple models are mutated.

## Code Example:

```php
declare(strict_types=1);

namespace App\Actions\Users;

use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

final class CreateUserAction
{
    /**
     * @param array{name: string, email: string, password: string} $data
     */
    public function execute(array $data): User
    {
        return DB::transaction(function () use ($data): User {
            $user = User::create([
                'name' => $data['name'],
                'email' => $data['email'],
                'password' => Hash::make($data['password']),
            ]);

            // Dispatch domain events or background jobs
            event(new UserRegisteredEvent($user));

            return $user;
        });
    }
}
```
