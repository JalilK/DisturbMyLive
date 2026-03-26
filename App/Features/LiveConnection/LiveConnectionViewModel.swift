import Foundation

#if canImport(EulerLiveKit)
import EulerLiveKit
#endif

@MainActor
final class LiveConnectionViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var disturbancesEnabled: Bool = true
    @Published var isMuted: Bool = false
    @Published private(set) var connectionState: LiveConnectionState = .idle
    @Published private(set) var recentEvents: [LiveEventEnvelope] = []
    @Published private(set) var recentTriggers: [DisturbanceTrigger] = []
    @Published private(set) var connectedUsername: String?

    private let service: LiveConnectionServiceProtocol
    private let audioService: DisturbanceAudioServiceProtocol
    private var mapper: EventToDisturbanceMapper
    private var eventTask: Task<Void, Never>?

    init(
        service: LiveConnectionServiceProtocol,
        audioService: DisturbanceAudioServiceProtocol = SystemDisturbanceAudioService(),
        mapper: EventToDisturbanceMapper = EventToDisturbanceMapper()
    ) {
        self.service = service
        self.audioService = audioService
        self.mapper = mapper
        startObservingEvents()
    }

    deinit {
        eventTask?.cancel()
    }

    func connect() {
        let requestedUsername = normalizedUsername(from: username)

        guard requestedUsername.isEmpty == false else {
            connectedUsername = nil
            connectionState = .failed(message: LiveConnectionServiceError.emptyUsername.localizedDescription)
            return
        }

        connectionState = .connecting(username: requestedUsername)
        connectedUsername = nil

        Task {
            do {
                try await service.connect(username: requestedUsername)
                connectedUsername = requestedUsername
                connectionState = .connected(username: requestedUsername)
            } catch {
                connectedUsername = nil
                connectionState = .failed(message: userFacingMessage(for: error))
            }
        }
    }

    func disconnect() {
        Task {
            await service.disconnect()
            audioService.stopAll()
            connectedUsername = nil
            connectionState = .disconnected
        }
    }

    func process(event: LiveEventEnvelope) {
        recentEvents.insert(event, at: 0)
        if recentEvents.count > 25 {
            recentEvents = Array(recentEvents.prefix(25))
        }

        guard disturbancesEnabled else { return }
        guard let trigger = mapper.map(event: event) else { return }

        recentTriggers.insert(trigger, at: 0)
        if recentTriggers.count > 25 {
            recentTriggers = Array(recentTriggers.prefix(25))
        }

        guard isMuted == false else { return }
        audioService.play(action: trigger.action)
    }

    private func startObservingEvents() {
        eventTask = Task { [weak self] in
            guard let self else { return }
            for await event in service.events {
                self.process(event: event)
            }
        }
    }

    private func normalizedUsername(from rawValue: String) -> String {
        rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "@", with: "")
    }

    private func userFacingMessage(for error: Error) -> String {
        #if canImport(EulerLiveKit)
        if let liveError = error as? EulerLiveError {
            return liveError.description
        }
        #endif

        return String(describing: error)
    }
}
