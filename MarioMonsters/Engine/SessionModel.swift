import Foundation
import Observation

struct Mistake: Identifiable, Equatable {
    let id = UUID()
    let card: Card
    let given: String?
}

/// One play session: a queue of exercises, immediate feedback, and re-tries of
/// mistakes a few cards later (so the correct form is practised, not just seen).
@Observable
@MainActor
final class SessionModel: Identifiable {
    enum Phase: Equatable {
        case question
        case feedback(ExerciseResult)
        case finished
    }

    let id = UUID()
    let focus: MonsterID?
    private(set) var queue: [Exercise] = []
    private(set) var index = 0
    private(set) var phase: Phase = .question
    private(set) var correctCount = 0
    private(set) var answeredCount = 0
    private(set) var mistakes: [Mistake] = []
    /// Monster health at the start, to show how much damage was done.
    private(set) var startHealth: [MonsterID: Double] = [:]
    private(set) var saved = false

    private let store: ProgressStore
    private let speechEnabled: Bool
    private let start = Date.now
    private var appearances: [String: Int] = [:]
    private let maxLength: Int

    static let maxAppearances = 3

    init(store: ProgressStore, focus: MonsterID?, length: Int, speechEnabled: Bool, cards: [Card] = Curriculum.all, now: Date = .now) {
        self.store = store
        self.focus = focus
        self.speechEnabled = speechEnabled
        self.maxLength = length + 8

        let snapshots = store.snapshots()
        let boxes = snapshots.mapValues(\.box)
        startHealth = Dictionary(uniqueKeysWithValues: MonsterID.allCases.map { ($0, MonsterStats.health(of: $0, boxes: boxes)) })

        let cards = SessionPlanner.plan(cards: cards, progress: snapshots, focus: focus, length: length, now: now)
        queue = cards.map { Exercise.make(card: $0, box: snapshots[$0.id]?.box ?? 0, speechEnabled: speechEnabled) }
        cards.forEach { appearances[$0.id, default: 0] += 1 }
        if queue.isEmpty { phase = .finished }
    }

    var current: Exercise? { queue.indices.contains(index) ? queue[index] : nil }

    var progress: Double {
        queue.isEmpty ? 1 : Double(index + (phase == .question ? 0 : 1)) / Double(queue.count)
    }

    var stars: Int {
        guard answeredCount > 0 else { return 1 }
        let accuracy = Double(correctCount) / Double(answeredCount)
        return accuracy >= 0.9 ? 3 : accuracy >= 0.7 ? 2 : 1
    }

    var duration: TimeInterval { Date.now.timeIntervalSince(start) }

    func submit(_ result: ExerciseResult) {
        guard let exercise = current, phase == .question else { return }
        let boxBefore = store.box(for: exercise.card.id)
        store.record(card: exercise.card, kind: exercise.kind, result: result)

        if let correct = result.correct {
            answeredCount += 1
            if correct { correctCount += 1 } else { mistakes.append(Mistake(card: exercise.card, given: result.given)) }
            // Try mistakes again soon; give brand-new cards a second look on the next rung.
            let retry = !correct || boxBefore <= 1
            if retry { reinsert(exercise.card) }
        }
        phase = .feedback(result)
    }

    func next() {
        guard case .feedback = phase else { return }
        index += 1
        if index >= queue.count {
            finish()
        } else {
            phase = .question
        }
    }

    func finish() {
        phase = .finished
        guard !saved, answeredCount > 0 || index > 0 else { return }
        saved = true
        store.saveSession(SessionLog(date: start, duration: duration, correct: correctCount, answered: answeredCount, stars: stars))
    }

    func healthNow(_ monster: MonsterID) -> Double {
        MonsterStats.health(of: monster, boxes: store.snapshots().mapValues(\.box))
    }

    private func reinsert(_ card: Card) {
        guard appearances[card.id, default: 0] < Self.maxAppearances, queue.count < maxLength else { return }
        let alreadyQueued = queue[(index + 1)...].contains { $0.card.id == card.id }
        guard !alreadyQueued else { return }
        appearances[card.id, default: 0] += 1
        let remaining = queue.count - index - 1
        let position = index + 1 + min(3, remaining)
        let exercise = Exercise.make(card: card, box: store.box(for: card.id), speechEnabled: speechEnabled)
        queue.insert(exercise, at: position)
    }
}
