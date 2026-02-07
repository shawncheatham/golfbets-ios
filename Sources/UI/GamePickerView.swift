import SwiftUI

struct GamePickerView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Choose a game")
                    .font(.headline)
                    .fontWeight(.semibold)

                Text("Less math, fewer arguments.")
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 12) {
                ForEach(GameType.allCases) { game in
                    NavigationLink {
                        SetupView(game: game)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: game.systemImage)
                                .frame(width: 24)
                            Text(game.label)
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.accentColor.opacity(0.18))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Golf Bets")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        GamePickerView()
            .environmentObject(AppStore())
    }
}
