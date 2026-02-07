import SwiftUI

struct RoundHomeView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        Form {
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(store.round.name)
                            .font(.headline)
                        Text(store.round.game.label)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if store.round.locked {
                        Label("Locked", systemImage: "lock.fill")
                            .labelStyle(.titleAndIcon)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Players") {
                if store.round.players.isEmpty {
                    Text("Add players to start scoring.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(store.round.players) { p in
                        Text(p.name)
                    }
                }
            }

            Section("Next") {
                NavigationLink {
                    ScorecardPlaceholderView()
                } label: {
                    Label("Enter holes", systemImage: "list.number")
                }

                NavigationLink {
                    SettlementPlaceholderView()
                } label: {
                    Label("Settle up", systemImage: "dollarsign.circle")
                }
            }
        }
        .navigationTitle("Round")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ScorecardPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Hole entry coming next",
            systemImage: "flag",
            description: Text("We’ll mirror the PWA’s quick hole flow here.")
        )
        .navigationTitle("Holes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SettlementPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Settlement coming next",
            systemImage: "chart.bar",
            description: Text("We’ll compute payouts and show a clean pay-who list.")
        )
        .navigationTitle("Settle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        RoundHomeView()
            .environmentObject(AppStore(round: .makeDefault(game: .skins)))
    }
}
