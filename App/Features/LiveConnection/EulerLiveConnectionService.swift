import Foundation

#if canImport(EulerLiveKit)
import EulerLiveKit
#endif

protocol LiveConnectionServiceProtocol: Sendable {
    var events: AsyncStream<LiveEventEnvelope> { get }
    func connect(username: String) async throws
    func disconnect() async
}

enum LiveConnectionServiceError: LocalizedError, Equatable {
    case emptyUsername
    case streamInitializationFailed
    case notImplemented

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Enter a TikTok username."
        case .streamInitializationFailed:
            return "Live event stream could not be initialized."
        case .notImplemented:
            return "EulerLiveKit connection wiring is not finished yet."
        }
    }
}

actor EulerLiveKitLiveConnectionService: LiveConnectionServiceProtocol {
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
        guard trimmed.isEmpty == false else {
            throw LiveConnectionServiceError.emptyUsername
        }

        #if canImport(EulerLiveKit)
        continuation.yield(
            LiveEventEnvelope(
                kind: .transportConnect,
                title: "Adapter bootstrapped for @\(trimmed)",
                rawPayload: nil
            )
        )
        continuation.yield(
            LiveEventEnvelope(
                kind: .workerInfo,
                title: "Next pass wires EulerLiveClient and token provider here",
                rawPayload: nil
            )
        )
        #else
        continuation.yield(
            LiveEventEnvelope(
                kind: .transportConnect,
                title: "Package not linked yet for @\(trimmed)",
                rawPayload: nil
            )
        )
        #endif
    }

    func disconnect() async {
        continuation.yield(
            LiveEventEnvelope(
                kind: .workerInfo,
                title: "Disconnected",
                rawPayload: nil
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
