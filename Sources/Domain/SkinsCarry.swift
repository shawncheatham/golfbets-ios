import Foundation

struct SkinsHoleComputed: Identifiable, Equatable {
    var id: Int { hole.number }

    let hole: SkinsHole
    /// Number of pushed skins coming into this hole.
    let carryIn: Int
    /// Skins paid out on this hole (0 if push).
    let skinsPaid: Int
}

struct SkinsRoundComputed: Equatable {
    let holes: [SkinsHoleComputed]
    /// Skins that were pushed and never paid by the end of hole 18.
    let unpaidSkinsInPot: Int
}

enum SkinsRules {
    /// Computes carry and payout per hole.
    /// - carry starts at 0
    /// - push => skinsPaid = 0, carry increments
    /// - winner => skinsPaid = carry + 1, carry resets to 0
    /// - any carry remaining after final hole becomes unpaid pot
    static func computeRound(holes: [SkinsHole]) -> SkinsRoundComputed {
        var carry = 0
        let computedHoles: [SkinsHoleComputed] = holes.map { h in
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

        return SkinsRoundComputed(holes: computedHoles, unpaidSkinsInPot: carry)
    }

    static func compute(holes: [SkinsHole]) -> [SkinsHoleComputed] {
        computeRound(holes: holes).holes
    }
}
