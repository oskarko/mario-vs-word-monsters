import SwiftUI

/// Rung 6 "Escríbelo": real handwriting in his notebook (that is what the school marks),
/// then self-checking with the detective checklist before seeing whether it was right.
struct PaperView: View {
    let exercise: Exercise
    let onAnswer: (ExerciseResult) -> Void

    private enum Step { case write, check, reveal }

    @State private var step = Step.write
    @State private var ticked: Set<String> = []
    @State private var answered = false

    private var items: [String] { DetectiveChecklist.items(for: exercise.card) }

    var body: some View {
        VStack(spacing: 18) {
            InstructionView(text: "¡Reto papel! Escríbelo en inglés en tu cuaderno.")
            PromptCard(card: exercise.card, showsAudio: step != .write)

            switch step {
            case .write:
                Text("✍️").font(.system(size: 70))
                Button("Ya lo he escrito") { step = .check }
                    .buttonStyle(ChunkyButtonStyle(color: Theme.neutral))
            case .check:
                checklist
                Button("Ver la respuesta") {
                    step = .reveal
                    Speaker.shared.english(exercise.card.english)
                }
                .buttonStyle(ChunkyButtonStyle(color: Theme.neutral))
            case .reveal:
                VStack(spacing: 8) {
                    Text("Se escribe así:").font(Theme.body(17)).foregroundStyle(Theme.ink.opacity(0.6))
                    Text(exercise.card.english).font(Theme.title(30)).foregroundStyle(Theme.good).multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .cardStyle()
                Text("Compara letra a letra con tu cuaderno. ¿Está igual?")
                    .font(Theme.body(18)).foregroundStyle(Theme.ink).multilineTextAlignment(.center)
                HStack(spacing: 12) {
                    Button("Tengo algún fallo") { answer(false) }
                        .buttonStyle(ChunkyButtonStyle(color: Theme.bad, font: Theme.body(18)))
                    Button("¡Está igual!") { answer(true) }
                        .buttonStyle(ChunkyButtonStyle(color: Theme.good, font: Theme.body(18)))
                }
                .disabled(answered)
            }
        }
    }

    private var checklist: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🕵️ Modo detective: revisa tu frase").font(Theme.body(19)).foregroundStyle(Theme.ink)
            ForEach(items, id: \.self) { item in
                Button {
                    if ticked.contains(item) { ticked.remove(item) } else { ticked.insert(item) }
                    Haptics.tap()
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: ticked.contains(item) ? "checkmark.square.fill" : "square")
                            .font(.title2)
                            .foregroundStyle(ticked.contains(item) ? Theme.good : Theme.ink.opacity(0.4))
                        Text(item).font(Theme.body(18)).foregroundStyle(Theme.ink).multilineTextAlignment(.leading)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }

    private func answer(_ correct: Bool) {
        answered = true
        onAnswer(ExerciseResult(correct: correct, given: correct ? nil : "(en papel)"))
    }
}
