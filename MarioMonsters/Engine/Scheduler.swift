import Foundation

/// Leitner-style spaced repetition. The box also decides which rung of the
/// "Oye → Dilo → Constrúyelo → Escríbelo" ladder a card is on.
enum Scheduler {
    static let maxBox = 6
    /// A card counts as mastered (monster damage) from this box on.
    static let masteredBox = 4
    /// Days until the next review after reaching each box.
    static let intervals = [0, 0, 1, 2, 4, 8, 21]

    static func next(box: Int, correct: Bool, now: Date, calendar: Calendar = .current) -> (box: Int, due: Date) {
        guard correct else {
            return (max(0, box - 2), now)
        }
        let newBox = min(box + 1, maxBox)
        let days = intervals[newBox]
        guard days > 0 else { return (newBox, now) }
        let start = calendar.startOfDay(for: now)
        let due = calendar.date(byAdding: .day, value: days, to: start) ?? now
        return (newBox, due)
    }
}

enum MonsterStats {
    /// 1 = full health, 0 = defeated. Every box up to `masteredBox` chips away a bit.
    static func health(of monster: MonsterID, boxes: [String: Int], cards: [Card] = Curriculum.all) -> Double {
        let mine = cards.filter { $0.monster == monster }
        guard !mine.isEmpty else { return 0 }
        let damage = mine.reduce(0) { $0 + min(boxes[$1.id] ?? 0, Scheduler.masteredBox) }
        return 1 - Double(damage) / Double(mine.count * Scheduler.masteredBox)
    }

    static func mastered(of monster: MonsterID, boxes: [String: Int], cards: [Card] = Curriculum.all) -> (done: Int, total: Int) {
        let mine = cards.filter { $0.monster == monster }
        let done = mine.filter { (boxes[$0.id] ?? 0) >= Scheduler.masteredBox }.count
        return (done, mine.count)
    }
}
