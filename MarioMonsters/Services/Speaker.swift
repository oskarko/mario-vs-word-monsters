import AVFoundation

/// Text-to-speech: British English for the content, Spanish for help and instructions.
@MainActor
final class Speaker {
    static let shared = Speaker()

    private let synthesizer = AVSpeechSynthesizer()
    private lazy var englishVoice = Self.bestVoice(for: "en-GB")
    private lazy var spanishVoice = Self.bestVoice(for: "es-ES")

    private init() {}

    private var rate: Float {
        let stored = UserDefaults.standard.object(forKey: SettingsKey.speechRate) as? Double
        return Float(stored ?? SettingsKey.defaultSpeechRate)
    }

    func english(_ text: String, slow: Bool = false) {
        speak(text, voice: englishVoice, rate: slow ? rate * 0.7 : rate)
    }

    func spanish(_ text: String) {
        speak(text, voice: spanishVoice, rate: 0.5)
    }

    /// Spanish help is optional (parent setting); English is always available.
    func spanishHelp(_ text: String) {
        let enabled = UserDefaults.standard.object(forKey: SettingsKey.spanishVoiceHelp) as? Bool ?? true
        if enabled { spanish(text) }
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    private func speak(_ text: String, voice: AVSpeechSynthesisVoice?, rate: Float) {
        Self.activatePlayback()
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = rate
        utterance.pitchMultiplier = 1.05
        utterance.postUtteranceDelay = 0.05
        synthesizer.speak(utterance)
    }

    static func activatePlayback() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        try? session.setActive(true)
    }

    private static func bestVoice(for language: String) -> AVSpeechSynthesisVoice? {
        let voices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == language }
        return voices.max { $0.quality.rawValue < $1.quality.rawValue } ?? AVSpeechSynthesisVoice(language: language)
    }
}
