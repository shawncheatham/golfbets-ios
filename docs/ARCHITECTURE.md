# Architecture (draft)

## Principles
- Local-first: persistence lives on-device; no account required.
- Thin UI: domain/game logic is pure Swift (testable).
- Single source of truth: `AppStore` owns state; views read/dispatch.

## Modules (folders)
- `Domain/`
  - `GameType`, `Player`, `Round`
  - `computeSkins`, `computeWolf`, `computeBBB` (ported from web)
- `Store/`
  - `AppStore: ObservableObject`
  - `RoundRepository` for load/save JSON
- `UI/`
  - `GamePickerView`
  - `SetupView`
  - `QuickEntryView`
  - `StandingsView`
  - `ShareSheet`

## Persistence
- JSON file stored under Application Support.
- Keep schema versioned (e.g., `v1`).

## Share
- Use `ShareLink` where possible; fallback to a UIKit `UIActivityViewController` wrapper.
