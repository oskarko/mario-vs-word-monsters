import Foundation

/// Each monster is a recurring root error (or a Movers topic), externalised as a character.
enum MonsterID: String, CaseIterable, Codable, Identifiable, Sendable {
    // Typical errors, from Mario's notebook.
    case ae, noNo, jumper, snake, traps, gotLost
    // Movers grammar.
    case mixer, yesterday, bigger, nowNow, octopus, apostrophe, plurals, bossy, snail, linker
    // Movers vocabulary.
    case animals, body, clothes, family, food, home, school, sports, town, nature, transport, time, jobs, numbers, feelings

    var id: String { rawValue }

    var group: MonsterGroup {
        switch self {
        case .ae, .noNo, .jumper, .snake, .traps, .gotLost: .core
        case .mixer, .yesterday, .bigger, .nowNow, .octopus, .apostrophe, .plurals, .bossy, .snail, .linker: .grammar
        default: .vocabulary
        }
    }

    /// The typical errors start switched on; Movers topics are switched on by a parent as they come up at school.
    static let defaultEnabled: [MonsterID] = allCases.filter { $0.group == .core }
}

enum MonsterGroup: String, CaseIterable, Identifiable, Sendable {
    case core, grammar, vocabulary

    var id: String { rawValue }

    var title: String {
        switch self {
        case .core: "Errores típicos"
        case .grammar: "Gramática Movers"
        case .vocabulary: "Vocabulario Movers"
        }
    }

    var footer: String {
        switch self {
        case .core: "Los errores de raíz de los niños hispanohablantes, sacados de fichas reales."
        case .grammar: "El resto de la gramática del nivel Cambridge Movers (A1). Actívalos cuando lo vean en clase."
        case .vocabulary: "Las palabras del nivel Movers por temas, con las faltas típicas de quien escribe como suena."
        }
    }

    var monsters: [MonsterID] { MonsterID.allCases.filter { $0.group == self } }
}

enum CardKind: String, Codable, Sendable {
    case word, sentence
}

/// A single thing to learn: a tricky word or a sentence, plus the mistakes Mario
/// actually makes with it (taken from his notebook).
struct Card: Identifiable, Hashable, Sendable {
    let monster: MonsterID
    let kind: CardKind
    let english: String
    let spanish: String
    let emoji: String
    /// Wrong versions, most typical first. Used as distractors and in "repair" exercises.
    let wrong: [String]
    /// Short explanation in Spanish shown after a mistake. Falls back to the monster's lesson.
    let tip: String?

    /// Stable as long as the English text does not change, so progress survives content edits.
    var id: String { "\(monster.rawValue):\(english)" }

    var explanation: String { tip ?? monster.info.lesson }
    var isQuestion: Bool { english.hasSuffix("?") }
}

struct MonsterInfo: Sendable {
    let name: String
    let tagline: String
    let lesson: String
    let emblem: String
    let taunts: [String]
    let hits: [String]
}

extension MonsterID {
    var info: MonsterInfo {
        switch self {
        case .ae:
            MonsterInfo(
                name: "Monstruo Ae",
                tagline: "Escribe las palabras como suenan.",
                lesson: "En inglés las palabras no se escriben como suenan. Suena «ai», pero se escribe I. Suena «gud», pero se escribe good. ¡Hazle una foto a la palabra con los ojos y guárdala en tu cabeza!",
                emblem: "Ae",
                taunts: ["¡Jejeje! ¡Escríbelo como suena!", "¡Ae, Ae, Ae!", "¡Suena así, escríbelo así! Jejeje"],
                hits: ["¡Aaay! ¡Lo has escrito bien!", "¡Nooo! ¡Te sabes la foto de la palabra!", "¡Ouch! ¡Esa letra me ha dolido!"]
            )
        case .noNo:
            MonsterInfo(
                name: "El No-No",
                tagline: "Mete «no» del español para negar.",
                lesson: "En inglés, «no» solo vale para contestar: No, I haven't. Para decir que algo no es o no puedes, usa isn't, aren't, can't, don't o haven't got. ¡Nada de un «no» suelto en medio!",
                emblem: "NO",
                taunts: ["¡No, no y no! Jejeje", "¡Pon un «no» y ya está!", "¡NO-NO-NO!"],
                hits: ["¡Ay! ¡Has usado la negación buena!", "¡Mi «no» no funciona contigo!", "¡Grrr! ¡Isn't, don't…! ¡Te las sabes!"]
            )
        case .jumper:
            MonsterInfo(
                name: "Verbo Saltarín",
                tagline: "Hace preguntas sin mover el verbo.",
                lesson: "Para preguntar en inglés, el verbo salta al principio. She is happy se convierte en Is she happy? Si no hay verbo que salte, salta Do o Does: Does she play chess? ¡Y el signo de pregunta va solo al final!",
                emblem: "?",
                taunts: ["¡Boing! ¡No me muevo!", "¡Pon ¿? y listo! Jejeje", "¡Boing boing!"],
                hits: ["¡Boing! ¡Me has hecho saltar!", "¡Ay! ¡El verbo está delante!", "¡Nooo, sabes hacer preguntas!"]
            )
        case .snake:
            MonsterInfo(
                name: "Serpiente de la S",
                tagline: "Se come la S de he, she, it.",
                lesson: "Cuando hablas de él, de ella o de una cosa, el verbo lleva una s o cambia un poco: she plays, he watches, she is, he has got. Con I, you, we y they no cambia: I play, they play. Antes de escribir, piensa: ¿quién lo hace?",
                emblem: "S",
                taunts: ["Ssssss… ¡me como tu S!", "Ssss… she play… jejeje", "¡Ñam! ¡Otra S para mí!"],
                hits: ["¡Sssss! ¡Has protegido la S!", "¡Ay! ¡Sabes quién es!", "¡Ssss…! ¡Me quedo sin comer!"]
            )
        case .traps:
            MonsterInfo(
                name: "Trampas Españolas",
                tagline: "Traduce palabra por palabra.",
                lesson: "Hay cosas que en inglés se dicen de otra manera. Hay se dice There is o There are. Tengo 8 años se dice I am 8 years old. Pelo rubio se dice blonde hair, con el color delante. ¡No lo traduzcas palabra por palabra!",
                emblem: "ES",
                taunts: ["¡Tradúcelo tal cual! Jejeje", "¡Igual que en español!", "¡Caíste en mi trampa!"],
                hits: ["¡Ay! ¡Has esquivado mi trampa!", "¡Lo dices como un inglés!", "¡Nooo! ¡No has caído!"]
            )
        default:
            moversInfo
        }
    }
}
