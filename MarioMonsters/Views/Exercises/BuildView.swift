import SwiftUI

/// Rungs 3–4 "Constrúyelo": put word tiles in order. Distractor tiles are Mario's own
/// mistakes ("no", "Ae", "the"…), so he has to consciously reject them.
/// In repair mode the monster's wrong sentence is already placed and Mario fixes it.
struct BuildView: View {
    let exercise: Exercise
    let repair: Bool
    let onAnswer: (ExerciseResult) -> Void

    private struct Tile: Identifiable, Equatable {
        let id = UUID()
        let text: String
    }

    @State private var placed: [Tile] = []
    @State private var bank: [Tile] = []
    @State private var ready = false
    @State private var checked = false

    private var card: Card { exercise.card }
    private var punctuation: String { card.isQuestion ? "?" : "." }

    var body: some View {
        VStack(spacing: 18) {
            InstructionView(text: repair
                ? "¡El monstruo lo ha escrito mal! Toca las palabras para quitarlas o ponerlas y arréglalo."
                : "Construye la frase en inglés.")
            PromptCard(card: card, showsAudio: exercise.autoplay || repair)

            answerArea

            FlowLayout(spacing: 10) {
                ForEach(bank) { tile in
                    Button { move(tile, toAnswer: true) } label: { TileView(text: tile.text) }
                        .buttonStyle(.plain)
                }
            }
            .frame(minHeight: 60)

            CheckButton(enabled: !placed.isEmpty && !checked) { check() }
        }
        .animation(.spring(duration: 0.3), value: placed)
        .animation(.spring(duration: 0.3), value: bank)
        .onAppear(perform: setUp)
    }

    private var answerArea: some View {
        FlowLayout(spacing: 8, alignment: .leading) {
            ForEach(Array(placed.enumerated()), id: \.element.id) { index, tile in
                Button { move(tile, toAnswer: false) } label: {
                    TileView(text: index == 0 ? tile.text.capitalisedFirst : tile.text, color: Theme.gold.opacity(0.35))
                }
                .buttonStyle(.plain)
            }
            if !placed.isEmpty {
                Text(punctuation).font(Theme.title(30)).foregroundStyle(Theme.ink)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                .foregroundStyle(Theme.ink.opacity(0.25))
        )
    }

    private func setUp() {
        guard !ready else { return }
        ready = true
        if repair {
            let setup = TileFactory.repairSetup(for: card)
            placed = setup.placed.map { Tile(text: $0) }
            bank = setup.bank.shuffled().map { Tile(text: $0) }
        } else {
            let words = TileFactory.canonicalTokens(card.english) + TileFactory.distractorWords(for: card)
            bank = words.shuffled().map { Tile(text: $0) }
        }
    }

    private func move(_ tile: Tile, toAnswer: Bool) {
        guard !checked else { return }
        Haptics.tap()
        if toAnswer {
            bank.removeAll { $0.id == tile.id }
            placed.append(tile)
        } else {
            placed.removeAll { $0.id == tile.id }
            bank.append(tile)
        }
    }

    private func check() {
        checked = true
        let words = placed.enumerated().map { $0 == 0 ? $1.text.capitalisedFirst : $1.text }
        let answer = words.joined(separator: " ") + punctuation
        onAnswer(ExerciseResult(correct: AnswerChecker.sentenceMatches(answer, card.english), given: answer))
    }
}
