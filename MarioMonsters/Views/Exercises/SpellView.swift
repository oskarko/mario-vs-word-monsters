import SwiftUI

/// Rungs 3–4 for words: spell letter by letter. First with the word's own letters as tiles,
/// then with a big simplified keyboard (only a few keys, so it is about spelling, not typing).
struct SpellView: View {
    let exercise: Exercise
    let keyboard: Bool
    let onAnswer: (ExerciseResult) -> Void

    private struct Letter: Identifiable, Equatable {
        let id = UUID()
        let char: Character
    }

    /// One slot per character of the target; spaces are fixed gaps.
    @State private var slots: [Letter?] = []
    @State private var bank: [Letter] = []
    @State private var keys: [Character] = []
    @State private var ready = false
    @State private var checked = false

    private var target: [Character] { Array(exercise.card.english) }

    var body: some View {
        VStack(spacing: 18) {
            InstructionView(text: keyboard ? "Escribe la palabra en inglés." : "Ordena las letras.")
            PromptCard(card: exercise.card, showsAudio: true)

            slotRow

            if keyboard {
                keyboardView
            } else {
                FlowLayout(spacing: 10) {
                    ForEach(bank) { letter in
                        Button { place(letter) } label: { TileView(text: String(letter.char)) }
                            .buttonStyle(.plain)
                    }
                }
                .frame(minHeight: 60)
            }

            CheckButton(enabled: isComplete && !checked) { check() }
        }
        .animation(.spring(duration: 0.25), value: slots)
        .onAppear(perform: setUp)
    }

    private var isComplete: Bool {
        slots.indices.allSatisfy { target[$0] == " " || slots[$0] != nil }
    }

    private var slotRow: some View {
        FlowLayout(spacing: 6) {
            ForEach(slots.indices, id: \.self) { index in
                if target[index] == " " {
                    Color.clear.frame(width: 18, height: 54)
                } else {
                    Button { remove(at: index) } label: {
                        Text(slots[index].map { String($0.char) } ?? " ")
                            .font(Theme.title(28))
                            .foregroundStyle(Theme.ink)
                            .frame(width: 40, height: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(slots[index] == nil ? Color.black.opacity(0.06) : Theme.gold.opacity(0.35))
                            )
                            .overlay(alignment: .bottom) {
                                Capsule().fill(Theme.ink.opacity(0.3)).frame(height: 3).padding(.horizontal, 6)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var keyboardView: some View {
        let columns = [GridItem(.adaptive(minimum: 58, maximum: 80), spacing: 10)]
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(keys, id: \.self) { key in
                Button { type(key) } label: {
                    Text(String(key)).font(Theme.title(28)).frame(maxWidth: .infinity)
                }
                .buttonStyle(ChunkyButtonStyle(color: .white, textColor: Theme.ink))
            }
            Button { backspace() } label: {
                Image(systemName: "delete.left.fill").font(.system(size: 24, weight: .bold)).frame(maxWidth: .infinity)
            }
            .buttonStyle(ChunkyButtonStyle(color: Theme.bad))
            .accessibilityLabel("Borrar")
        }
    }

    private func setUp() {
        guard !ready else { return }
        ready = true
        slots = Array(repeating: nil, count: target.count)
        let extra = TileFactory.distractorLetters(for: exercise.card)
        let letters = target.filter { $0 != " " } + extra
        bank = letters.shuffled().map { Letter(char: $0) }
        keys = Array(Set(letters)).sorted { String($0).lowercased() == String($1).lowercased() ? $0.isUppercase : String($0).lowercased() < String($1).lowercased() }
    }

    private var nextEmpty: Int? {
        slots.indices.first { target[$0] != " " && slots[$0] == nil }
    }

    private func place(_ letter: Letter) {
        guard !checked, let index = nextEmpty else { return }
        Haptics.tap()
        bank.removeAll { $0.id == letter.id }
        slots[index] = letter
    }

    private func type(_ key: Character) {
        guard !checked, let index = nextEmpty else { return }
        Haptics.tap()
        slots[index] = Letter(char: key)
    }

    private func backspace() {
        guard !checked, let index = slots.indices.last(where: { slots[$0] != nil }) else { return }
        slots[index] = nil
    }

    private func remove(at index: Int) {
        guard !checked, let letter = slots[index] else { return }
        slots[index] = nil
        if !keyboard { bank.append(letter) }
    }

    private func check() {
        checked = true
        let answer = String(slots.indices.map { target[$0] == " " ? " " : slots[$0]?.char ?? " " })
        onAnswer(ExerciseResult(correct: answer == exercise.card.english, given: answer))
    }
}
