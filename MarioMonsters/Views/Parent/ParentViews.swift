import SwiftData
import SwiftUI

/// Simple 4-digit PIN so Mario does not wander into the settings.
struct ParentGateView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(SettingsKey.parentPIN) private var pin = ""
    @State private var entered = ""
    @State private var firstEntry: String?
    @State private var unlocked = false
    @State private var error = false

    var body: some View {
        NavigationStack {
            Group {
                if unlocked {
                    ParentDashboardView()
                } else {
                    keypad
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") { dismiss() }
                }
            }
        }
    }

    private var title: String {
        if pin.isEmpty { return firstEntry == nil ? "Crea un PIN de 4 cifras" : "Repite el PIN" }
        return "Zona de padres"
    }

    private var keypad: some View {
        VStack(spacing: 24) {
            Text(title).font(Theme.title(26))
            HStack(spacing: 16) {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index < entered.count ? Theme.ink : Color.black.opacity(0.1))
                        .frame(width: 18, height: 18)
                }
            }
            .modifier(Shake(animatable: error ? 1 : 0))
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(84), spacing: 16), count: 3), spacing: 16) {
                ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "⌫"], id: \.self) { key in
                    if key.isEmpty {
                        Color.clear.frame(height: 64)
                    } else {
                        Button(key) { press(key) }
                            .buttonStyle(ChunkyButtonStyle(color: .white, textColor: Theme.ink, font: Theme.title(26)))
                    }
                }
            }
            if pin.isEmpty {
                Text("Con el PIN entras al progreso y a los ajustes.").font(.footnote).foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
    }

    private func press(_ key: String) {
        error = false
        if key == "⌫" {
            if !entered.isEmpty { entered.removeLast() }
            return
        }
        guard entered.count < 4 else { return }
        entered += key
        guard entered.count == 4 else { return }

        if pin.isEmpty {
            if let first = firstEntry {
                if first == entered {
                    pin = entered
                    unlocked = true
                } else {
                    fail()
                    firstEntry = nil
                }
            } else {
                firstEntry = entered
            }
            entered = ""
        } else if entered == pin {
            unlocked = true
        } else {
            fail()
            entered = ""
        }
    }

    private func fail() {
        Haptics.error()
        withAnimation(.default) { error = true }
    }
}

private struct Shake: GeometryEffect {
    var animatable: CGFloat
    var animatableData: CGFloat {
        get { animatable }
        set { animatable = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 10 * sin(animatable * .pi * 4), y: 0))
    }
}

struct ParentDashboardView: View {
    @Query(sort: \SessionLog.date, order: .reverse) private var sessions: [SessionLog]
    @Query private var progress: [CardProgress]
    @Query(sort: \AttemptLog.date, order: .reverse) private var attempts: [AttemptLog]
    @AppStorage(SettingsKey.enabledMonsters) private var enabledRaw = MonsterSelection.defaultRaw

    private var boxes: [String: Int] {
        Dictionary(progress.map { ($0.cardID, $0.box) }, uniquingKeysWith: { a, _ in a })
    }

    private var weekSessions: [SessionLog] {
        let start = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
        return sessions.filter { $0.date >= start }
    }

    /// Cards Mario gets wrong most often, with his latest wrong answer.
    private var topErrors: [(card: Card, wrong: Int, last: String?)] {
        progress
            .filter { $0.timesWrong > 0 }
            .sorted { $0.timesWrong > $1.timesWrong }
            .prefix(8)
            .compactMap { item in Curriculum.card(id: item.cardID).map { ($0, item.timesWrong, item.lastWrong) } }
    }

    private var accuracyByKind: [(kind: ExerciseKind, correct: Int, total: Int)] {
        ExerciseKind.allCases.compactMap { kind in
            let judged = attempts.filter { $0.kindRaw == kind.rawValue && $0.correct != nil }
            guard !judged.isEmpty else { return nil }
            return (kind, judged.filter { $0.correct == true }.count, judged.count)
        }
    }

    var body: some View {
        List {
            Section("Esta semana") {
                stat("Racha", "\(Streak.days(sessionDates: sessions.map(\.date))) días")
                stat("Sesiones", "\(weekSessions.count)")
                stat("Minutos", "\(Int(weekSessions.reduce(0) { $0 + $1.duration } / 60))")
                let answered = weekSessions.reduce(0) { $0 + $1.answered }
                let correct = weekSessions.reduce(0) { $0 + $1.correct }
                stat("Aciertos", answered == 0 ? "—" : "\(correct * 100 / answered) %")
            }

            Section {
                ForEach(MonsterID.allCases.filter(MonsterSelection.decode(enabledRaw).contains)) { monster in
                    let mastered = MonsterStats.mastered(of: monster, boxes: boxes)
                    HStack(spacing: 12) {
                        MonsterView(monster: monster, size: 36)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(monster.info.name).font(.headline)
                            Text(monster.info.tagline).font(.caption).foregroundStyle(.secondary)
                            HealthBar(value: 1 - MonsterStats.health(of: monster, boxes: boxes), color: monster.color)
                        }
                        Text("\(mastered.done)/\(mastered.total)").font(.callout.monospacedDigit())
                    }
                }
            } header: {
                Text("Dominio por tipo de error")
            } footer: {
                Text("Una palabra o frase está «dominada» cuando la ha hecho bien varias veces en días distintos, hasta escribirla sin ayuda.")
            }

            Section("Errores que más se repiten") {
                if topErrors.isEmpty {
                    Text("Todavía no hay datos.").foregroundStyle(.secondary)
                }
                ForEach(topErrors, id: \.card.id) { item in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.card.english).font(.headline)
                        if let last = item.last {
                            Text("Escribió: \(last)").font(.callout).foregroundStyle(Theme.bad)
                        }
                        Text("\(item.wrong) fallos · \(item.card.monster.info.name)").font(.caption).foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                ForEach(accuracyByKind, id: \.kind) { item in
                    stat(item.kind.parentLabel, "\(item.correct * 100 / item.total) % (\(item.total))")
                }
            } header: {
                Text("Aciertos por tipo de ejercicio")
            } footer: {
                Text("Lo normal es que «Oír» y «Decir» vayan por delante y «Escribir» por detrás. Si «Escribir en papel» sube, se nota en el colegio.")
            }

            Section {
                NavigationLink("Ajustes") { ParentSettingsView() }
            }
        }
        .navigationTitle("Progreso")
    }

    private func stat(_ title: String, _ value: String) -> some View {
        LabeledContent(title, value: value)
    }
}

struct ParentSettingsView: View {
    @Environment(\.modelContext) private var context
    @AppStorage(SettingsKey.childName) private var childName = "Mario"
    @AppStorage(SettingsKey.speechRate) private var speechRate = SettingsKey.defaultSpeechRate
    @AppStorage(SettingsKey.speechEnabled) private var speechEnabled = true
    @AppStorage(SettingsKey.spanishVoiceHelp) private var spanishVoiceHelp = true
    @AppStorage(SettingsKey.sessionLength) private var sessionLength = 10
    @AppStorage(SettingsKey.parentPIN) private var pin = ""
    @AppStorage(SettingsKey.enabledMonsters) private var enabledRaw = MonsterSelection.defaultRaw
    @State private var confirmReset = false

    var body: some View {
        Form {
            Section("Niño") {
                TextField("Nombre", text: $childName)
            }
            Section {
                Stepper("Tarjetas por sesión: \(sessionLength)", value: $sessionLength, in: 6...20, step: 2)
            } footer: {
                Text("10 tarjetas son unos 8–12 minutos. Mejor poco y todos los días que mucho de golpe.")
            }
            Section("Voz") {
                VStack(alignment: .leading) {
                    Text("Velocidad del inglés")
                    Slider(value: $speechRate, in: 0.3...0.55)
                }
                Button("Probar voz") { Speaker.shared.english("She has got curly hair.") }
                Toggle("Ejercicio «Dilo» con micrófono", isOn: $speechEnabled)
                Toggle("Ánimos en español en voz alta", isOn: $spanishVoiceHelp)
            }
            Section {
                NavigationLink {
                    MonsterSettingsView()
                } label: {
                    LabeledContent("Monstruos", value: "\(MonsterSelection.decode(enabledRaw).count) de \(MonsterID.allCases.count) activos")
                }
            } footer: {
                Text("Gramática y vocabulario de todo el nivel Movers. Actívalos según los vayan dando en clase.")
            }
            Section {
                Button("Cambiar PIN") { pin = "" }
                Button("Borrar todo el progreso", role: .destructive) { confirmReset = true }
            }
        }
        .navigationTitle("Ajustes")
        .confirmationDialog("¿Borrar todo el progreso de \(childName)?", isPresented: $confirmReset, titleVisibility: .visible) {
            Button("Borrar", role: .destructive) { ProgressStore(context: context).resetAll() }
        } message: {
            Text("No se puede deshacer.")
        }
    }
}

/// Which monsters appear in the missions: the typical errors are on by default, the Movers packs are opt-in.
struct MonsterSettingsView: View {
    @AppStorage(SettingsKey.enabledMonsters) private var enabledRaw = MonsterSelection.defaultRaw

    private var enabled: Set<MonsterID> { MonsterSelection.decode(enabledRaw) }

    var body: some View {
        Form {
            Section {
                Button("Activar todos") { enabledRaw = MonsterSelection.encode(Set(MonsterID.allCases)) }
                    .disabled(enabled.count == MonsterID.allCases.count)
                Button("Volver a los de por defecto") { enabledRaw = MonsterSelection.defaultRaw }
                    .disabled(enabled == Set(MonsterID.defaultEnabled))
            } footer: {
                Text("Ve activando cada tema cuando lo den en el colegio. Desactivar un monstruo no borra su progreso: solo deja de salir en las misiones.")
            }

            ForEach(MonsterGroup.allCases) { group in
                Section {
                    ForEach(group.monsters) { monster in
                        Toggle(isOn: binding(for: monster)) {
                            HStack(spacing: 12) {
                                MonsterView(monster: monster, size: 36)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(monster.info.name).font(.headline)
                                    Text(monster.info.tagline).font(.caption).foregroundStyle(.secondary)
                                    Text("\(Curriculum.cards(for: monster).count) tarjetas")
                                        .font(.caption2).foregroundStyle(.secondary)
                                }
                            }
                        }
                        .disabled(enabled == [monster])
                    }
                } header: {
                    groupHeader(group)
                } footer: {
                    Text(group.footer)
                }
            }
        }
        .navigationTitle("Monstruos")
    }

    private func groupHeader(_ group: MonsterGroup) -> some View {
        let members = Set(group.monsters)
        let allOn = members.isSubset(of: enabled)
        let remaining = allOn ? enabled.subtracting(members) : enabled.union(members)
        return HStack {
            Text(group.title)
            Spacer()
            Button(allOn ? "Desactivar todos" : "Activar todos") {
                enabledRaw = MonsterSelection.encode(remaining)
            }
            .buttonStyle(.borderless)
            .textCase(nil)
            .disabled(remaining.isEmpty)
        }
    }

    private func binding(for monster: MonsterID) -> Binding<Bool> {
        Binding {
            enabled.contains(monster)
        } set: { isOn in
            var set = enabled
            if isOn { set.insert(monster) } else { set.remove(monster) }
            guard !set.isEmpty else { return }
            enabledRaw = MonsterSelection.encode(set)
        }
    }
}
