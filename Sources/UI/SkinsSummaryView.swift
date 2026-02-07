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
                        HStack {
                            Text(p.name)
                            Spacer()
                            Text("\(count)")
                                .font(.headline)
                        }
                        .accessibilityLabel("\(p.name), \(count) skins")
                    }
                }
            }

            Section("Holes") {
                ForEach(store.round.skinsHoles) { h in
                    HStack {
                        Text("Hole \(h.number)")
                        Spacer()
                        Text(label(for: h))
                            .foregroundStyle(h.winnerPlayerId == nil ? .secondary : .primary)
                    }
                }
            }
        }
        .navigationTitle("Summary")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func skinsWon(for playerId: UUID) -> Int {
        store.round.skinsHoles.reduce(0) { partial, h in
            partial + (h.winnerPlayerId == playerId ? 1 : 0)
        }
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
