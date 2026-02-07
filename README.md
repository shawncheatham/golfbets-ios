# golfbets-ios

Parallel iOS learning project for GolfBets.

## Goal
Clone one flow end-to-end as a **native shell**, keeping it **local-first**:

Choose game → setup → quick entry → standings → share sheet

## Non-goals (for now)
- Accounts / backend
- Multiplayer sync
- Cross-device persistence

## Target
- iOS 17+
- SwiftUI

## Suggested structure
- `Domain/` — models + game logic (pure Swift)
- `Store/` — app state + persistence (JSON file)
- `UI/` — SwiftUI screens

## Next step
Create an Xcode project in this folder:
- Product Name: `GolfBets`
- Interface: SwiftUI
- Language: Swift
- Deployment Target: iOS 17.0
- No Core Data

Once created, we’ll commit the Xcode project and start porting the web flow screen-by-screen.
