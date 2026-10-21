import UIKit

enum SettingsKey {
    static let childName = "childName"
    static let speechRate = "speechRate"
    static let speechEnabled = "speechEnabled"
    static let spanishVoiceHelp = "spanishVoiceHelp"
    static let sessionLength = "sessionLength"
    static let parentPIN = "parentPIN"
    static let enabledMonsters = "enabledMonsters"
    /// Identifier of the English voice chosen in the parent area; empty means automatic.
    static let englishVoice = "englishVoice"

    static let defaultSpeechRate = 0.42
}

/// Which monsters take part in missions, stored as a comma-separated list of ids.
enum MonsterSelection {
    static let defaultRaw = encode(Set(MonsterID.defaultEnabled))

    /// Never empty: an empty or unreadable value falls back to the defaults.
    static func decode(_ raw: String) -> Set<MonsterID> {
        let ids = Set(raw.split(separator: ",").compactMap { MonsterID(rawValue: String($0)) })
        return ids.isEmpty ? Set(MonsterID.defaultEnabled) : ids
    }

    static func encode(_ monsters: Set<MonsterID>) -> String {
        MonsterID.allCases.filter(monsters.contains).map(\.rawValue).joined(separator: ",")
    }

    static func cards(enabled: Set<MonsterID>) -> [Card] {
        Curriculum.all.filter { enabled.contains($0.monster) }
    }
}

@MainActor
enum Haptics {
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
    static func tap() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
}
