import SwiftUI

struct SetupView: View {
    @EnvironmentObject var store: AppStore

    let game: GameType

    @State private var roundName: String = ""

    var body: some View {
        Form {
            Section(header: Text("Round")) {
                TextField("Round name", text: $roundName)
                    .textInputAutocapitalization(.words)

                switch game {
                case .skins:
                    Text("$ per skin (TODO)")
                        .foregroundStyle(.secondary)
                case .wolf:
                    Text("Points per hole / $ per point (TODO)")
                        .foregroundStyle(.secondary)
                case .bbb:
                    Text("$ per point (optional) (TODO)")
                        .foregroundStyle(.secondary)
                }
            }

            Section(header: Text("Players")) {
                Text("TODO: players list + add/remove")
                    .foregroundStyle(.secondary)
            }

            Section {
                Button("Start round →") {
                    store.startNew(game: game)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle(game.shortLabel)
        .onAppear {
            // Initialize UI state from a fresh default round for this game.
            let r = Round.makeDefault(game: game)
            roundName = r.name
        }
    }
}

#Preview {
    NavigationStack {
        SetupView(game: .skins)
            .environmentObject(AppStore())
    }
}
