import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query private var progress: [CardProgress]
    @Query(sort: \SessionLog.date) private var sessions: [SessionLog]
    @AppStorage(SettingsKey.childName) private var childName = "Mario"
    @AppStorage(SettingsKey.sessionLength) private var sessionLength = 10
    @Environment(\.horizontalSizeClass) private var sizeClass
    @AppStorage(SettingsKey.enabledMonsters) private var enabledRaw = MonsterSelection.defaultRaw
    @AppStorage(SettingsKey.voiceSetupDismissed) private var voiceSetupDismissed = false

    @State private var session: SessionModel?
    @State private var showParent = false
    @State private var showVoiceSetup = false

    private var boxes: [String: Int] {
        Dictionary(progress.map { ($0.cardID, $0.box) }, uniquingKeysWith: { a, _ in a })
    }

    private var enabled: Set<MonsterID> { MonsterSelection.decode(enabledRaw) }

    /// Only cards of switched-on monsters count; switched-off ones keep their progress for later.
    private var dueCount: Int {
        let now = Date.now
        let enabled = enabled
        return progress.filter { item in
            item.due <= now && Curriculum.card(id: item.cardID).map { enabled.contains($0.monster) } == true
        }.count
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    header
                    missionButton
                    monsterGrid
                }
                .padding(20)
                .readableWidth()
            }
            .background(Theme.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showParent = true } label: {
                        Image(systemName: "lock.fill").foregroundStyle(Theme.ink.opacity(0.35))
                    }
                    .accessibilityLabel("Zona de padres")
                }
            }
            .navigationDestination(for: MonsterID.self) { monster in
                MonsterDetailView(monster: monster) { start(focus: monster) }
            }
        }
        .fullScreenCover(item: $session) { model in
            SessionView(model: model)
        }
        .sheet(isPresented: $showParent) {
            ParentGateView()
        }
        .sheet(isPresented: $showVoiceSetup) {
            VoiceSetupView()
        }
        .task {
            guard !voiceSetupDismissed, !Speaker.hasClearEnglishVoice,
                  !UserDefaults.standard.bool(forKey: "autostart") else { return }
            showVoiceSetup = true
        }
        #if DEBUG
        .task { debugAutostart() }
        #endif
    }

    #if DEBUG
    /// `-autostart` opens a session on launch; `-seedBox N` first puts every card on rung N (screenshots / manual QA).
    private func debugAutostart() {
        let defaults = UserDefaults.standard
        guard defaults.bool(forKey: "autostart"), session == nil else { return }
        if defaults.object(forKey: "seedBox") != nil {
            let box = defaults.integer(forKey: "seedBox")
            let store = ProgressStore(context: context)
            for card in Curriculum.all {
                let item = store.progress(for: card.id) ?? CardProgress(cardID: card.id)
                if item.modelContext == nil { context.insert(item) }
                item.box = box
                item.due = .distantPast
            }
            try? context.save()
        }
        start(focus: nil)
    }
    #endif

    private var header: some View {
        VStack(spacing: 6) {
            Text("Mario vs. the Word Monsters")
                .font(Theme.title(16)).foregroundStyle(Theme.ink.opacity(0.5))
            Text("¡Hola, \(childName)!").font(Theme.title(36)).foregroundStyle(Theme.ink)
            HStack(spacing: 18) {
                Label("\(Streak.days(sessionDates: sessions.map(\.date))) días", systemImage: "flame.fill")
                    .foregroundStyle(.orange)
                Label("\(sessions.reduce(0) { $0 + $1.stars })", systemImage: "star.fill")
                    .foregroundStyle(Theme.gold)
            }
            .font(Theme.body(20))
        }
    }

    private var missionButton: some View {
        Button { start(focus: nil) } label: {
            VStack(spacing: 4) {
                Text("⚔️ ¡Misión de hoy!").font(Theme.title(28))
                Text(dueCount > 0 ? "\(dueCount) palabras y frases te esperan" : "Unos 10 minutos")
                    .font(Theme.body(16)).opacity(0.85)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(ChunkyButtonStyle(color: Theme.good))
    }

    private var monsterGrid: some View {
        // Two columns on iPhone, three on iPad: wide enough that every name fits in two lines.
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: sizeClass == .regular ? 3 : 2), spacing: 16) {
            ForEach(MonsterID.allCases.filter(enabled.contains)) { monster in
                NavigationLink(value: monster) {
                    MonsterCard(monster: monster, boxes: boxes)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func start(focus: MonsterID?) {
        Speaker.shared.stop()
        session = SessionModel(store: ProgressStore(context: context), focus: focus, length: sessionLength,
                               skills: .current(), cards: MonsterSelection.cards(enabled: enabled))
    }
}

private struct MonsterCard: View {
    let monster: MonsterID
    let boxes: [String: Int]

    var body: some View {
        let health = MonsterStats.health(of: monster, boxes: boxes)
        let mastered = MonsterStats.mastered(of: monster, boxes: boxes)
        VStack(spacing: 8) {
            MonsterView(monster: monster, mood: health <= 0 ? .defeated : .idle, size: 90)
            // Two lines reserved always, so a long name doesn't make its card taller than the rest.
            Text(monster.info.name).font(Theme.body(17)).foregroundStyle(Theme.ink).multilineTextAlignment(.center)
                .lineLimit(2, reservesSpace: true).minimumScaleFactor(0.8)
            HealthBar(value: health, color: monster.color)
            Text(health <= 0 ? "¡Derrotado! 🏆" : "\(mastered.done) / \(mastered.total) dominadas")
                .font(Theme.body(13)).foregroundStyle(Theme.ink.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .cardStyle(padding: 14)
    }
}

struct MonsterDetailView: View {
    let monster: MonsterID
    let onFight: () -> Void

    @Query private var progress: [CardProgress]

    private var examples: [Card] {
        let cards = Curriculum.cards(for: monster)
        return Array((cards.filter { $0.kind == .sentence } + cards.filter { $0.kind == .word }).prefix(3))
    }

    var body: some View {
        let info = monster.info
        let boxes = Dictionary(progress.map { ($0.cardID, $0.box) }, uniquingKeysWith: { a, _ in a })
        ScrollView {
            VStack(spacing: 20) {
                MonsterView(monster: monster, mood: MonsterStats.health(of: monster, boxes: boxes) <= 0 ? .defeated : .laugh, size: 150)
                Text(info.name).font(Theme.title(32)).foregroundStyle(monster.color)
                Text(info.tagline).font(Theme.body(19)).foregroundStyle(Theme.ink)
                HealthBar(value: MonsterStats.health(of: monster, boxes: boxes), color: monster.color)
                    .frame(maxWidth: 260)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("📜 Su punto débil").font(Theme.title(20)).foregroundStyle(Theme.ink)
                        Spacer()
                        SpeakButton(action: { Speaker.shared.spanish(info.lesson) }, size: 44)
                    }
                    Text(info.lesson).font(Theme.body(18)).foregroundStyle(Theme.ink)
                }
                .cardStyle()

                VStack(alignment: .leading, spacing: 14) {
                    Text("Así ataca el monstruo:").font(Theme.title(20)).foregroundStyle(Theme.ink)
                    ForEach(examples) { card in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("❌ \(card.wrong[0])").strikethrough().foregroundStyle(Theme.bad.opacity(0.8))
                            HStack {
                                Text("✅ \(card.english)").foregroundStyle(Theme.good)
                                Spacer()
                                Button { Speaker.shared.english(card.english) } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                }
                                .accessibilityLabel("Escuchar")
                            }
                        }
                        .font(Theme.body(19))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .cardStyle()

                Button(action: onFight) {
                    Text("⚔️ ¡A luchar!").frame(maxWidth: .infinity)
                }
                .buttonStyle(ChunkyButtonStyle(color: monster.color, font: Theme.title(26)))
            }
            .padding(20)
            .readableWidth()
        }
        .background(Theme.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
