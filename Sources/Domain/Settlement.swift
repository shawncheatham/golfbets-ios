import Foundation

struct SettlementLine: Identifiable, Equatable {
    let id = UUID()
    let fromPlayerId: UUID
    let toPlayerId: UUID
    let amountCents: Int
}

struct Settlement: Equatable {
    /// + is owed to them; - they owe
    let netByPlayerId: [UUID: Int]
    let lines: [SettlementLine]
    /// Unpaid pot at end of hole 18, in cents.
    let unpaidPotCents: Int
}

enum SettlementRules {
    /// Mirrors the web app settlement model:
    /// each decided skin pays `stakeCents` from each non-winner to the winner.
    static func computeSkinsSettlement(round: Round) -> Settlement {
        let N = round.players.count
        let unit = round.stakeCents ?? 0

        var net: [UUID: Int] = [:]
        for p in round.players { net[p.id] = 0 }

        let computed = SkinsRules.computeRound(holes: round.skinsHoles)

        for c in computed.holes {
            guard let winnerId = c.hole.winnerPlayerId, c.skinsPaid > 0 else { continue }
            let skinsCount = c.skinsPaid

            net[winnerId, default: 0] += unit * skinsCount * (N - 1)
            for p in round.players {
                if p.id == winnerId { continue }
                net[p.id, default: 0] -= unit * skinsCount
            }
        }

        // Greedy settle: match debtors to creditors.
        var creditors = round.players
            .map { (p: $0, net: net[$0.id] ?? 0) }
            .filter { $0.net > 0 }
            .sorted { $0.net > $1.net }

        var debtors = round.players
            .map { (p: $0, net: net[$0.id] ?? 0) }
            .filter { $0.net < 0 }
            .sorted { $0.net < $1.net }

        var lines: [SettlementLine] = []
        var i = 0
        var j = 0

        while i < debtors.count && j < creditors.count {
            var d = debtors[i]
            var c = creditors[j]

            let pay = min(-d.net, c.net)
            if pay > 0 {
                lines.append(SettlementLine(fromPlayerId: d.p.id, toPlayerId: c.p.id, amountCents: pay))
                d.net += pay
                c.net -= pay
                debtors[i] = d
                creditors[j] = c
            }

            if d.net == 0 { i += 1 }
            if c.net == 0 { j += 1 }
        }

        let unpaidPotCents = computed.unpaidSkinsInPot * unit
        return Settlement(netByPlayerId: net, lines: lines, unpaidPotCents: unpaidPotCents)
    }
}
