import SwiftUI

struct ContentView: View {
    @StateObject private var store = AppStore()

    var body: some View {
        NavigationStack {
            GamePickerView()
        }
        .environmentObject(store)
    }
}

#Preview {
    ContentView()
}
