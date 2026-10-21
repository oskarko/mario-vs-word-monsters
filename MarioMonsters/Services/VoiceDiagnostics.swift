#if DEBUG
import AVFoundation
import Speech

/// `-voiceDiagnostics YES`: renders tricky words with every English voice and runs the result
/// through speech recognition, printing what the device actually says (no need to listen).
@MainActor
enum VoiceDiagnostics {
    static func runIfRequested() {
        guard UserDefaults.standard.bool(forKey: "voiceDiagnostics") else { return }
        Task {
            _ = await authorize()
            let chosen = UserDefaults.standard.string(forKey: SettingsKey.englishVoice) ?? ""
            print("VOICEDIAG chosen=\(chosen.isEmpty ? "auto" : chosen) auto=\(Speaker.automaticEnglishVoice?.identifier ?? "nil")")
            print("VOICEDIAG locale=\(Locale.current.identifier) languages=\(Locale.preferredLanguages)")
            for voice in Speaker.voices(for: "en") {
                for (label, text) in samples {
                    let heard = await transcribe(text, voice: voice)
                    print("VOICEDIAG \(voice.name) \(voice.language) q\(voice.quality.rawValue) [\(label)] → \(heard)")
                }
            }
            print("VOICEDIAG done")
        }
    }

    private static var samples: [(String, NSAttributedString)] {
        [
            ("you plain", NSAttributedString(string: "you")),
            ("you ipa", Speaker.pronounced("you")),
            ("You.", NSAttributedString(string: "You.")),
            ("good", NSAttributedString(string: "good")),
            ("sentence", NSAttributedString(string: "Have you got a dog?")),
        ]
    }

    private static let renderer = AVSpeechSynthesizer()

    private static func render(_ text: NSAttributedString, voice: AVSpeechSynthesisVoice) async -> [AVAudioPCMBuffer] {
        let utterance = AVSpeechUtterance(attributedString: text)
        utterance.voice = voice
        let collected = Collector()
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            renderer.write(utterance, toBufferCallback: bufferCallback(collected) { continuation.resume() })
            Task {
                try? await Task.sleep(for: .seconds(6))
                collected.finish { continuation.resume() }
            }
        }
        return collected.buffers
    }

    private static func transcribe(_ text: NSAttributedString, voice: AVSpeechSynthesisVoice) async -> String {
        let buffers = await render(text, voice: voice)
        guard !buffers.isEmpty, let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-GB")) else { return "(no audio)" }
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = false
        // A little silence on both sides, as a real recording would have.
        if let silence = AVAudioPCMBuffer(pcmFormat: buffers[0].format, frameCapacity: 8000) {
            silence.frameLength = 8000
            request.append(silence)
            buffers.forEach(request.append)
            request.append(silence)
        }
        request.endAudio()
        return await withCheckedContinuation { continuation in
            recognizer.recognitionTask(with: request, resultHandler: resultHandler { continuation.resume(returning: $0) })
        }
    }
}

// Speech and rendering callbacks arrive on background threads: build them outside the main actor.
private nonisolated func authorize() async -> SFSpeechRecognizerAuthorizationStatus {
    await withCheckedContinuation { continuation in
        SFSpeechRecognizer.requestAuthorization { continuation.resume(returning: $0) }
    }
}

private nonisolated func bufferCallback(_ collected: Collector, done: @escaping @Sendable () -> Void) -> AVSpeechSynthesizer.BufferCallback {
    { buffer in
        guard let pcm = buffer as? AVAudioPCMBuffer else { return }
        if pcm.frameLength == 0 {
            collected.finish(done)
        } else if let copy = Speaker.monoFloatCopy(pcm) {
            collected.add(copy)
        }
    }
}

private nonisolated func resultHandler(_ done: @escaping @Sendable (String) -> Void) -> @Sendable (SFSpeechRecognitionResult?, (any Error)?) -> Void {
    let once = Collector()
    return { result, error in
        if let result, result.isFinal {
            let all = result.transcriptions.prefix(3).map(\.formattedString).joined(separator: " | ")
            once.finish { done(all) }
        } else if let error {
            once.finish { done("(error \(error.localizedDescription))") }
        }
    }
}

private final class Collector: @unchecked Sendable {
    private let lock = NSLock()
    private(set) var buffers: [AVAudioPCMBuffer] = []
    private var finished = false

    func add(_ buffer: AVAudioPCMBuffer) { lock.withLock { buffers.append(buffer) } }

    func finish(_ action: () -> Void) {
        let first = lock.withLock { () -> Bool in
            defer { finished = true }
            return !finished
        }
        if first { action() }
    }
}
#endif
