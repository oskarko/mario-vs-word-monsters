import AVFoundation

/// Text-to-speech: British English for the content, Spanish for help and instructions.
@MainActor
final class Speaker {
    static let shared = Speaker()

    private let synthesizer = AVSpeechSynthesizer()
    private lazy var englishVoice = Self.bestVoice(for: "en-GB")
    private lazy var spanishVoice = Self.bestVoice(for: "es-ES")

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
        if slow {
            speakSlow(text)
        } else {
            speak(text, voice: englishVoice, rate: rate)
        }
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
        generation += 1
        synthesizer.stopSpeaking(at: .immediate)
        renderer.stopSpeaking(at: .immediate)
        player.stop()
    }

    private func speak(_ text: String, voice: AVSpeechSynthesisVoice?, rate: Float) {
        stop()
        Self.activatePlayback()
        synthesizer.speak(Self.utterance(text, voice: voice, rate: rate))
    }

    private func speakSlow(_ text: String) {
        stop()
        Self.activatePlayback()
        let current = generation
        scheduledSlow = false
        let utterance = Self.utterance(text, voice: englishVoice, rate: rate)
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
        scheduledSlow = true
        player.scheduleBuffer(buffer)
        if !player.isPlaying { player.play() }
    }

    private static func utterance(_ text: String, voice: AVSpeechSynthesisVoice?, rate: Float) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = rate
        utterance.pitchMultiplier = 1.05
        utterance.postUtteranceDelay = 0.05
        return utterance
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
