import SwiftUI

/// Rung 1 "Oye": hear it, then pick the right spelling from Mario's own typical mistakes.
struct ListenChooseView: View {
    let exercise: Exercise
    let onAnswer: (ExerciseResult) -> Void

    @State private var options: [String] = []
    @State private var chosen: String?

    var body: some View {
        VStack(spacing: 18) {
            InstructionView(text: "Escucha y elige cómo se escribe.")
            PromptCard(card: exercise.card)
            // Wide gaps: the buttons' 3D edge ate most of the old 12 pt, and Mario brushed two at once.
            VStack(spacing: 30) {
                ForEach(options, id: \.self) { option in
                    Button {
                        choose(option)
                    } label: {
                        Text(option)
                            .font(Theme.title(exercise.card.kind == .word ? 30 : 22))
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(ChunkyButtonStyle(color: color(for: option), textColor: chosen == nil ? Theme.ink : .white))
                    .disabled(chosen != nil)
                }
            }
        }
        .onAppear {
            if options.isEmpty {
                options = ([exercise.card.english] + exercise.card.wrong.prefix(2)).shuffled()
            }
        }
    }

    private func color(for option: String) -> Color {
        guard let chosen else { return .white }
        if option == exercise.card.english { return Theme.good }
        return option == chosen ? Theme.bad : .white.opacity(0.6)
    }

    private func choose(_ option: String) {
        // Two fingers at once can fire two buttons before they disable: only the first one counts.
        guard chosen == nil else { return }
        chosen = option
        onAnswer(ExerciseResult(correct: option == exercise.card.english, given: option))
    }
}
