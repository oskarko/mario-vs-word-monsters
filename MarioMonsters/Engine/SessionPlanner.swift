import Foundation

struct ProgressSnapshot: Equatable, Sendable {
    var box: Int
    var due: Date
}

/// Chooses which cards go into a ~10 minute session: due reviews first,
/// a few new cards, then the weakest cards as extra practice.
enum SessionPlanner {
    static func plan(
        cards: [Card] = Curriculum.all,
        progress: [String: ProgressSnapshot],
        focus: MonsterID?,
        length: Int,
        newLimit: Int? = nil,
        now: Date = .now
    ) -> [Card] {
        // A generous first session so the start doesn't feel thin; afterwards new cards trickle in.
        let newLimit = newLimit ?? (progress.isEmpty ? 8 : 5)
        let pool = focus.map { monster in cards.filter { $0.monster == monster } } ?? cards

        // Most overdue first within each monster, but alternate monsters so a big backlog is not all one error.
        let due = interleaveByMonster(pool
            .filter { progress[$0.id].map { $0.due <= now } ?? false }
            .sorted { lhs, rhs in
                let l = progress[lhs.id]!, r = progress[rhs.id]!
                return (l.due, l.box) < (r.due, r.box)
            })
        let fresh = interleaveByMonster(pool.filter { progress[$0.id] == nil })

        // Always leave room for a couple of new cards so the session never feels like pure revision.
        let reserved = min(2, fresh.count, newLimit)
        var picked = Array(due.prefix(max(0, length - reserved)))
        picked += fresh.prefix(min(newLimit, length - picked.count))

        if picked.count < length {
            let chosen = Set(picked.map(\.id))
            let extra = pool
                .filter { !chosen.contains($0.id) && progress[$0.id] != nil }
                .sorted { lhs, rhs in
                    let l = progress[lhs.id]!, r = progress[rhs.id]!
                    return (l.box, l.due) < (r.box, r.due)
                }
            picked += extra.prefix(length - picked.count)
        }
        return spreadMonsters(picked)
    }

    /// Round-robin across monsters, keeping curriculum order within each one.
    static func interleaveByMonster(_ cards: [Card]) -> [Card] {
        var buckets = MonsterID.allCases.map { monster in cards.filter { $0.monster == monster } }
        var result: [Card] = []
        while buckets.contains(where: { !$0.isEmpty }) {
            for index in buckets.indices where !buckets[index].isEmpty {
                result.append(buckets[index].removeFirst())
            }
        }
        return result
    }

    /// Shuffle while avoiding the same monster twice in a row where possible.
    private static func spreadMonsters(_ cards: [Card]) -> [Card] {
        var remaining = cards.shuffled()
        var result: [Card] = []
        while !remaining.isEmpty {
            let index = remaining.firstIndex { $0.monster != result.last?.monster } ?? 0
            result.append(remaining.remove(at: index))
        }
        return result
    }
}

/// "Detective" checklist shown after a paper challenge, so Mario learns to check his own writing.
enum DetectiveChecklist {
    static func items(for card: Card, cards: [Card] = Curriculum.all) -> [String] {
        let words = AnswerChecker.words(card.english)
        let tokens = AnswerChecker.tokens(card.english)
        var items: [String] = []

        if words.contains("i") {
            items.append("¿Has escrito I en MAYÚSCULA (y no «Ae»)?")
        }
        if card.isQuestion {
            items.append("¿El verbo (is, are, has, can, do, does) está al principio?")
            items.append("¿Solo hay ? al final, sin ¿ al principio?")
        }
        if words.contains("not") {
            items.append("¿Has negado con isn't / don't / haven't… y no con «no»?")
        }
        if tokens.first == "There" {
            items.append("¿Empieza por There?")
        }
        if words.contains("years") {
            items.append("¿Has usado am / is + years old (y no have)?")
        }
        if card.monster == .snake, !words.contains("i") {
            items.append("¿Quién es? Si es he / she / it, ¿has puesto la S?")
        }
        let capitals = tokens.dropFirst().filter { $0.first?.isUppercase == true && $0 != "I" }
        if let capital = capitals.first {
            items.append("¿Has escrito «\(capital)» con mayúscula?")
        }

        let tricky = Set(cards.filter { $0.monster == .ae }.flatMap { AnswerChecker.words($0.english) })
            .subtracting(["i", "hair"])
        let spotted = tokens.filter { tricky.contains(AnswerChecker.key($0)) }
        if !spotted.isEmpty {
            items.append("Mira letra a letra: \(spotted.joined(separator: ", ")).")
        }

        if card.kind == .sentence {
            items.append("¿Mayúscula al principio y \(card.isQuestion ? "?" : "punto") al final?")
        } else {
            items.append("¿Están todas las letras, en el mismo orden?")
        }
        return Array(items.prefix(4))
    }
}
