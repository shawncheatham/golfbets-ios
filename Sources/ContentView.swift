import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Golf Bets")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Native shell (local-first)")
                    .foregroundStyle(.secondary)

                NavigationLink("Choose a game →") {
                    Text("TODO: GamePickerView")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
