@testable import DisturbMyLive
import Testing

actor TestLiveConnectionService: LiveConnectionServiceProtocol {
    private let stream: AsyncStream<LiveEventEnvelope>
    private let continuation: AsyncStream<LiveEventEnvelope>.Continuation

    init() {
        let pair = Self.makeStream()
        self.stream = pair.stream
        self.continuation = pair.continuation
    }

    nonisolated var events: AsyncStream<LiveEventEnvelope> {
        stream
    }

    func connect(username: String) async throws {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            throw LiveConnectionServiceError.emptyUsername
        }

        continuation.yield(
            LiveEventEnvelope(
                kind: .transportConnect,
                title: "connected \(trimmed)"
            )
        )
    }

    func disconnect() async {
        continuation.yield(
            LiveEventEnvelope(
                kind: .workerInfo,
                title: "disconnected"
            )
        )
    }

    private static func makeStream() -> (
        stream: AsyncStream<LiveEventEnvelope>,
        continuation: AsyncStream<LiveEventEnvelope>.Continuation
    ) {
        var capturedContinuation: AsyncStream<LiveEventEnvelope>.Continuation?
        let stream = AsyncStream<LiveEventEnvelope> { continuation in
            capturedContinuation = continuation
        }

        guard let continuation = capturedContinuation else {
            fatalError(LiveConnectionServiceError.streamInitializationFailed.localizedDescription)
        }

        return (stream, continuation)
    }
}

final class TestDisturbanceAudioService: DisturbanceAudioServiceProtocol {
    private(set) var playedActions: [DisturbanceAction] = []
    private(set) var stopCallCount: Int = 0

    func play(action: DisturbanceAction) {
        playedActions.append(action)
    }

    func stopAll() {
        stopCallCount += 1
    }
}

@MainActor
struct DisturbMyLiveTests {
    @Test
    func connectMovesToConnectedState() async throws {
        let service = TestLiveConnectionService()
        let audioService = TestDisturbanceAudioService()
        let viewModel = LiveConnectionViewModel(
            service: service,
            audioService: audioService
        )

        viewModel.username = "jalil2567"
        viewModel.connect()

        try await Task.sleep(nanoseconds: 50_000_000)

        #expect(viewModel.connectionState == .connected(username: "jalil2567"))
        #expect(viewModel.recentEvents.first?.kind == .transportConnect)
    }

    @Test
    func emptyUsernameFails() async throws {
        let service = TestLiveConnectionService()
        let audioService = TestDisturbanceAudioService()
        let viewModel = LiveConnectionViewModel(
            service: service,
            audioService: audioService
        )

        viewModel.username = "   "
        viewModel.connect()

        try await Task.sleep(nanoseconds: 50_000_000)

        if case .failed(let message) = viewModel.connectionState {
            #expect(message.contains("Enter a TikTok username"))
        } else {
            Issue.record("Expected failed state")
        }
    }

    @Test
    func giftEventTriggersAudioAndUiLog() {
        let service = TestLiveConnectionService()
        let audioService = TestDisturbanceAudioService()
        let viewModel = LiveConnectionViewModel(
            service: service,
            audioService: audioService
        )

        viewModel.process(
            event: LiveEventEnvelope(
                kind: .gift,
                title: "Rose gift"
            )
        )

        #expect(audioService.playedActions == [.airhorn])
        #expect(viewModel.recentTriggers.first?.action == .airhorn)
    }

    @Test
    func mutedGiftStillLogsButDoesNotPlayAudio() {
        let service = TestLiveConnectionService()
        let audioService = TestDisturbanceAudioService()
        let viewModel = LiveConnectionViewModel(
            service: service,
            audioService: audioService
        )

        viewModel.isMuted = true
        viewModel.process(
            event: LiveEventEnvelope(
                kind: .gift,
                title: "Rose gift"
            )
        )

        #expect(audioService.playedActions.isEmpty)
        #expect(viewModel.recentTriggers.first?.action == .airhorn)
    }

    @Test
    func likeThresholdTriggersOnlyAtConfiguredBoundary() {
        var mapper = EventToDisturbanceMapper(likeThreshold: 3)

        let first = mapper.map(event: LiveEventEnvelope(kind: .like, title: "like 1"))
        let second = mapper.map(event: LiveEventEnvelope(kind: .like, title: "like 2"))
        let third = mapper.map(event: LiveEventEnvelope(kind: .like, title: "like 3"))

        #expect(first == nil)
        #expect(second == nil)
        #expect(third?.action == .likeMilestone)
    }
}
