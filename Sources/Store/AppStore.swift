import Combine
import Foundation
import SwiftUI

@MainActor
final class AppStore: ObservableObject {
    @Published var round: Round

    private let storageKey = "golfbets.currentRound.v1"
    private var cancellables = Set<AnyCancellable>()

    init(round: Round = Round.makeDefault(game: .skins)) {
        // Prefer persisted state if present.
        if let restored = Self.loadRound(key: storageKey) {
            self.round = restored
        } else {
            self.round = round
        }

        // Persist on change.
        $round
            .dropFirst()
            .sink { [weak self] _ in
                self?.saveCurrentRound()
            }
            .store(in: &cancellables)
    }

    func startNew(game: GameType) {
        round = Round.makeDefault(game: game)
    }

    func start(round: Round) {
        self.round = round
    }

    func resetSavedRound() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        round = Round.makeDefault(game: .skins)
    }

    private func saveCurrentRound() {
        do {
            let data = try JSONEncoder().encode(round)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // Intentionally ignore in MVP; persistence is a convenience.
            // (Could add local debug logging later.)
        }
    }

    private static func loadRound(key: String) -> Round? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(Round.self, from: data)
    }
}

