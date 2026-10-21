import Foundation

/// Turns the on-screen Spanish help into text the Spanish voice reads naturally.
/// The screen uses symbols (→, =, /, «»), capitals for emphasis (IS, wHale, fr-I-end) and emojis;
/// read literally they come out as "flecha", spelled-out letters or silence.
enum SpokenSpanish {
    /// One entry per sentence, so each gets its own question or exclamation intonation.
    static func sentences(_ text: String) -> [String] {
        let clean = normalise(text)
        var result: [String] = []
        var current = ""
        var previous: Character?
        for character in clean {
            if character == " ", let previous, ".!?:".contains(previous) {
                append(current, to: &result)
                current = ""
            } else {
                current.append(character)
            }
            previous = character
        }
        append(current, to: &result)
        return result
    }

    static func normalise(_ text: String) -> String {
        var text = text
        for (symbol, spoken) in [("→", ", "), ("≠", ", no es "), (" = ", ", es "), ("·", ","), (" / ", " o "),
                                 ("/", " o "), (" + ", " más "), ("«", ""), ("»", ""), ("(", ", "), (")", ",")] {
            text = text.replacingOccurrences(of: symbol, with: spoken)
        }
        text = String(text.unicodeScalars.filter { !isEmoji($0) }.map(Character.init))
        let words = text.split(separator: " ", omittingEmptySubsequences: true).map { spokenWord(String($0)) }
        return words.joined(separator: " ")
            .replacingOccurrences(of: " ,", with: ",")
            .replacingOccurrences(of: ",,", with: ",")
            .replacingOccurrences(of: ",.", with: ".")
    }

    /// "IS" → "is", "wHale" → "whale", "fr-I-end" → "friend", "-ing" → "ing". Spelled words
    /// ("s-t-r-a-i-g-h-t"), "I" and normal capitalised words ("Monday") are kept.
    private static func spokenWord(_ word: String) -> String {
        var word = word
        while word.hasPrefix("-") { word.removeFirst() }
        let letters = word.filter(\.isLetter)
        let chunks = word.split(separator: "-")
        if chunks.count > 1, chunks.contains(where: { $0.count <= 2 && $0.allSatisfy(\.isUppercase) }) {
            return word.replacingOccurrences(of: "-", with: "").lowercased()
        }
        if letters.count > 1, letters.dropFirst().contains(where: \.isUppercase) {
            return word.lowercased()
        }
        return word
    }

    private static func isEmoji(_ scalar: Unicode.Scalar) -> Bool {
        scalar.properties.isEmojiPresentation || scalar.value == 0xFE0F || scalar.value == 0x200D
            || (0x1F000...0x1FAFF).contains(scalar.value)
    }

    private static func append(_ sentence: String, to result: inout [String]) {
        let trimmed = sentence.trimmingCharacters(in: CharacterSet(charactersIn: " ,"))
        if trimmed.contains(where: \.isLetter) { result.append(trimmed) }
    }
}
