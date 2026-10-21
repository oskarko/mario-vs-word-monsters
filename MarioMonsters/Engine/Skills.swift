import Foundation

/// The four skills of the English class. Every exercise trains mainly one of them.
enum Skill: String, CaseIterable, Identifiable, Sendable {
    case listening, speaking, reading, writing

    var id: Self { self }

    var parentLabel: String {
        switch self {
        case .listening: "Listening (escuchar)"
        case .speaking: "Speaking (hablar)"
        case .reading: "Reading (leer)"
        case .writing: "Writing (escribir)"
        }
    }

    var settingsKey: String { "skill.\(rawValue)" }
}

/// How often a skill's exercises appear, chosen in the parent area.
enum SkillLevel: String, CaseIterable, Identifiable, Sendable {
    case normal, less, never

    var id: Self { self }

    var parentLabel: String {
        switch self {
        case .normal: "Normal"
        case .less: "Menos (50 %)"
        case .never: "Nunca"
        }
    }
}

extension ExerciseKind {
    var skill: Skill {
        switch self {
        case .listenChoose: .listening
        case .sayIt: .speaking
        case .repair: .reading
        case .build, .spellTiles, .spellKeyboard, .paper: .writing
        }
    }
}

struct SkillLevels: Sendable, Equatable {
    private var levels: [Skill: SkillLevel] = [:]

    static let all = SkillLevels()

    subscript(skill: Skill) -> SkillLevel {
        get { levels[skill] ?? .normal }
        set { levels[skill] = newValue }
    }

    /// Whether this kind may be used this time: "less" lets it through half of the time.
    func allows(_ kind: ExerciseKind, roll: Double) -> Bool {
        switch self[kind.skill] {
        case .normal: true
        case .less: roll < 0.5
        case .never: false
        }
    }

    static func current(_ defaults: UserDefaults = .standard) -> SkillLevels {
        var result = SkillLevels()
        for skill in Skill.allCases {
            if let raw = defaults.string(forKey: skill.settingsKey), let level = SkillLevel(rawValue: raw) {
                result[skill] = level
            }
        }
        return result
    }

    /// The old "Dilo con micrófono" switch becomes Speaking: never.
    static func migrateLegacy(_ defaults: UserDefaults = .standard) {
        guard defaults.object(forKey: SettingsKey.speechEnabled) != nil else { return }
        if !defaults.bool(forKey: SettingsKey.speechEnabled), defaults.string(forKey: Skill.speaking.settingsKey) == nil {
            defaults.set(SkillLevel.never.rawValue, forKey: Skill.speaking.settingsKey)
        }
        defaults.removeObject(forKey: SettingsKey.speechEnabled)
    }
}
