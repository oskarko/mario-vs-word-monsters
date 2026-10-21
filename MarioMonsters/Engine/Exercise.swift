import Foundation

enum ExerciseKind: String, Codable, CaseIterable, Sendable {
    case listenChoose, sayIt, repair, build, spellTiles, spellKeyboard, paper

    var parentLabel: String {
        switch self {
        case .listenChoose: "Oír y reconocer"
        case .sayIt: "Decirlo en voz alta"
        case .repair: "Arreglar el error"
        case .build: "Construir frases"
        case .spellTiles: "Deletrear con fichas"
        case .spellKeyboard: "Deletrear con teclado"
        case .paper: "Escribir en papel"
        }
    }
}

struct Exercise: Identifiable, Equatable {
    let id = UUID()
    let card: Card
    let kind: ExerciseKind
    /// Play the English audio automatically. Support is withdrawn on higher rungs.
    let autoplay: Bool

    private static let sentenceLadder: [ExerciseKind] = [.listenChoose, .sayIt, .repair, .build, .build, .paper]
    private static let wordLadder: [ExerciseKind] = [.listenChoose, .sayIt, .spellTiles, .spellKeyboard, .spellKeyboard, .paper]

    static func make(card: Card, box: Int, speechEnabled: Bool) -> Exercise {
        var rung = min(max(box, 0), 5)
        if rung == 1 && !speechEnabled { rung = 2 }
        let ladder = card.kind == .sentence ? sentenceLadder : wordLadder
        return Exercise(card: card, kind: ladder[rung], autoplay: rung < 4)
    }

    /// The same card as a different, randomly chosen exercise (used when speaking is skipped).
    func swapped() -> Exercise {
        let ladder = card.kind == .sentence ? Self.sentenceLadder : Self.wordLadder
        let kinds = Set(ladder).subtracting([kind, .sayIt])
        return Exercise(card: card, kind: kinds.randomElement() ?? .listenChoose, autoplay: autoplay)
    }
}

struct ExerciseResult: Equatable {
    /// nil = neutral: no penalty, no reward.
    let correct: Bool?
    let given: String?
}

/// Tiles and letters for the build / repair / spell exercises.
enum TileFactory {
    private static let properNouns: Set<String> = [
        "I", "María", "Tom", "Paul", "Emma", "Julia", "Spain", "Canada", "English", "TV",
        "Monday", "Mondays", "Tuesday", "Wednesday", "Wednesdays", "Thursday", "Friday", "Fridays",
        "Saturday", "Saturdays", "Sunday", "Sundays", "December", "Max",
    ]

    /// Tiles are shown in lower case unless the word is always capitalised,
    /// so that the sentence-start capital does not give the order away.
    static func canonical(_ token: String, index: Int) -> String {
        if properNouns.contains(token) || token.hasPrefix("I'") { return token }
        if token.hasSuffix("'s"), properNouns.contains(String(token.dropLast(2))) { return token }
        if index > 0, token.first?.isUppercase == true { return token }
        return token.lowercased()
    }

    static func canonicalTokens(_ sentence: String) -> [String] {
        AnswerChecker.tokens(sentence).enumerated().map { canonical($1, index: $0) }
    }

    /// Words from Mario's wrong versions that do not belong in the right answer ("no", "Ae", "hasen't"…).
    static func distractorWords(for card: Card, limit: Int = 3) -> [String] {
        let correctKeys = Set(AnswerChecker.tokens(card.english).map(AnswerChecker.key))
        var seen = Set<String>()
        var result: [String] = []
        for version in card.wrong {
            for token in canonicalTokens(version) {
                let key = AnswerChecker.key(token)
                guard !correctKeys.contains(key), seen.insert(key).inserted else { continue }
                result.append(token)
            }
        }
        return Array(result.prefix(limit))
    }

    /// Repair: the monster's sentence is pre-placed; the bank holds what is missing plus one trap.
    static func repairSetup(for card: Card) -> (placed: [String], bank: [String]) {
        let placed = canonicalTokens(card.wrong.first ?? "")
        var available = placed.map(AnswerChecker.key)
        var missing: [String] = []
        for token in canonicalTokens(card.english) {
            let key = AnswerChecker.key(token)
            if let index = available.firstIndex(of: key) {
                available.remove(at: index)
            } else {
                missing.append(token)
            }
        }
        let placedKeys = Set(placed.map(AnswerChecker.key))
        let trap = distractorWords(for: card).first { !placedKeys.contains(AnswerChecker.key($0)) }
        return (placed, missing + (trap.map { [$0] } ?? []))
    }

    /// Extra letters for spelling: letters from the typical misspellings, plus a lower-case
    /// twin of an initial capital (English / english).
    static func distractorLetters(for card: Card, limit: Int = 3) -> [Character] {
        let target = Set(card.english)
        var result: [Character] = []
        func add(_ c: Character) {
            guard c != " ", !target.contains(c), !result.contains(c), result.count < limit else { return }
            result.append(c)
        }
        if let first = card.english.first, first.isUppercase {
            add(Character(first.lowercased()))
        }
        for version in card.wrong {
            version.forEach(add)
        }
        "aeiouyk".forEach(add)
        return result
    }
}
