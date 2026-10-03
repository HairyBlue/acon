# Mutation Testing

## Purpose
Proves tests have teeth. Surviving mutants indicate gaps.

## Scope
- Required for Plan-Required business-logic (monetary, auth, state machines, validators, crypto).
- Skip for UI, CRUD, glue.
- Additive to Pragmatic Testing Gate.

## Tools
- **Python**: `mutmut`, `cosmic-ray`
  - Install: `pip install mutmut`
  - Run: `mutmut run`
- **JS/TS**: `Stryker`
  - Install: `npm install -D @stryker-mutator/core`
  - Run: `npx stryker run`
- **PHP**: `Infection`
  - Install: `composer require --dev infection/infection`
  - Run: `vendor/bin/infection`
- **Rust**: `cargo-mutants`
  - Install: `cargo install cargo-mutants`
  - Run: `cargo mutants`

## Config
- Configurable minimum score (70%).
- Narrow scope.
- Timeout multiplier.

## Integration
- Optional gate triggered by G2 for [HUMAN-CORE].
- Report surviving mutants to Test & QA Engineer.
- Does not block G8/G9.
- Captain can override.

## Report Format
- file, line, type, original, mutated, summary stats.
- Inline in Bearings digest.

## Caveats
- Computationally expensive, false survivors common, don't require 100%.
