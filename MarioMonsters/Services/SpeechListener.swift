import AVFoundation
import Observation
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

    private var engine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    /// Callbacks from an earlier try (a cancelled task reports late) must not stop the current one.
    private var generation = 0
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-GB"))

    func requestAccess() async -> Bool {
        guard await Self.authorizeSpeech() else { return false }
        return await AVAudioApplication.requestRecordPermission()
    }

    func start(hint: String) {
        stop()
        transcript = ""
        alternatives = []
        guard let recognizer, recognizer.isAvailable else {
            state = .unavailable
            return
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .duckOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation)

            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            request.contextualStrings = [hint] + AnswerChecker.tokens(hint)
            request.addsPunctuation = false
            if recognizer.supportsOnDeviceRecognition {
                request.requiresOnDeviceRecognition = true
            }

            let engine = AVAudioEngine()
            let input = engine.inputNode
            let format = input.outputFormat(forBus: 0)
            guard format.sampleRate > 0, format.channelCount > 0 else {
                state = .unavailable
                return
            }
            input.installTap(onBus: 0, bufferSize: 1024, format: format, block: Self.makeTap(request))
            engine.prepare()
            try engine.start()

            self.engine = engine
            self.request = request
            let current = generation
            self.task = recognizer.recognitionTask(with: request, resultHandler: Self.makeHandler { [weak self] texts, isFinal in
                guard let self, current == self.generation else { return }
                if let text = texts.first {
                    self.transcript = text
                    self.alternatives = texts
                }
                if isFinal { self.stop() }
            })
            state = .listening
        } catch {
            stop()
            state = .unavailable
        }
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
        _ update: @escaping @Sendable @MainActor ([String], Bool) -> Void
    ) -> (SFSpeechRecognitionResult?, (any Error)?) -> Void {
        { result, error in
            let texts = result?.transcriptions.map(\.formattedString) ?? []
            let isFinal = (result?.isFinal ?? false) || error != nil
            Task { @MainActor in update(texts, isFinal) }
        }
    }
}
