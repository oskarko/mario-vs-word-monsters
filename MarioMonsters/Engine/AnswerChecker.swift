import Foundation

/// Text normalisation and answer comparison. Sentence answers are compared word by word,
/// ignoring case, punctuation and contractions ("isn't" == "is not"). Spelling is compared exactly.
enum AnswerChecker {
    private static let contractions: [String: [String]] = [
        "isn't": ["is", "not"], "aren't": ["are", "not"], "haven't": ["have", "not"],
        "hasn't": ["has", "not"], "don't": ["do", "not"], "doesn't": ["does", "not"],
        "can't": ["can", "not"], "cannot": ["can", "not"], "i'm": ["i", "am"],
        "it's": ["it", "is"], "he's": ["he", "is"], "she's": ["she", "is"],
        "we're": ["we", "are"], "they're": ["they", "are"], "you're": ["you", "are"],
        "there's": ["there", "is"], "what's": ["what", "is"], "wasn't": ["was", "not"],
    ]

    private static let numbers: [String: String] = [
        "0": "zero", "1": "one", "2": "two", "3": "three", "4": "four", "5": "five",
        "6": "six", "7": "seven", "8": "eight", "9": "nine", "10": "ten", "11": "eleven", "12": "twelve",
    ]

    /// Lower-cased, accent-free words with contractions expanded and digits spelled out.
    static func words(_ text: String) -> [String] {
        let folded = text
            .replacingOccurrences(of: "’", with: "'")
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "en"))
        let cleaned = String(folded.map { $0.isLetter || $0.isNumber || $0 == "'" ? $0 : " " })
        return cleaned.split(separator: " ").flatMap { token -> [String] in
            let word = String(token)
            if let expanded = contractions[word] { return expanded }
            if let spelled = numbers[word] { return [spelled] }
            return [word]
        }
    }

    static func sentenceMatches(_ answer: String, _ target: String) -> Bool {
        words(answer) == words(target)
    }

    /// Display tokens of a sentence (punctuation stripped, original case kept).
    static func tokens(_ sentence: String) -> [String] {
        let strip = CharacterSet(charactersIn: ".,?!¡¿")
        return sentence
            .split(separator: " ")
            .map { $0.trimmingCharacters(in: strip) }
            .filter { !$0.isEmpty }
    }

    /// Fraction of the target's words found, in order, in the transcript (0…1).
    static func speechScore(transcript: String, target: String) -> Double {
        let said = words(transcript)
        let wanted = words(target)
        guard !wanted.isEmpty else { return 0 }
        var index = said.startIndex
        var hits = 0
        for word in wanted {
            if let found = said[index...].firstIndex(of: word) {
                hits += 1
                index = said.index(after: found)
            }
        }
        return Double(hits) / Double(wanted.count)
    }

    static func key(_ token: String) -> String {
        words(token).joined(separator: " ")
    }
}
