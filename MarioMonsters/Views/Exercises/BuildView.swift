import SwiftUI

/// Rungs 3–4 "Constrúyelo": put word tiles in order. Distractor tiles are Mario's own
/// mistakes ("no", "Ae", "the"…), so he has to consciously reject them.
/// In repair mode the monster's wrong sentence is shown above and Mario writes it right.
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
    // Dragging a placed tile reorders it in place (like Duolingo); a tap still sends it back.
    @State private var dragging: Tile.ID?
    @State private var dragPoint: CGPoint = .zero
    @State private var frames: [Tile.ID: CGRect] = [:]

    private var card: Card { exercise.card }
    private var punctuation: String { card.isQuestion ? "?" : "." }

    var body: some View {
        VStack(spacing: 18) {
            InstructionView(text: repair
                ? "¡El monstruo lo ha escrito mal! Escríbelo bien tú: toca las palabras para ponerlas, o arrástralas para cambiarlas de sitio."
                : "Construye la frase en inglés. Puedes arrastrar las palabras para cambiarlas de sitio.")
            PromptCard(card: card, showsAudio: exercise.autoplay || repair)

            if repair, let wrong = card.wrong.first {
                Text("El monstruo escribió: \(wrong)")
                    .font(Theme.body(16))
                    .foregroundStyle(Theme.ink.opacity(0.6))
                    .strikethrough(color: .red.opacity(0.6))
                    .multilineTextAlignment(.center)
            }

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
                TileView(text: index == 0 ? tile.text.capitalisedFirst : tile.text, color: Theme.gold.opacity(0.35))
                    .opacity(dragging == tile.id ? 0.25 : 1)
                    .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(Self.answerSpace)) } action: { frames[tile.id] = $0 }
                    .onTapGesture { move(tile, toAnswer: false) }
                    .gesture(reorder(tile))
                    .accessibilityAddTraits(.isButton)
            }
            if !placed.isEmpty {
                Text(punctuation).font(Theme.title(30)).foregroundStyle(Theme.ink)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .padding(14)
        .coordinateSpace(.named(Self.answerSpace))
        .overlay(alignment: .topLeading) {
            if let dragging, let index = placed.firstIndex(where: { $0.id == dragging }) {
                let text = placed[index].text
                TileView(text: index == 0 ? text.capitalisedFirst : text, color: Theme.gold.opacity(0.6))
                    .scaleEffect(1.1)
                    .shadow(color: .black.opacity(0.2), radius: 6, y: 4)
                    .position(dragPoint)
                    .allowsHitTesting(false)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                .foregroundStyle(Theme.ink.opacity(0.25))
        )
    }

    private static let answerSpace = "answer"

    private func reorder(_ tile: Tile) -> some Gesture {
        DragGesture(minimumDistance: 6, coordinateSpace: .named(Self.answerSpace))
            .onChanged { value in
                guard !checked else { return }
                if dragging == nil { Haptics.tap() }
                dragging = tile.id
                dragPoint = value.location
                guard let from = placed.firstIndex(of: tile),
                      let target = placed.firstIndex(where: { $0.id != tile.id && frames[$0.id]?.contains(value.location) == true }),
                      let targetFrame = frames[placed[target].id], let ownFrame = frames[tile.id]
                else { return }
                // On the same row, wait until the finger passes the neighbour's middle, so tiles
                // of different widths don't swap back and forth.
                if abs(targetFrame.midY - ownFrame.midY) < 4,
                   target > from ? value.location.x < targetFrame.midX : value.location.x > targetFrame.midX { return }
                withAnimation(.spring(duration: 0.25)) {
                    placed.move(fromOffsets: [from], toOffset: target > from ? target + 1 : target)
                }
                Haptics.tap()
            }
            .onEnded { _ in dragging = nil }
    }

    private func setUp() {
        guard !ready else { return }
        ready = true
        // Both modes start with every tile loose in the bank, shuffled; the answer box is empty.
        let words = TileFactory.canonicalTokens(card.english) + TileFactory.distractorWords(for: card)
        bank = words.shuffled().map { Tile(text: $0) }
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
