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
                    holesDestination
                } label: {
                    Label("Enter holes", systemImage: "list.number")
                }

                NavigationLink {
                    SettlementView()
                } label: {
                    Label("Settle up", systemImage: "dollarsign.circle")
                }
            }
        }
        .navigationTitle("Round")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var holesDestination: some View {
        switch store.round.game {
        case .skins:
            SkinsHoleEntryView()
        case .wolf, .bbb:
            ContentUnavailableView(
                "Hole entry coming next",
                systemImage: "flag",
                description: Text("Skins is first; we’ll bring this over next.")
            )
            .navigationTitle("Holes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        RoundHomeView()
            .environmentObject(AppStore(round: .makeDefault(game: .skins)))
    }
}
