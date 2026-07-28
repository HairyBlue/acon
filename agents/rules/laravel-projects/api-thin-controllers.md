---
paths:
  - "app/Http/Controllers/**/*.php"
  - "app/Http/Requests/**/*.php"
title: Keep Controllers Thin - HTTP Concerns Only
impact: HIGH
impactDescription: Keeps business logic decoupled from HTTP transport and simplifies testing.
tags: api, controllers, http, requests
---

# Keep Controllers Thin - HTTP Concerns Only

**Impact: HIGH**

Controllers must handle only HTTP concerns: taking requests, delegating execution to Action/Service classes, and returning formatted responses or views.

## Controller Responsibilities (ONLY these):
- Validate incoming requests via dedicated `FormRequest` classes.
- Extract request inputs and pass parameters to domain Action classes.
- Call appropriate Action or Service methods.
- Return HTTP responses, JSON resources (`UserResource`), or views with status codes.

## Controllers Should NOT:
- Contain core business rules or complex calculations.
- Directly write raw database queries or complex transactions.
- Perform inline validation using `$request->validate([...])`. Use FormRequests instead.

## Code Example:

### Correct:
```php
public function store(StoreUserRequest $request, CreateUserAction $createUser): JsonResponse
{
    $user = $createUser->execute($request->validated());

    return new UserResource($user);
}
```

### Incorrect:
```php
public function store(Request $request): JsonResponse
{
    // Anti-pattern: Inline validation inside controller
    $validated = $request->validate(['name' => 'required']);

    // Anti-pattern: Business logic & DB transactions inside controller
    $user = User::create($validated);
    Mail::to($user)->send(new WelcomeMail());

    return response()->json($user);
}
```
