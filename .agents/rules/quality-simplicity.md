---
paths:
  - "**/*"
title: Keep Code Simple & Verify via Automated Tests
impact: HIGH
impactDescription: Prevents over-engineering, unhandled regressions, and dead code accumulation.
tags: quality, simplicity, testing, refactoring
---

# Keep Code Simple & Verify via Automated Tests

**Impact: HIGH**

Write simple, maintainable code. Never over-engineer solutions, and never declare work complete without test verification.

## Quality Rules:
- **No Leftover Debugging**: Remove all `dd()`, `dump()`, `ray()`, `var_dump()`, and `console.log()` statements before finalizing code.
- **Zero Dead Code**: Delete unused imports, commented-out logic blocks, and orphan helper functions.
- **Mandatory Test Verification**: Run Pest / PHPUnit tests (`./vendor/bin/pest` or `php artisan test`) after writing or refactoring code.
- **Strict Typing**: Add `declare(strict_types=1);` to all newly created PHP files.
