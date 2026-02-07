import Foundation
import SwiftUI

@MainActor
final class AppStore: ObservableObject {
    @Published var round: Round

    init(round: Round = Round.makeDefault(game: .skins)) {
        self.round = round
    }

    func startNew(game: GameType) {
        round = Round.makeDefault(game: game)
    }
}
