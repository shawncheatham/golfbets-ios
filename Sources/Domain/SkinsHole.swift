import Foundation

struct SkinsHole: Codable, Identifiable, Equatable {
    var id: Int { number }

    var number: Int
    /// Player id who won the skin on this hole. `nil` means push / carry.
    var winnerPlayerId: UUID?

    init(number: Int, winnerPlayerId: UUID? = nil) {
        self.number = number
        self.winnerPlayerId = winnerPlayerId
    }

    static func make18() -> [SkinsHole] {
        (1...18).map { SkinsHole(number: $0) }
    }
}
