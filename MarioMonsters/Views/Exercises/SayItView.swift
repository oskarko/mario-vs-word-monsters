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
    @State private var finishing = false

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
            .disabled(done || finishing)
            .accessibilityLabel(listener.state == .listening ? "Parar" : "Hablar")

            Button("Saltar") { skip() }
                .font(Theme.body(17))
                .foregroundStyle(Theme.ink.opacity(0.5))
                .disabled(done)
        }
        .onChange(of: listener.transcript) { _, text in
            // Only stop early once every word is heard, and leave a moment for the end of the sentence.
            guard listener.state == .listening, !finishing,
                  AnswerChecker.speechScore(transcript: text, target: exercise.card.english) >= 1 else { return }
            finishing = true
            Task {
                try? await Task.sleep(for: .milliseconds(600))
                finishListening()
            }
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
        finishing = false
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
                try? await Task.sleep(for: .seconds(10))
                guard !Task.isCancelled else { return }
                finishListening()
            }
        }
    }

    /// Stops the mic, then waits briefly for the recognizer's final words; evaluation happens when it goes idle.
    private func finishListening() {
        timeout?.cancel()
        guard listener.state == .listening else { return }
        finishing = true
        listener.finishAudio()
        Task {
            try? await Task.sleep(for: .milliseconds(1500))
            if listener.state == .listening { listener.stop() }
        }
    }

    private func evaluate() {
        guard !done else { return }
        finishing = false
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
