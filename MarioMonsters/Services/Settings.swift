import UIKit

enum SettingsKey {
    static let childName = "childName"
    static let speechRate = "speechRate"
    static let speechEnabled = "speechEnabled"
    static let spanishVoiceHelp = "spanishVoiceHelp"
    static let sessionLength = "sessionLength"
    static let parentPIN = "parentPIN"

    static let defaultSpeechRate = 0.42
}

@MainActor
enum Haptics {
    static func success() { UINotificationFeedbackGenerator().notificationOccurred(.success) }
    static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
    static func tap() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
}
