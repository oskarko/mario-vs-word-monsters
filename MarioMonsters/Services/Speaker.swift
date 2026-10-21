import AVFoundation

/// Text-to-speech: British English for the content, Spanish for help and instructions.
@MainActor
final class Speaker {
    static let shared = Speaker()

    private let synthesizer = AVSpeechSynthesizer()
    private lazy var spanishVoice = Self.bestVoice(for: "es")

    /// Read every time, so a voice picked in the parent area applies straight away.
    private var englishVoice: AVSpeechSynthesisVoice? {
        let chosen = UserDefaults.standard.string(forKey: SettingsKey.englishVoice) ?? ""
        return AVSpeechSynthesisVoice(identifier: chosen) ?? Self.automaticEnglishVoice
    }
    /// Not cached: a voice downloaded while the app is open should be picked up straight away.
    static var automaticEnglishVoice: AVSpeechSynthesisVoice? { bestVoice(for: "en") }

    /// The built-in compact voices mispronounce some short words; enhanced and premium ones don't.
    static var hasClearEnglishVoice: Bool { voices(for: "en").contains { $0.quality != .default } }

    // Slow mode renders the speech to audio and time-stretches it, because the higher-quality
    // voices largely ignore `AVSpeechUtterance.rate`, so a lower rate alone sounded identical.
    private let renderer = AVSpeechSynthesizer()
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let stretch = AVAudioUnitTimePitch()
    private var connectedFormat: AVAudioFormat?
    private var generation = 0
    private var scheduledSlow = false

    private static let slowFactor: Float = 0.6

    private init() {
        stretch.rate = Self.slowFactor
        engine.attach(player)
        engine.attach(stretch)
    }

    private var rate: Float {
        let stored = UserDefaults.standard.object(forKey: SettingsKey.speechRate) as? Double
        return Float(stored ?? SettingsKey.defaultSpeechRate)
    }

    func english(_ text: String, slow: Bool = false) {
        let text = Self.spokenEnglish(text)
        if slow {
            speakSlow(text)
        } else {
            speak(text, voice: englishVoice, rate: rate)
        }
    }

    /// Read sentence by sentence (with a short pause) so ¿? and ¡! get their intonation.
    func spanish(_ text: String) {
        stop()
        Self.activatePlayback()
        for sentence in SpokenSpanish.sentences(text) {
            let utterance = Self.utterance(sentence, voice: spanishVoice, rate: 0.45)
            utterance.postUtteranceDelay = 0.25
            synthesizer.speak(utterance)
        }
    }

    /// Spanish help is optional (parent setting); English is always available.
    func spanishHelp(_ text: String) {
        let enabled = UserDefaults.standard.object(forKey: SettingsKey.spanishVoiceHelp) as? Bool ?? true
        if enabled { spanish(text) }
    }

    func stop() {
        generation += 1
        synthesizer.stopSpeaking(at: .immediate)
        renderer.stopSpeaking(at: .immediate)
        player.stop()
    }

    private func speak(_ text: String, voice: AVSpeechSynthesisVoice?, rate: Float) {
        stop()
        Self.activatePlayback()
        synthesizer.speak(Self.utterance(text, voice: voice, rate: rate, english: true))
    }

    private func speakSlow(_ text: String) {
        stop()
        Self.activatePlayback()
        let current = generation
        scheduledSlow = false
        let utterance = Self.utterance(text, voice: englishVoice, rate: rate, english: true)
        renderer.write(utterance, toBufferCallback: Self.makeBufferCallback { [weak self] box in
            self?.schedule(box.buffer, generation: current)
        })
        // If rendering produces nothing (unsupported voice), fall back to a slower rate.
        Task {
            try? await Task.sleep(for: .seconds(1))
            guard current == generation, !scheduledSlow else { return }
            speak(text, voice: englishVoice, rate: rate * 0.7)
        }
    }

    private func schedule(_ buffer: AVAudioPCMBuffer, generation current: Int) {
        guard current == generation else { return }
        if connectedFormat != buffer.format {
            engine.stop()
            engine.connect(player, to: stretch, format: buffer.format)
            engine.connect(stretch, to: engine.mainMixerNode, format: buffer.format)
            connectedFormat = buffer.format
        }
        if !engine.isRunning {
            do { try engine.start() } catch { return }
        }
        if !scheduledSlow, let silence = AVAudioPCMBuffer(pcmFormat: buffer.format, frameCapacity: AVAudioFrameCount(buffer.format.sampleRate * Self.leadIn)) {
            silence.frameLength = silence.frameCapacity
            if let samples = silence.floatChannelData?[0] { samples.update(repeating: 0, count: Int(silence.frameLength)) }
            player.scheduleBuffer(silence)
        }
        scheduledSlow = true
        player.scheduleBuffer(buffer)
        if !player.isPlaying { player.play() }
    }

    private static func utterance(_ text: String, voice: AVSpeechSynthesisVoice?, rate: Float, english: Bool = false) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = rate
        utterance.pitchMultiplier = 1.05
        utterance.postUtteranceDelay = 0.05
        if english { utterance.preUtteranceDelay = leadIn }
        return utterance
    }

    /// A lone "I" is read as the letter ("capital I"); "eye" sounds exactly like the word.
    /// Other words the voices get wrong are respelled the way they sound: the IPA attribute
    /// garbled them on iPad ("necklace" came out as "kilss"), plain spelling is reliable.
    nonisolated static func spokenEnglish(_ text: String) -> String {
        let bare = text.trimmingCharacters(in: .whitespacesAndNewlines.union(.punctuationCharacters))
        if bare == "I" { return "eye" }
        var result = text
        let whole = NSRange(text.startIndex..., in: text)
        var ranges: [(Range<String.Index>, String)] = []
        (text as NSString).enumerateSubstrings(in: whole, options: .byWords) { word, range, _, _ in
            if let word, let spoken = respellings[word.lowercased()], let range = Range(range, in: text) {
                ranges.append((range, word.first?.isUppercase == true ? spoken.capitalized : spoken))
            }
        }
        for (range, spoken) in ranges.reversed() { result.replaceSubrange(range, with: spoken) }
        return result
    }

    /// "necklace" is /ˈnekləs/, but the voices read "neck-lace".
    nonisolated static let respellings: [String: String] = ["necklace": "neckless"]

    /// Switching back from the microphone's record mode reroutes the audio, and on iPad that
    /// swallowed the start of the next word ("you" came out as "niu"). Only switch when needed,
    /// and give the route a moment (see `leadIn`) before the first sound.
    static func activatePlayback() {
        let session = AVAudioSession.sharedInstance()
        if session.category != .playback || session.mode != .spokenAudio {
            try? session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        }
        try? session.setActive(true)
    }

    private static let leadIn: TimeInterval = 0.15

    /// Real voices for a language ("en", "es"), clearest first. A woman's voice comes first so the
    /// English cards sound like the Spanish help (the iPad's only built-in British voice is a man's,
    /// Daniel, and hard to follow); then downloaded enhanced/premium quality; then the clearest
    /// accents for a Spanish child (British, then American: Samantha beats Karen or Moira).
    static func voices(for language: String) -> [AVSpeechSynthesisVoice] {
        let accents = language == "en" ? ["en-US", "en-GB"] : ["es-MX", "es-ES"]
        func rank(_ voice: AVSpeechSynthesisVoice) -> (Int, Int, Int) {
            (voice.gender == .female ? 1 : 0, voice.quality.rawValue, accents.firstIndex(of: voice.language) ?? -1)
        }
        return AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.hasPrefix(language + "-") && !isNovelty($0) }
            .sorted { rank($0) > rank($1) }
    }

    /// The joke voices (Albert, Bubbles, Grandpa, Eddy…) are never a good choice for a child learning.
    private static func isNovelty(_ voice: AVSpeechSynthesisVoice) -> Bool {
        voice.identifier.contains("eloquence") || voice.identifier.contains("speech.synthesis.voice")
            || voice.voiceTraits.contains(.isNoveltyVoice) || voice.voiceTraits.contains(.isPersonalVoice)
    }

    private static func bestVoice(for language: String) -> AVSpeechSynthesisVoice? {
        voices(for: language).first ?? AVSpeechSynthesisVoice(language: language == "en" ? "en-GB" : "es-ES")
    }

    /// Rendered buffers arrive on a background thread; they are copied to mono float and handed
    /// to the main queue in order (DispatchQueue keeps FIFO order, unlike separate Tasks).
    nonisolated private static func makeBufferCallback(
        _ deliver: @escaping @MainActor (BufferBox) -> Void
    ) -> AVSpeechSynthesizer.BufferCallback {
        let deliver = UncheckedSendable(deliver)
        return { buffer in
            guard let pcm = buffer as? AVAudioPCMBuffer, let copy = monoFloatCopy(pcm) else { return }
            let box = BufferBox(buffer: copy)
            DispatchQueue.main.async {
                MainActor.assumeIsolated { deliver.value(box) }
            }
        }
    }

    nonisolated static func monoFloatCopy(_ pcm: AVAudioPCMBuffer) -> AVAudioPCMBuffer? {
        let frames = Int(pcm.frameLength)
        guard frames > 0,
              let format = AVAudioFormat(standardFormatWithSampleRate: pcm.format.sampleRate, channels: 1),
              let copy = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: pcm.frameLength),
              let destination = copy.floatChannelData?[0] else { return nil }
        copy.frameLength = pcm.frameLength
        let stride = pcm.stride
        if let source = pcm.floatChannelData?[0] {
            for index in 0..<frames { destination[index] = source[index * stride] }
        } else if let source = pcm.int16ChannelData?[0] {
            for index in 0..<frames { destination[index] = Float(source[index * stride]) / 32_768 }
        } else if let source = pcm.int32ChannelData?[0] {
            for index in 0..<frames { destination[index] = Float(source[index * stride]) / 2_147_483_648 }
        } else {
            return nil
        }
        return copy
    }
}

/// A freshly copied buffer that nothing else references, so it is safe to move across threads.
final class BufferBox: @unchecked Sendable {
    let buffer: AVAudioPCMBuffer
    init(buffer: AVAudioPCMBuffer) { self.buffer = buffer }
}

private struct UncheckedSendable<Value>: @unchecked Sendable {
    let value: Value
    init(_ value: Value) { self.value = value }
}
