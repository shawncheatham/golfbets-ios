import SwiftUI

struct SettlementView: View {
    @EnvironmentObject var store: AppStore

    private var settlement: Settlement {
        SettlementRules.computeSkinsSettlement(round: store.round)
    }

    var body: some View {
        List {
            Section("Net") {
                ForEach(store.round.players) { p in
                    let cents = settlement.netByPlayerId[p.id] ?? 0
                    HStack {
                        Text(p.name)
                        Spacer()
                        Text(centsToDollars(cents))
                            .font(.headline)
                            .foregroundStyle(cents < 0 ? .secondary : .primary)
                    }
                    .accessibilityLabel("\(p.name), \(centsToDollars(cents))")
                }
            }

            Section("Pay who") {
                if settlement.lines.isEmpty {
                    Text("All square")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(settlement.lines) { line in
                        let from = name(for: line.fromPlayerId)
                        let to = name(for: line.toPlayerId)
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(from) pays")
                                    .foregroundStyle(.secondary)
                                Text(to)
                                    .font(.headline)
                            }
                            Spacer()
                            Text(centsToDollars(line.amountCents))
                                .font(.headline)
                        }
                        .accessibilityLabel("\(from) pays \(to) \(centsToDollars(line.amountCents))")
                    }
                }
            }

            Section("Pot") {
                if settlement.unpaidPotCents == 0 {
                    Text("No unpaid balance")
                        .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pushed to the pot")
                            .font(.headline)
                        Text("Unpaid balance: \(centsToDollars(settlement.unpaidPotCents))")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Settle up")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func name(for playerId: UUID) -> String {
        store.round.players.first(where: { $0.id == playerId })?.name ?? "Player"
    }

    private func centsToDollars(_ cents: Int) -> String {
        let dollars = Double(cents) / 100.0
        return dollars.formatted(.currency(code: "USD"))
    }
}

#Preview {
    NavigationStack {
        SettlementView()
            .environmentObject(AppStore(round: .makeDefault(game: .skins)))
    }
}
