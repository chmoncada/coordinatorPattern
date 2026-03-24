# Swift 6 Migration Official Links

## Primary guide

- Swift Migration Guide (landing): https://www.swift.org/migration/documentation/migrationguide/
- Source repository for the migration docs (DocC): https://github.com/swiftlang/swift-migration-guide

## Guide chapters (source Markdown)

- Migration Guide overview: https://raw.githubusercontent.com/swiftlang/swift-migration-guide/main/Guide.docc/MigrationGuide.md
- Migration strategy: https://raw.githubusercontent.com/swiftlang/swift-migration-guide/main/Guide.docc/MigrationStrategy.md
- Enable data-race safety: https://raw.githubusercontent.com/swiftlang/swift-migration-guide/main/Guide.docc/EnableDataRaceSafety.md
- Incremental adoption: https://raw.githubusercontent.com/swiftlang/swift-migration-guide/main/Guide.docc/IncrementalAdoption.md
- Common problems: https://raw.githubusercontent.com/swiftlang/swift-migration-guide/main/Guide.docc/CommonProblems.md
- Data-race safety concepts: https://raw.githubusercontent.com/swiftlang/swift-migration-guide/main/Guide.docc/DataRaceSafety.md
- Source compatibility overview: https://raw.githubusercontent.com/swiftlang/swift-migration-guide/main/Guide.docc/SourceCompatibility.md
- Runtime behavior: https://raw.githubusercontent.com/swiftlang/swift-migration-guide/main/Guide.docc/RuntimeBehavior.md

## High-impact migration features and proposals

- `StrictConcurrency` (SE-0337): https://github.com/swiftlang/swift-evolution/blob/main/proposals/0337-support-incremental-migration-to-concurrency-checking.md
- `IsolatedDefaultValues` (SE-0411): https://github.com/swiftlang/swift-evolution/blob/main/proposals/0411-isolated-default-values.md
- `GlobalConcurrency` (SE-0412): https://github.com/swiftlang/swift-evolution/blob/main/proposals/0412-strict-concurrency-for-global-variables.md
- Region-based isolation (SE-0414): https://github.com/swiftlang/swift-evolution/blob/main/proposals/0414-region-based-isolation.md
- Dynamic actor isolation (SE-0423): https://github.com/swiftlang/swift-evolution/blob/main/proposals/0423-dynamic-actor-isolation.md
- Usability of global-actor-isolated types (SE-0434): https://github.com/swiftlang/swift-evolution/blob/main/proposals/0434-global-actor-isolated-types-usability.md

## Practical migration heuristics

- Prefer enabling strict checks before globally switching language mode.
- Migrate low-risk leaf targets first, then upstream targets.
- Avoid global `@MainActor` as a blanket fix; model real isolation boundaries.
- Treat `@preconcurrency` and `@unchecked Sendable` as temporary, tracked debt.
