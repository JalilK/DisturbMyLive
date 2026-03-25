import Foundation

@MainActor
final class LiveConnectionViewModel: ObservableObject {
    @Published var username: String = ""
    @Published private(set) var connectionState: LiveConnectionState = .idle
    @Published private(set) var recentEvents: [LiveEventEnvelope] = []

    private let service: LiveConnectionServiceProtocol
    private var eventTask: Task<Void, Never>?

    init(service: LiveConnectionServiceProtocol) {
        self.service = service
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
            connectionState = .disconnected
        }
    }

    private func startObservingEvents() {
        eventTask = Task { [weak self] in
            guard let self else { return }

            for await event in service.events {
                self.recentEvents.insert(event, at: 0)
                if self.recentEvents.count > 25 {
                    self.recentEvents = Array(self.recentEvents.prefix(25))
                }
            }
        }
    }
}
