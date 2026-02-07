import SwiftUI

struct SkinsHoleEntryView: View {
    @EnvironmentObject var store: AppStore

    @State private var holeIndex: Int = 0

    private var holeNumber: Int { store.round.skinsHoles[safe: holeIndex]?.number ?? 1 }

    var body: some View {
        VStack(spacing: 16) {
            header

            Form {
                Section("Winner") {
                    Picker("Winner", selection: winnerBinding) {
                        Text("Push / carry").tag(UUID?.none)
                        ForEach(store.round.players) { p in
                            Text(p.name).tag(UUID?.some(p.id))
                        }
                    }
                    .pickerStyle(.inline)
                }

                Section {
                    NavigationLink {
                        SkinsSummaryView()
                    } label: {
                        Label("Summary", systemImage: "list.bullet")
                    }
                }
            }
        }
        .navigationTitle("Skins")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("Hole \(holeNumber)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button {
                holeIndex = max(0, holeIndex - 1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Previous hole")
            .disabled(holeIndex == 0)

            VStack(alignment: .leading, spacing: 2) {
                Text(store.round.name)
                    .font(.headline)
                Text("$ per skin: \((store.round.stakeCents ?? 0) / 100)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                holeIndex = min(store.round.skinsHoles.count - 1, holeIndex + 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Next hole")
            .disabled(holeIndex >= store.round.skinsHoles.count - 1)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var winnerBinding: Binding<UUID?> {
        Binding(
            get: {
                store.round.skinsHoles[safe: holeIndex]?.winnerPlayerId
            },
            set: { newValue in
                guard store.round.skinsHoles.indices.contains(holeIndex) else { return }
                store.round.skinsHoles[holeIndex].winnerPlayerId = newValue
            }
        )
    }
}

private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    NavigationStack {
        SkinsHoleEntryView()
            .environmentObject(AppStore(round: .makeDefault(game: .skins)))
    }
}
