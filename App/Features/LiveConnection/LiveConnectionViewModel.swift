import Foundation

@MainActor
final class LiveConnectionViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var disturbancesEnabled: Bool = true
    @Published var isMuted: Bool = false
    @Published private(set) var connectionState: LiveConnectionState = .idle
    @Published private(set) var recentEvents: [LiveEventEnvelope] = []
    @Published private(set) var recentTriggers: [DisturbanceTrigger] = []

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
        let requestedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        connectionState = .connecting(username: requestedUsername)

        Task {
            do {
                try await service.connect(username: requestedUsername)
                connectionState = .connected(username: requestedUsername)
            } catch {
                connectionState = .failed(message: error.localizedDescription)
            }
        }
    }

    func disconnect() {
        Task {
            await service.disconnect()
            audioService.stopAll()
            connectionState = .disconnected
        }
    }

    func process(event: LiveEventEnvelope) {
        recentEvents.insert(event, at: 0)
        if recentEvents.count > 25 {
            recentEvents = Array(recentEvents.prefix(25))
        }

        guard disturbancesEnabled else {
            return
        }

        guard let trigger = mapper.map(event: event) else {
            return
        }

        recentTriggers.insert(trigger, at: 0)
        if recentTriggers.count > 25 {
            recentTriggers = Array(recentTriggers.prefix(25))
        }

        guard isMuted == false else {
            return
        }

        audioService.play(action: trigger.action)
    }

    private func startObservingEvents() {
        eventTask = Task { [weak self] in
            guard let self else {
                return
            }

            for await event in service.events {
                self.process(event: event)
            }
        }
    }
}
