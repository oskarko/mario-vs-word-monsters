import AVFoundation
import Observation
import OSLog
import Speech

/// On-device English speech recognition for the "Dilo" exercise.
///
/// Recognition and audio-tap callbacks run on background threads, so they are built in
/// `nonisolated` helpers and only hop to the main actor with plain strings.
@Observable
@MainActor
final class SpeechListener {
    enum State: Equatable { case idle, listening, unavailable }

    private(set) var state: State = .idle
    private(set) var transcript = ""
    /// Every reading the recognizer considered (best first); a child's accent often lands on the second one.
    private(set) var alternatives: [String] = []
    /// The try ended with an error before anything was heard (not a pronunciation problem).
    private(set) var failed = false

    private var engine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    /// Callbacks from an earlier try (a cancelled task reports late) must not stop the current one.
    private var generation = 0
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-GB"))
    private let log = Logger(subsystem: "com.oscargarrucho.MarioMonsters", category: "speech")
    /// On-device recognition can report support and then fail at once (it needs Dictation turned on);
    /// after that, use Apple's server for the rest of the run.
    private static var onDeviceFailed = false

    func requestAccess() async -> Bool {
        guard await Self.authorizeSpeech() else { return false }
        return await AVAudioApplication.requestRecordPermission()
    }

    func start(hint: String) {
        stop()
        transcript = ""
        alternatives = []
        failed = false
        guard let recognizer, recognizer.isAvailable else {
            state = .unavailable
            return
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .duckOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation)

            let engine = AVAudioEngine()
            let format = engine.inputNode.outputFormat(forBus: 0)
            guard format.sampleRate > 0, format.channelCount > 0 else {
                state = .unavailable
                return
            }
            self.engine = engine
            recognize(hint: hint, with: recognizer, onDevice: recognizer.supportsOnDeviceRecognition && !Self.onDeviceFailed)
            engine.prepare()
            try engine.start()
            note("Listening (route=\(session.currentRoute.inputs.map(\.portName)))")
            state = .listening
        } catch {
            note("Could not start listening: \(error)")
            stop()
            state = .unavailable
        }
    }

    /// Feeds the microphone into a new recognition request. If on-device recognition fails before
    /// hearing anything — "Siri and Dictation are disabled" on Mario's iPad — the same try carries
    /// on with Apple's server, so the first tap of the mic still works.
    private func recognize(hint: String, with recognizer: SFSpeechRecognizer, onDevice: Bool) {
        guard let engine else { return }
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.contextualStrings = [hint] + AnswerChecker.tokens(hint)
        request.addsPunctuation = false
        request.requiresOnDeviceRecognition = onDevice
        engine.inputNode.removeTap(onBus: 0)
        engine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: engine.inputNode.outputFormat(forBus: 0), block: Self.makeTap(request))
        self.request = request

        let current = generation
        task = recognizer.recognitionTask(with: request, resultHandler: Self.makeHandler { [weak self] texts, isFinal, error in
            guard let self, current == self.generation else { return }
            if let text = texts.first {
                self.transcript = text
                self.alternatives = texts
            }
            if let error {
                self.note("Recognition error (onDevice=\(onDevice)): \(error)")
                if self.alternatives.isEmpty {
                    if onDevice, self.engine != nil {
                        Self.onDeviceFailed = true
                        self.generation += 1
                        self.task?.cancel()
                        self.request?.endAudio()
                        self.recognize(hint: hint, with: recognizer, onDevice: false)
                        return
                    }
                    self.failed = true
                }
            }
            if isFinal || error != nil { self.stop() }
        })
    }

    /// Stops the microphone but lets the recognizer finish the last words; the final result then calls `stop()`.
    func finishAudio() {
        engine?.stop()
        engine?.inputNode.removeTap(onBus: 0)
        engine = nil
        request?.endAudio()
    }

    func stop() {
        let wasActive = engine != nil || task != nil
        generation += 1
        finishAudio()
        task?.cancel()
        request = nil
        task = nil
        if state == .listening { state = .idle }
        // Only switch the audio session back if we took it, otherwise this could interrupt playback.
        if wasActive { Speaker.activatePlayback() }
    }

    /// Logged, and echoed to the console in debug builds so a device run shows it.
    private func note(_ message: String) {
        log.notice("\(message, privacy: .public)")
        #if DEBUG
        print("SPEECH \(message)")
        #endif
    }

    nonisolated private static func authorizeSpeech() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }

    nonisolated private static func makeTap(_ request: SFSpeechAudioBufferRecognitionRequest) -> AVAudioNodeTapBlock {
        { buffer, _ in request.append(buffer) }
    }

    nonisolated private static func makeHandler(
        _ update: @escaping @Sendable @MainActor ([String], Bool, String?) -> Void
    ) -> (SFSpeechRecognitionResult?, (any Error)?) -> Void {
        { result, error in
            let texts = result?.transcriptions.map(\.formattedString) ?? []
            let isFinal = result?.isFinal ?? false
            let message = error.map { "\($0)" }
            Task { @MainActor in update(texts, isFinal, message) }
        }
    }
}
