import Foundation

enum GameType: String, Codable, CaseIterable, Identifiable {
    case skins
    case wolf
    case bbb

    var id: String { rawValue }

    var label: String {
        switch self {
        case .skins: return "Skins"
        case .wolf: return "Wolf"
        case .bbb: return "Bingo Bango Bongo"
        }
    }

    var shortLabel: String {
        switch self {
        case .skins: return "Skins"
        case .wolf: return "Wolf"
        case .bbb: return "BBB"
        }
    }

    var systemImage: String {
        switch self {
        case .skins: return "die.face.5"
        case .wolf: return "person.2"
        case .bbb: return "trophy"
        }
    }
}
