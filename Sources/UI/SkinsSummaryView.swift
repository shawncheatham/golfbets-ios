import SwiftUI

struct SkinsSummaryView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        List {
            Section("Skins won") {
                if store.round.players.isEmpty {
                    Text("No players")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(store.round.players) { p in
                        let count = skinsWon(for: p.id)
                        let total = totalCents(for: p.id)
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(p.name)
                                Text("\(count) skin\(count == 1 ? "" : "s")")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(centsToDollars(total))
                                .font(.headline)
                        }
                        .accessibilityLabel("\(p.name), \(count) skins")
                    }
                }
            }

            Section("Pot") {
                let round = SkinsRules.computeRound(holes: store.round.skinsHoles)
                let unpaid = round.unpaidSkinsInPot
                if unpaid == 0 {
                    Text("No unpaid skins")
                        .foregroundStyle(.secondary)
                } else {
                    let cents = unpaid * (store.round.stakeCents ?? 0)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pushed to the pot: \(unpaid) skin\(unpaid == 1 ? "" : "s")")
                            .font(.headline)
                        Text("Unpaid balance: \(centsToDollars(cents))")
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Pushed to the pot, \(unpaid) skins")
                }
            }

            Section("Holes") {
                let computed = SkinsRules.computeRound(holes: store.round.skinsHoles).holes
                ForEach(computed) { c in
                    HStack(alignment: .firstTextBaseline) {
                        Text("Hole \(c.hole.number)")

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text(label(for: c.hole))
                                .foregroundStyle(c.hole.winnerPlayerId == nil ? .secondary : .primary)

                            if c.skinsPaid > 0 {
                                Text("Worth \(c.skinsPaid)")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            } else if c.carryIn > 0 {
                                Text("Carry in \(c.carryIn)")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Push")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func skinsWon(for playerId: UUID) -> Int {
        let computed = SkinsRules.compute(holes: store.round.skinsHoles)
        return computed.reduce(0) { partial, c in
            partial + (c.hole.winnerPlayerId == playerId ? c.skinsPaid : 0)
        }
    }

    private func totalCents(for playerId: UUID) -> Int {
        let stake = store.round.stakeCents ?? 0
        return skinsWon(for: playerId) * stake
    }

    private func centsToDollars(_ cents: Int) -> String {
        let dollars = Double(cents) / 100.0
        return dollars.formatted(.currency(code: "USD"))
    }

    private func label(for hole: SkinsHole) -> String {
        guard let id = hole.winnerPlayerId else { return "Push" }
        return store.round.players.first(where: { $0.id == id })?.name ?? "Winner"
    }
}

#Preview {
    NavigationStack {
        SkinsSummaryView()
            .environmentObject(AppStore(round: .makeDefault(game: .skins)))
    }
}
