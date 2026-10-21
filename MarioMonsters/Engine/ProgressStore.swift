import Foundation
import SwiftData

/// Reads and writes learning progress in SwiftData.
@MainActor
struct ProgressStore {
    let context: ModelContext

    func allProgress() -> [CardProgress] {
        (try? context.fetch(FetchDescriptor<CardProgress>())) ?? []
    }

    func progress(for cardID: String) -> CardProgress? {
        var descriptor = FetchDescriptor<CardProgress>(predicate: #Predicate { $0.cardID == cardID })
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    func snapshots() -> [String: ProgressSnapshot] {
        Dictionary(allProgress().map { ($0.cardID, ProgressSnapshot(box: $0.box, due: $0.due)) }, uniquingKeysWith: { a, _ in a })
    }

    func box(for cardID: String) -> Int {
        progress(for: cardID)?.box ?? 0
    }

    /// Stores the attempt and, unless it was neutral, moves the card between boxes.
    func record(card: Card, kind: ExerciseKind, result: ExerciseResult, now: Date = .now) {
        context.insert(AttemptLog(cardID: card.id, kind: kind, correct: result.correct, given: result.given, date: now))

        let progress = progress(for: card.id) ?? {
            let new = CardProgress(cardID: card.id, now: now)
            context.insert(new)
            return new
        }()
        progress.lastSeen = now
        if let correct = result.correct {
            let next = Scheduler.next(box: progress.box, correct: correct, now: now)
            progress.box = next.box
            progress.due = next.due
            if correct {
                progress.timesCorrect += 1
            } else {
                progress.timesWrong += 1
                progress.lastWrong = result.given
            }
        }
        try? context.save()
    }

    func saveSession(_ log: SessionLog) {
        context.insert(log)
        try? context.save()
    }

    func resetAll() {
        try? context.delete(model: CardProgress.self)
        try? context.delete(model: AttemptLog.self)
        try? context.delete(model: SessionLog.self)
        try? context.save()
    }
}

/// Day streak: consecutive days with at least one session, ending today or yesterday.
enum Streak {
    static func days(sessionDates: [Date], now: Date = .now, calendar: Calendar = .current) -> Int {
        let days = Set(sessionDates.map { calendar.startOfDay(for: $0) })
        var day = calendar.startOfDay(for: now)
        if !days.contains(day) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: day), days.contains(yesterday) else { return 0 }
            day = yesterday
        }
        var count = 0
        while days.contains(day) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return count
    }
}
