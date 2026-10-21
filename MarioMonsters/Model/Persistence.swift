import Foundation
import SwiftData

/// Spaced-repetition state of one card.
@Model
final class CardProgress {
    @Attribute(.unique) var cardID: String
    var box: Int
    var due: Date
    var timesCorrect: Int
    var timesWrong: Int
    var lastWrong: String?
    var lastSeen: Date

    init(cardID: String, now: Date = .now) {
        self.cardID = cardID
        self.box = 0
        self.due = now
        self.timesCorrect = 0
        self.timesWrong = 0
        self.lastWrong = nil
        self.lastSeen = now
    }
}

/// Every answer Mario gives, for the parent dashboard.
@Model
final class AttemptLog {
    var cardID: String
    var kindRaw: String
    /// nil = neutral (a say-it attempt the recogniser could not judge).
    var correct: Bool?
    var given: String?
    var date: Date

    init(cardID: String, kind: ExerciseKind, correct: Bool?, given: String?, date: Date = .now) {
        self.cardID = cardID
        self.kindRaw = kind.rawValue
        self.correct = correct
        self.given = given
        self.date = date
    }

    var kind: ExerciseKind? { ExerciseKind(rawValue: kindRaw) }
}

@Model
final class SessionLog {
    var date: Date
    var duration: TimeInterval
    var correct: Int
    var answered: Int
    var stars: Int

    init(date: Date, duration: TimeInterval, correct: Int, answered: Int, stars: Int) {
        self.date = date
        self.duration = duration
        self.correct = correct
        self.answered = answered
        self.stars = stars
    }
}

enum AppSchema {
    static let models: [any PersistentModel.Type] = [CardProgress.self, AttemptLog.self, SessionLog.self]
}
