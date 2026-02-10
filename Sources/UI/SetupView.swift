import SwiftUI

struct SetupView: View {
    @EnvironmentObject var store: AppStore

    let game: GameType

    @State private var draft: Round = .makeDefault(game: .skins)
    @State private var newPlayerName: String = ""
    @State private var didStart: Bool = false

    var body: some View {
        Form {
            Section("Round") {
                TextField("Round name", text: $draft.name)
                    .textInputAutocapitalization(.words)

                gameSettingsSection
            }

            Section("Players") {
                ForEach($draft.players) { $p in
                    TextField("Name", text: $p.name)
                        .textInputAutocapitalization(.words)
                }
                .onDelete { indexSet in
                    draft.players.remove(atOffsets: indexSet)
                }
                .onMove { from, to in
                    draft.players.move(fromOffsets: from, toOffset: to)
                }

                HStack {
                    TextField("Add player", text: $newPlayerName)
                        .textInputAutocapitalization(.words)

                    Button {
                        let trimmed = newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        draft.players.append(Player(name: trimmed))
                        newPlayerName = ""
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Add player")
                }

                if draft.players.count > 1 {
                    Text("Tip: Drag to reorder")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Button("Start round") {
                    store.start(round: draft)
                    didStart = true
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(game.shortLabel)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton()
        }
        .navigationDestination(isPresented: $didStart) {
            RoundHomeView()
        }
        .onAppear {
            draft = Round.makeDefault(game: game)
        }
    }

    @ViewBuilder
    private var gameSettingsSection: some View {
        switch game {
        case .skins:
            Stepper(value: Binding(
                get: { (draft.stakeCents ?? 0) / 100 },
                set: { draft.stakeCents = max(0, $0) * 100 }
            ), in: 0...1000) {
                Text("$ per skin: \((draft.stakeCents ?? 0) / 100)")
            }

        case .wolf:
            Stepper(value: Binding(
                get: { draft.wolfPointsPerHole ?? 1 },
                set: { draft.wolfPointsPerHole = max(1, $0) }
            ), in: 1...10) {
                Text("Points per hole: \(draft.wolfPointsPerHole ?? 1)")
            }

            Stepper(value: Binding(
                get: { draft.wolfLoneMultiplier ?? 2 },
                set: { draft.wolfLoneMultiplier = max(1, $0) }
            ), in: 1...5) {
                Text("Lone wolf multiplier: \(draft.wolfLoneMultiplier ?? 2)x")
            }

            Text("$ per point coming next")
                .foregroundStyle(.secondary)

        case .bbb:
            Text("$ per point (optional) coming next")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        SetupView(game: .skins)
            .environmentObject(AppStore())
    }
}
