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
        "weren't": ["were", "not"], "didn't": ["did", "not"], "mustn't": ["must", "not"],
        "couldn't": ["could", "not"], "won't": ["will", "not"], "i've": ["i", "have"],
        "you've": ["you", "have"], "we've": ["we", "have"], "they've": ["they", "have"],
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
        var result = cleaned.split(separator: " ").flatMap { token -> [String] in
            let word = String(token)
            if let expanded = contractions[word] { return expanded }
            if let spelled = numbers[word] { return [spelled] }
            return [word]
        }
        // "She's got" expands to "she is got", but before got the 's can only mean has.
        for index in result.indices.dropLast() where result[index] == "is" && result[index + 1] == "got" {
            result[index] = "has"
        }
        return result
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
    /// Lenient on purpose: an 8-year-old's accent and the recognizer's guesses shouldn't fail a
    /// sentence he said well, so words that sound alike or are one or two letters off count.
    static func speechScore(transcript: String, target: String) -> Double {
        let said = words(transcript)
        let wanted = words(target)
        guard !wanted.isEmpty else { return 0 }
        var index = said.startIndex
        var hits = 0
        for word in wanted {
            if let found = said[index...].firstIndex(where: { soundsAlike($0, word) }) {
                hits += 1
                index = said.index(after: found)
            }
        }
        return Double(hits) / Double(wanted.count)
    }

    /// Best score over all the recognizer's alternative readings.
    static func speechScore(transcripts: [String], target: String) -> Double {
        transcripts.map { speechScore(transcript: $0, target: target) }.max() ?? 0
    }

    private static let homophones: [[String]] = [
        ["i", "eye", "aye", "ai", "hi"], ["to", "two", "too"], ["there", "their", "they're"],
        ["hear", "here"], ["for", "four"], ["son", "sun"], ["eight", "ate"], ["right", "write"],
        ["no", "know"], ["wear", "where"], ["see", "sea"], ["by", "buy", "bye"], ["which", "witch"],
        ["whose", "who's"], ["new", "knew"], ["one", "won"], ["hour", "our"], ["meet", "meat"],
        ["blue", "blew"], ["hair", "hare"], ["night", "knight"], ["week", "weak"], ["pair", "pear"], ["its", "it's"],
    ]

    static func soundsAlike(_ said: String, _ wanted: String) -> Bool {
        if said == wanted || homophones.contains(where: { $0.contains(said) && $0.contains(wanted) }) { return true }
        let a = soundKey(said), b = soundKey(wanted)
        if a == b { return true }
        let shortest = min(said.count, wanted.count)
        guard shortest >= 4 else { return false }
        return distance(a, b) <= (shortest >= 7 ? 2 : 1)
    }

    /// Rough spelling-to-sound key: ph → f, ck → k, wh → w, kn → n, silent final e, no double letters.
    private static func soundKey(_ word: String) -> String {
        var key = word.replacingOccurrences(of: "'", with: "")
        for (from, to) in [("ph", "f"), ("ck", "k"), ("wh", "w"), ("kn", "n"), ("gh", "")] {
            key = key.replacingOccurrences(of: from, with: to)
        }
        if key.count > 3, key.hasSuffix("e") { key.removeLast() }
        var result = ""
        for character in key where character != result.last { result.append(character) }
        return result
    }

    private static func distance(_ a: String, _ b: String) -> Int {
        let a = Array(a), b = Array(b)
        var previous = Array(0...b.count)
        for i in 1...max(a.count, 1) where !a.isEmpty {
            var current = [i] + Array(repeating: 0, count: b.count)
            for j in stride(from: 1, through: b.count, by: 1) {
                current[j] = min(previous[j] + 1, current[j - 1] + 1, previous[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1))
            }
            previous = current
        }
        return previous[b.count]
    }

    static func key(_ token: String) -> String {
        words(token).joined(separator: " ")
    }
}
