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

    var errorDescription: String? {
        switch self {
        case .emptyUsername:
            return "Enter a TikTok username."
        case .streamInitializationFailed:
            return "Live event stream could not be initialized."
        }
    }
}

actor EulerLiveKitLiveConnectionService: LiveConnectionServiceProtocol {
    private let stream: AsyncStream<LiveEventEnvelope>
    private let continuation: AsyncStream<LiveEventEnvelope>.Continuation
    private var liveService: LiveConnectionService?
    private var currentUsername: String?

    init() {
        let pair = Self.makeStream()
        self.stream = pair.stream
        self.continuation = pair.continuation
    }

    nonisolated var events: AsyncStream<LiveEventEnvelope> {
        stream
    }

    func connect(username: String) async throws {
        let trimmed = Self.normalizedUsername(from: username)
        guard trimmed.isEmpty == false else {
            throw LiveConnectionServiceError.emptyUsername
        }

        currentUsername = trimmed
        let service = await ensureService()

        continuation.yield(
            makeEvent(
                kind: .transportConnect,
                title: "Starting connection to @\(trimmed)"
            )
        )

        do {
            try await service.connect(to: trimmed)
        } catch {
            continuation.yield(
                makeEvent(
                    kind: .workerInfo,
                    title: Self.userFacingMessage(for: error),
                    rawPayload: String(describing: error)
                )
            )
            throw error
        }
    }

    func disconnect() async {
        let username = currentUsername

        if let service = liveService {
            await service.disconnect()
            await MainActor.run {
                service.clearHistory()
            }
        }

        currentUsername = nil

        continuation.yield(
            makeEvent(
                kind: .workerInfo,
                title: username.map { "Disconnected from @\($0)" } ?? "Disconnected"
            )
        )
    }

    private func ensureService() async -> LiveConnectionService {
        if let liveService {
            return liveService
        }

        let service = await MainActor.run {
            LiveConnectionService()
        }

        await MainActor.run {
            service.onStatusChange = { [weak self] status in
                Task {
                    await self?.handle(status: status)
                }
            }

            service.onEventRecord = { [weak self] record in
                Task {
                    await self?.handle(record: record)
                }
            }
        }

        liveService = service
        return service
    }

    private func handle(status: EulerConnectionStatus) async {
        continuation.yield(event(for: status))
    }

    private func handle(record: EulerDebugEventRecord) async {
        continuation.yield(event(for: record))
    }

    private func event(for status: EulerConnectionStatus) -> LiveEventEnvelope {
        let username = currentUsername ?? "unknown"

        switch status {
        case .idle:
            return makeEvent(kind: .workerInfo, title: "Idle")
        case .fetchingToken:
            return makeEvent(kind: .workerInfo, title: "Fetching token for @\(username)")
        case .connecting:
            return makeEvent(kind: .transportConnect, title: "Connecting to @\(username)")
        case .connected:
            return makeEvent(kind: .transportConnect, title: "Connected to @\(username)")
        case .failed(let error):
            return makeEvent(
                kind: .workerInfo,
                title: Self.userFacingMessage(for: error),
                rawPayload: String(describing: error)
            )
        case .disconnected(let reason):
            return makeEvent(
                kind: .workerInfo,
                title: "Disconnected \(String(describing: reason))",
                rawPayload: String(describing: reason)
            )
        }
    }

    private func event(for record: EulerDebugEventRecord) -> LiveEventEnvelope {
        let title = record.decodedTypedEvent?.summary ?? record.eventName
        return LiveEventEnvelope(
            kind: Self.kind(forEventName: record.eventName),
            title: title,
            timestamp: record.receivedAt,
            rawPayload: record.rawPayload
        )
    }

    private func makeEvent(
        kind: LiveEventKind,
        title: String,
        rawPayload: String? = nil
    ) -> LiveEventEnvelope {
        LiveEventEnvelope(
            kind: kind,
            title: title,
            rawPayload: rawPayload
        )
    }

    private static func normalizedUsername(from rawValue: String) -> String {
        rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "@", with: "")
    }

    private static func kind(forEventName eventName: String) -> LiveEventKind {
        LiveEventKind(rawValue: mappedRawValue(forEventName: eventName) ?? "") ?? .unknown
    }

    private static func mappedRawValue(forEventName eventName: String) -> String? {
        eventNameMap[eventName]
    }

    private static let eventNameMap: [String: String] = [
        "room_info": "roomInfo",
        "member": "member",
        "gift": "gift",
        "like": "like",
        "chat": "comment",
        "follow": "follow",
        "share": "share",
        "room_user": "roomUser",
        "live_intro": "liveIntro",
        "room_message": "roomMessage",
        "caption_message": "caption",
        "barrage": "barrage",
        "link_mic_fan_ticket_method": "linkMicFanTicket",
        "link_mic_armies": "linkMicArmies",
        "goal_update": "goalUpdate",
        "link_mic_method": "linkMicMethod",
        "in_room_banner": "inRoomBanner",
        "link_layer": "linkLayer",
        "social_repost": "socialRepost",
        "link_mic_battle": "linkMicBattle",
        "link_mic_battle_task": "linkMicBattleTask",
        "unauthorized_member": "unauthorizedMember",
        "moderation_delete": "moderationDelete",
        "link_mic_battle_punish_finish": "linkMicBattlePunishFinish",
        "link_message": "linkMessage",
        "worker_info": "workerInfo",
        "tiktok.connect": "transportConnect"
    ]

    private static func userFacingMessage(for error: Error) -> String {
        let nsError = error as NSError

        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost, NSURLErrorNetworkConnectionLost:
                return "The token service is not reachable. Check the backend URL and try again."
            case NSURLErrorTimedOut:
                return "The token request timed out. Try again."
            case NSURLErrorNotConnectedToInternet:
                return "No network connection is available."
            default:
                break
            }
        }

        #if canImport(EulerLiveKit)
        if let liveError = error as? EulerLiveError {
            return liveError.description
        }
        #endif

        return "Connection failed. Please try again."
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
