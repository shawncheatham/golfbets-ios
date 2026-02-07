import Foundation

struct Round: Codable, Identifiable, Equatable {
    let id: UUID
    var game: GameType
    var name: String
    var createdAt: Date

    // Shared
    var players: [Player]
    var locked: Bool

    // Skins
    var stakeCents: Int?

    // Wolf
    var wolfPointsPerHole: Int?
    var wolfLoneMultiplier: Int?
    var wolfDollarsPerPointCents: Int?

    // BBB
    var bbbDollarsPerPointCents: Int?

    init(
        id: UUID = UUID(),
        game: GameType,
        name: String,
        createdAt: Date = Date(),
        players: [Player],
        locked: Bool = false,
        stakeCents: Int? = nil,
        wolfPointsPerHole: Int? = nil,
        wolfLoneMultiplier: Int? = nil,
        wolfDollarsPerPointCents: Int? = nil,
        bbbDollarsPerPointCents: Int? = nil
    ) {
        self.id = id
        self.game = game
        self.name = name
        self.createdAt = createdAt
        self.players = players
        self.locked = locked
        self.stakeCents = stakeCents
        self.wolfPointsPerHole = wolfPointsPerHole
        self.wolfLoneMultiplier = wolfLoneMultiplier
        self.wolfDollarsPerPointCents = wolfDollarsPerPointCents
        self.bbbDollarsPerPointCents = bbbDollarsPerPointCents
    }

    static func makeDefault(game: GameType) -> Round {
        switch game {
        case .skins:
            return Round(game: .skins, name: "Saturday Skins", players: [Player(name: "Player 1"), Player(name: "Player 2")], stakeCents: 500)
        case .wolf:
            return Round(
                game: .wolf,
                name: "Wolf",
                players: [Player(name: "Player 1"), Player(name: "Player 2"), Player(name: "Player 3"), Player(name: "Player 4")],
                wolfPointsPerHole: 1,
                wolfLoneMultiplier: 2,
                wolfDollarsPerPointCents: 0
            )
        case .bbb:
            return Round(game: .bbb, name: "BBB", players: [Player(name: "Player 1"), Player(name: "Player 2")], bbbDollarsPerPointCents: 0)
        }
    }
}
