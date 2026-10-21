import SwiftUI

struct SessionView: View {
    @Bindable var model: SessionModel
    @Environment(\.dismiss) private var dismiss
    @AppStorage(SettingsKey.childName) private var childName = "Mario"

    @State private var mood: MonsterMood = .idle
    @State private var shake = 0
    @State private var bubble: String?
    @State private var confirmQuit = false
    @State private var scroll = ScrollPosition(edge: .top)

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            if model.phase == .finished {
                SummaryView(model: model) { dismiss() }
                    .transition(.opacity)
            } else if let exercise = model.current {
                VStack(spacing: 0) {
                    topBar
                    ScrollView {
                        VStack(spacing: 18) {
                            monsterStrip(exercise.card.monster)
                            ExerciseView(exercise: exercise, onAnswer: answer) {
                                withAnimation(.spring) { model.skipCurrent() }
                            }
                                .id(exercise.id)
                                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 200)
                        .readableWidth()
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .scrollPosition($scroll)
                }
                .overlay(alignment: .bottom) {
                    if case .feedback(let result) = model.phase {
                        FeedbackPanel(card: exercise.card, kind: exercise.kind, result: result) {
                            withAnimation(.spring) {
                                mood = .idle
                                bubble = nil
                                model.next()
                            }
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .animation(.spring(duration: 0.35), value: model.phase)
        .animation(.spring(duration: 0.35), value: model.index)
        // A new card starts from the top, with the monster in view.
        .onChange(of: model.current?.id) { scroll.scrollTo(edge: .top) }
        .alert("¿Salir de la misión?", isPresented: $confirmQuit) {
            Button("Cancelar", role: .cancel) {}
            Button("Salir", role: .destructive) {
                model.finish()
                dismiss()
            }
        } message: {
            Text("Todo lo que has hecho hasta ahora queda guardado. Podrás seguir en la próxima misión.")
        }
        .onDisappear { Speaker.shared.stop() }
    }

    private var topBar: some View {
        HStack(spacing: 14) {
            Button {
                confirmQuit = true
            } label: {
                Image(systemName: "xmark").font(.system(size: 20, weight: .heavy)).foregroundStyle(Theme.ink.opacity(0.5))
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Salir")
            ProgressView(value: model.progress)
                .progressViewStyle(.linear)
                .tint(Theme.good)
                .scaleEffect(y: 3)
            Text("\(model.correctCount) ⭐").font(Theme.body(18)).foregroundStyle(Theme.ink)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .readableWidth()
    }

    private func monsterStrip(_ monster: MonsterID) -> some View {
        HStack(spacing: 12) {
            MonsterView(monster: monster, mood: mood, size: 76, trigger: shake)
            VStack(alignment: .leading, spacing: 4) {
                Text(monster.info.name).font(Theme.body(16)).foregroundStyle(monster.color)
                Text(bubble ?? monster.info.taunts.first ?? "")
                    .font(Theme.body(16))
                    .foregroundStyle(Theme.ink)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 14).fill(.white))
            }
            Spacer(minLength: 0)
        }
        .padding(.top, 6)
    }

    private func answer(_ result: ExerciseResult) {
        guard let card = model.current?.card else { return }
        let info = card.monster.info
        switch result.correct {
        case true?:
            mood = .hit
            bubble = info.hits.randomElement()
            Haptics.success()
            Speaker.shared.spanishHelp(["¡Muy bien, \(childName)!", "¡Genial!", "¡Toma ya!", "¡Perfecto!"].randomElement()!)
        case false?:
            mood = .laugh
            bubble = info.taunts.randomElement()
            Haptics.error()
            Speaker.shared.english(card.english)
        case nil:
            mood = .idle
            bubble = "¡Seguimos!"
        }
        shake += 1
        withAnimation(.spring) { model.submit(result) }
    }
}

/// Immediate, specific feedback: the right form, Mario's form next to it, and why.
struct FeedbackPanel: View {
    let card: Card
    let kind: ExerciseKind
    let result: ExerciseResult
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            switch result.correct {
            case true?:
                Label("¡Bien hecho!", systemImage: "checkmark.circle.fill")
                    .font(Theme.title(26)).foregroundStyle(Theme.good)
                if kind != .listenChoose {
                    answerRow(Text(card.english).font(Theme.body(20)).foregroundStyle(Theme.ink))
                }
            case false?:
                Label("¡Casi! Así se escribe:", systemImage: "lightbulb.fill")
                    .font(Theme.title(24)).foregroundStyle(Theme.bad)
                // The answer gets the full width so it can wrap instead of being cut by the buttons.
                Text("✅ \(card.english)")
                    .font(Theme.title(24)).foregroundStyle(Theme.good)
                    .fixedSize(horizontal: false, vertical: true)
                answerRow(Group {
                    if let given = result.given, kind != .paper {
                        Text("❌ \(given)")
                            .font(Theme.body(19))
                            .strikethrough(color: Theme.bad)
                            .foregroundStyle(Theme.ink.opacity(0.6))
                    }
                })
                Button {
                    Speaker.shared.spanish(card.explanation)
                } label: {
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "speaker.wave.1.fill")
                        Text(card.explanation).multilineTextAlignment(.leading)
                    }
                    .font(Theme.body(17))
                    .foregroundStyle(Theme.ink)
                }
                .buttonStyle(.plain)
            case nil:
                Label("¡Seguimos!", systemImage: "arrow.right.circle.fill")
                    .font(Theme.title(24)).foregroundStyle(Theme.neutral)
                answerRow(Text(card.english).font(Theme.body(20)).foregroundStyle(Theme.ink))
            }
            Button(action: onContinue) {
                Text("Continuar").frame(maxWidth: .infinity)
            }
            .buttonStyle(ChunkyButtonStyle(color: color))
        }
        .padding(20)
        .readableWidth()
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 28, topTrailingRadius: 28)
                .fill(color.mix(with: .white, by: 0.85))
                .shadow(color: .black.opacity(0.15), radius: 12, y: -4)
                .ignoresSafeArea()
        )
    }

    /// Text on the left (wrapping), normal + slow audio on the right.
    private func answerRow(_ content: some View) -> some View {
        HStack(alignment: .center, spacing: 12) {
            content
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            AudioButtons(text: card.english, size: 44, axis: .horizontal)
        }
    }

    private var color: Color {
        switch result.correct {
        case true?: Theme.good
        case false?: Theme.bad
        case nil: Theme.neutral
        }
    }
}

struct SummaryView: View {
    let model: SessionModel
    let onDone: () -> Void

    @State private var shown = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Text(model.answeredCount == 0 ? "¡Hasta la próxima!" : "¡Misión cumplida!")
                    .font(Theme.title(34)).foregroundStyle(Theme.ink)
                HStack(spacing: 10) {
                    ForEach(0..<3) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 54))
                            .foregroundStyle(index < model.stars ? Theme.gold : Color.black.opacity(0.1))
                            .scaleEffect(index < shown ? 1 : 0.3)
                            .animation(.spring(bounce: 0.6).delay(Double(index) * 0.25), value: shown)
                    }
                }
                Text("\(model.correctCount) de \(model.answeredCount) bien")
                    .font(Theme.body(22)).foregroundStyle(Theme.ink)

                damage

                if !model.mistakes.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("🔎 Errores cazados hoy").font(Theme.title(22)).foregroundStyle(Theme.ink)
                        Text("Cada error que cazas es un error que ya no vuelves a cometer.")
                            .font(Theme.body(16)).foregroundStyle(Theme.ink.opacity(0.6))
                        ForEach(uniqueMistakes) { mistake in
                            VStack(alignment: .leading, spacing: 2) {
                                if let given = mistake.given, given != "(en papel)" {
                                    Text("❌ \(given)").strikethrough().foregroundStyle(Theme.ink.opacity(0.5))
                                }
                                Text("✅ \(mistake.card.english)").foregroundStyle(Theme.good)
                            }
                            .font(Theme.body(18))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .cardStyle()
                }

                Button("¡Terminar!", action: onDone)
                    .buttonStyle(ChunkyButtonStyle(color: Theme.good, font: Theme.title(24)))
            }
            .padding(24)
            .readableWidth()
        }
        .onAppear {
            shown = 3
            Speaker.shared.spanishHelp(model.stars == 3 ? "¡Increíble! ¡Tres estrellas!" : "¡Muy bien! ¡Misión cumplida!")
        }
    }

    private var uniqueMistakes: [Mistake] {
        var seen = Set<String>()
        return model.mistakes.filter { seen.insert($0.card.id).inserted }
    }

    private var damage: some View {
        let monsters = MonsterID.allCases.filter { (model.startHealth[$0] ?? 1) - model.healthNow($0) > 0.0001 }
        return Group {
            if !monsters.isEmpty {
                VStack(spacing: 12) {
                    Text("Monstruos dañados").font(Theme.body(18)).foregroundStyle(Theme.ink.opacity(0.7))
                    ForEach(monsters) { monster in
                        HStack(spacing: 12) {
                            MonsterView(monster: monster, mood: model.healthNow(monster) <= 0 ? .defeated : .hit, size: 50)
                            VStack(alignment: .leading) {
                                Text(monster.info.name).font(Theme.body(16)).foregroundStyle(Theme.ink)
                                HealthBar(value: model.healthNow(monster), color: monster.color)
                            }
                        }
                    }
                }
                .cardStyle()
            }
        }
    }
}
