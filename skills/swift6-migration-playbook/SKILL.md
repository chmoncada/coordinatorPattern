---
name: swift6-migration-playbook
description: End-to-end migration playbook for upgrading Swift projects to Swift 6 with minimal risk. Use when the user asks to migrate to Swift 6, enable strict concurrency/data-race safety, fix Sendable/actor-isolation diagnostics, stage migration target-by-target, or assess source-compatibility changes from Swift 5 to Swift 6.
---

# Swift 6 Migration Playbook

## Overview

Execute a phased migration to Swift 6 language mode with explicit checkpoints. Prioritize small, reviewable changes, preserving behavior while converging on compile-time data-race safety.

## Migration Workflow

### 1) Establish baseline before touching language mode

- Confirm the project builds and tests pass in its current mode.
- Detect settings from `Package.swift` and/or `.pbxproj`:
  - Swift language mode / `swift-tools-version`
  - `SWIFT_STRICT_CONCURRENCY`
  - `SWIFT_DEFAULT_ACTOR_ISOLATION`
  - `SWIFT_UPCOMING_FEATURE_*` (especially `NonisolatedNonsendingByDefault`)
- Capture a migration log with:
  - current compiler diagnostics count by category
  - modules/targets ordered by dependency depth and risk

### 2) Adopt concurrency checks incrementally in Swift 5 mode first

- Enable `StrictConcurrency` in a controlled scope before switching all code to Swift 6 mode.
- Fix diagnostics by isolation boundary, not by blanket annotations.
- Prefer these fixes (in order):
  - make shared mutable state actor-isolated
  - add `Sendable` to value-safe types
  - narrow `@MainActor` to genuinely UI-bound surfaces
  - convert callback APIs to `async` where practical
- Use escape hatches only with explicit invariants and TODO removal plans:
  - `@preconcurrency`
  - `@unchecked Sendable`
  - `nonisolated(unsafe)`

### 3) Switch selected targets to Swift 6 language mode

- Migrate low-risk leaf targets first, then move upward.
- After each target switch:
  - build that target and dependents
  - run relevant tests
  - document remaining blockers and ownership
- Keep PRs small and reversible.

### 4) Resolve source-compatibility breakpoints

- Check Swift 6 feature migrations likely to break source:
  - `@unknown default` requirement on non-frozen enums
  - trailing closure matching changes
  - global variable concurrency checks
  - isolated default values
  - dynamic actor isolation runtime assertions
- Use official proposal links in `references/official-links.md` for exact semantics.

### 5) Dependency and boundary strategy

- If a dependency has not fully adopted Swift 6:
  - isolate boundary with adapter types/modules
  - mark imported API usage intentionally (`@preconcurrency` if unavoidable)
  - avoid spreading compatibility hacks through core domain code
- For public APIs, evaluate `@preconcurrency` to preserve older clients while improving Swift 6 safety.

### 6) Verification gates before declaring migration done

- Zero concurrency diagnostics in Swift 6 mode for migrated targets.
- Tests pass, including async/concurrency-sensitive suites.
- No unresolved runtime actor-isolation assertions in critical paths.
- Escapes (`@unchecked Sendable`, etc.) are tracked with owner and removal milestone.

## Diagnostic Triage Rules

- `non-Sendable crossing isolation`:
  - first, identify the crossing point
  - decide whether type-level `Sendable` or flow isolation redesign is correct
- `Main actor-isolated ... in nonisolated context`:
  - verify whether API truly must be UI-main-actor bound
  - otherwise redesign isolation boundary instead of force-hopping
- `closure isolation inferred incorrectly from legacy API`:
  - annotate closure `@Sendable` when crossing domains is possible
  - add explicit `Task`/`await` at call site when required

## Response Contract (when this skill is invoked)

Always provide:

1. Current-state intake:
- detected build/concurrency settings and confidence gaps

2. Phase plan:
- exact target order and why

3. Concrete edits:
- minimal diff approach with rationale per change

4. Verification:
- commands run
- what passed/failed
- remaining blockers

## References

- Use `references/official-links.md` for canonical migration docs and Swift Evolution mapping.
