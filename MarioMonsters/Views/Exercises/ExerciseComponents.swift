import SwiftUI

/// Dispatches to the right exercise for the card's rung on the ladder.
struct ExerciseView: View {
    let exercise: Exercise
    let onAnswer: (ExerciseResult) -> Void

    var body: some View {
        Group {
            switch exercise.kind {
            case .listenChoose: ListenChooseView(exercise: exercise, onAnswer: onAnswer)
            case .sayIt: SayItView(exercise: exercise, onAnswer: onAnswer)
            case .build: BuildView(exercise: exercise, repair: false, onAnswer: onAnswer)
            case .repair: BuildView(exercise: exercise, repair: true, onAnswer: onAnswer)
            case .spellTiles: SpellView(exercise: exercise, keyboard: false, onAnswer: onAnswer)
            case .spellKeyboard: SpellView(exercise: exercise, keyboard: true, onAnswer: onAnswer)
            case .paper: PaperView(exercise: exercise, onAnswer: onAnswer)
            }
        }
        .onAppear {
            if exercise.autoplay, exercise.kind != .paper {
                Speaker.shared.english(exercise.card.english)
            }
        }
        .onDisappear { Speaker.shared.stop() }
    }
}

/// The instruction line, in Spanish, with a button that reads it aloud.
struct InstructionView: View {
    let text: String

    var body: some View {
        Button {
            Speaker.shared.spanish(text)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "speaker.wave.1.fill").font(.callout)
                Text(text).font(Theme.body(18)).multilineTextAlignment(.leading)
            }
            .foregroundStyle(Theme.ink.opacity(0.75))
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Picture + Spanish meaning + English audio buttons (normal and tortoise).
struct PromptCard: View {
    let card: Card
    var showsEnglish = false
    var showsAudio = true

    var body: some View {
        HStack(spacing: 16) {
            Text(card.emoji).font(.system(size: 54))
            VStack(alignment: .leading, spacing: 4) {
                if showsEnglish {
                    Text(card.english).font(Theme.title(28)).foregroundStyle(Theme.ink)
                }
                Text(card.spanish)
                    .font(showsEnglish ? Theme.body(17) : Theme.title(24))
                    .foregroundStyle(showsEnglish ? Theme.ink.opacity(0.6) : Theme.ink)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if showsAudio {
                VStack(spacing: 10) {
                    SpeakButton { Speaker.shared.english(card.english) }
                    SpeakButton(action: { Speaker.shared.english(card.english, slow: true) }, systemImage: "tortoise.fill", size: 44, color: Theme.good)
                }
            }
        }
        .cardStyle()
    }
}

struct TileView: View {
    let text: String
    var color: Color = .white
    var dimmed = false

    var body: some View {
        Text(text)
            .font(Theme.body(22))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 14)
            .frame(minWidth: 44, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color)
                    .shadow(color: .black.opacity(0.18), radius: 0, y: 3)
            )
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(Color.black.opacity(0.12), lineWidth: 1))
            .opacity(dimmed ? 0.25 : 1)
    }
}

struct CheckButton: View {
    let enabled: Bool
    let action: () -> Void

    var body: some View {
        Button("Comprobar", action: action)
            .buttonStyle(ChunkyButtonStyle(color: enabled ? Theme.good : .gray.opacity(0.5)))
            .disabled(!enabled)
            .frame(maxWidth: .infinity)
    }
}

extension String {
    var capitalisedFirst: String { prefix(1).uppercased() + dropFirst() }
}
