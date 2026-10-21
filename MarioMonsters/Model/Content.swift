import Foundation

/// Each monster is one of Mario's recurring root errors, externalised as a character.
enum MonsterID: String, CaseIterable, Codable, Identifiable, Sendable {
    case ae, noNo, jumper, snake, traps

    var id: String { rawValue }
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
                lesson: "En inglés las palabras NO se escriben como suenan. Suena «ai» pero se escribe I. Suena «gud» pero se escribe good. ¡Mira bien cada palabra y guárdala en tu cabeza como una foto!",
                emblem: "Ae",
                taunts: ["¡Jejeje! ¡Escríbelo como suena!", "¡Ae, Ae, Ae!", "¡Suena así, escríbelo así! Jejeje"],
                hits: ["¡Aaay! ¡Lo has escrito bien!", "¡Nooo! ¡Te sabes la foto de la palabra!", "¡Ouch! ¡Esa letra me ha dolido!"]
            )
        case .noNo:
            MonsterInfo(
                name: "El No-No",
                tagline: "Mete «no» del español para negar.",
                lesson: "En inglés «no» solo sirve para contestar (No, I haven't). Para negar usamos: isn't · aren't · am not · haven't got · hasn't got · can't · don't · doesn't.",
                emblem: "NO",
                taunts: ["¡No, no y no! Jejeje", "¡Pon un «no» y ya está!", "¡NO-NO-NO!"],
                hits: ["¡Ay! ¡Has usado la negación buena!", "¡Mi «no» no funciona contigo!", "¡Grrr! ¡Isn't, don't…! ¡Te las sabes!"]
            )
        case .jumper:
            MonsterInfo(
                name: "Verbo Saltarín",
                tagline: "Hace preguntas sin mover el verbo.",
                lesson: "En español basta con poner ¿? En inglés el verbo SALTA al principio: She is happy → Is she happy? Si no hay verbo que salte, salta Do o Does: Does she play chess? ¡Y en inglés solo hay ? al final, nada de ¿!",
                emblem: "?",
                taunts: ["¡Boing! ¡No me muevo!", "¡Pon ¿? y listo! Jejeje", "¡Boing boing!"],
                hits: ["¡Boing! ¡Me has hecho saltar!", "¡Ay! ¡El verbo está delante!", "¡Nooo, sabes hacer preguntas!"]
            )
        case .snake:
            MonsterInfo(
                name: "Serpiente de la S",
                tagline: "Se come la S de he, she, it.",
                lesson: "Con he, she, it (o un nombre: Tom, my sister) el verbo cambia: she IS, he HAS got, she PLAYS, he WATCHES. Con I, you, we, they no: I am, we have got, they play. Primero piensa: ¿quién es?",
                emblem: "S",
                taunts: ["Ssssss… ¡me como tu S!", "Ssss… she play… jejeje", "¡Ñam! ¡Otra S para mí!"],
                hits: ["¡Sssss! ¡Has protegido la S!", "¡Ay! ¡Sabes quién es!", "¡Ssss…! ¡Me quedo sin comer!"]
            )
        case .traps:
            MonsterInfo(
                name: "Trampas Españolas",
                tagline: "Traduce palabra por palabra.",
                lesson: "Algunas cosas se dicen distinto en inglés. Hay = There is / There are. Tengo 8 años = I am 8 years old. Los lunes = on Mondays. Pelo rubio = blonde hair (el color va antes). ¡No traduzcas palabra por palabra!",
                emblem: "ES",
                taunts: ["¡Tradúcelo tal cual! Jejeje", "¡Igual que en español!", "¡Caíste en mi trampa!"],
                hits: ["¡Ay! ¡Has esquivado mi trampa!", "¡Lo dices como un inglés!", "¡Nooo! ¡No has caído!"]
            )
        }
    }
}
