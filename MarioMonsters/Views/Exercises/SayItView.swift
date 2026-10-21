import SwiftUI

/// Rung 2 "Dilo": read the English aloud. Mario's strength (speaking) anchors the written form.
/// Recognition failures are never punished: after two tries the attempt is neutral.
struct SayItView: View {
    let exercise: Exercise
    let onAnswer: (ExerciseResult) -> Void

    @State private var listener = SpeechListener()
    @State private var attempts = 0
    @State private var message: String?
    @State private var done = false
    @State private var timeout: Task<Void, Never>?

    private static let passScore = 0.7

    var body: some View {
        VStack(spacing: 18) {
            InstructionView(text: "Lee la frase y dila en voz alta.")
            PromptCard(card: exercise.card, showsEnglish: true)

            if !listener.transcript.isEmpty {
                Text("«\(listener.transcript)»")
                    .font(Theme.body(18))
                    .foregroundStyle(Theme.ink.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            if let message {
                Text(message).font(Theme.body(18)).foregroundStyle(Theme.ink).multilineTextAlignment(.center)
            }

            Button {
                listener.state == .listening ? finishListening() : startListening()
            } label: {
                Image(systemName: listener.state == .listening ? "stop.fill" : "mic.fill")
                    .font(.system(size: 40, weight: .bold))
                    .frame(width: 96, height: 96)
                    .symbolEffect(.pulse, isActive: listener.state == .listening)
            }
            .buttonStyle(ChunkyButtonStyle(color: listener.state == .listening ? Theme.bad : Theme.neutral))
            .clipShape(Circle())
            .disabled(done)
            .accessibilityLabel(listener.state == .listening ? "Parar" : "Hablar")

            Button("Saltar") { skip() }
                .font(Theme.body(17))
                .foregroundStyle(Theme.ink.opacity(0.5))
                .disabled(done)
        }
        .onChange(of: listener.transcript) { _, text in
            guard listener.state == .listening,
                  AnswerChecker.speechScore(transcript: text, target: exercise.card.english) >= Self.passScore else { return }
            finishListening()
        }
        .onChange(of: listener.state) { old, new in
            if old == .listening, new == .idle, !done { evaluate() }
        }
        .onDisappear {
            timeout?.cancel()
            listener.stop()
        }
    }

    private func startListening() {
        Speaker.shared.stop()
        message = nil
        Task {
            guard await listener.requestAccess() else {
                message = "No puedo usar el micrófono. Dilo en voz alta igualmente y pulsa Saltar."
                return
            }
            listener.start(hint: exercise.card.english)
            if listener.state == .unavailable {
                message = "El reconocimiento de voz no está disponible ahora. Dilo en voz alta y pulsa Saltar."
                return
            }
            timeout?.cancel()
            timeout = Task {
                try? await Task.sleep(for: .seconds(7))
                guard !Task.isCancelled else { return }
                finishListening()
            }
        }
    }

    private func finishListening() {
        timeout?.cancel()
        guard listener.state == .listening else { return }
        listener.stop()
        evaluate()
    }

    private func evaluate() {
        guard !done else { return }
        let score = AnswerChecker.speechScore(transcript: listener.transcript, target: exercise.card.english)
        if score >= Self.passScore {
            done = true
            onAnswer(ExerciseResult(correct: true, given: listener.transcript))
            return
        }
        attempts += 1
        if attempts >= 2 {
            done = true
            onAnswer(ExerciseResult(correct: nil, given: listener.transcript))
        } else {
            message = "¡Casi! Escúchala otra vez y vuelve a intentarlo."
            Speaker.shared.english(exercise.card.english, slow: true)
        }
    }

    private func skip() {
        timeout?.cancel()
        listener.stop()
        done = true
        onAnswer(ExerciseResult(correct: nil, given: nil))
    }
}
