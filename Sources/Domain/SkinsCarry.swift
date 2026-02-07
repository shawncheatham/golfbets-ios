import Foundation

struct SkinsHoleComputed: Identifiable, Equatable {
    var id: Int { hole.number }

    let hole: SkinsHole
    /// Number of pushed skins coming into this hole.
    let carryIn: Int
    /// Skins paid out on this hole (0 if push).
    let skinsPaid: Int
}

enum SkinsRules {
    /// Computes carry and payout per hole.
    /// - carry starts at 0
    /// - push => skinsPaid = 0, carry increments
    /// - winner => skinsPaid = carry + 1, carry resets to 0
    static func compute(holes: [SkinsHole]) -> [SkinsHoleComputed] {
        var carry = 0
        return holes.map { h in
            let carryIn = carry
            if h.winnerPlayerId == nil {
                carry += 1
                return SkinsHoleComputed(hole: h, carryIn: carryIn, skinsPaid: 0)
            } else {
                let paid = carry + 1
                carry = 0
                return SkinsHoleComputed(hole: h, carryIn: carryIn, skinsPaid: paid)
            }
        }
    }
}
