import EulerLiveKit
import Foundation

@MainActor
final class LiveConnectionService {
    private let client: EulerLiveClient

    var onStatusChange: ((EulerConnectionStatus) -> Void)?
    var onEventRecord: ((EulerDebugEventRecord) -> Void)?

    init(
        configuration: EulerLiveConfiguration = DisturbMyLiveBackendConfiguration.liveConfiguration,
        tokenProvider: (any EulerTokenProvider)? = nil
    ) {
        let resolvedTokenProvider = tokenProvider ?? BackendTokenService(configuration: configuration)
        self.client = EulerLiveClient(
            configuration: configuration,
            tokenProvider: resolvedTokenProvider
        )

        self.client.onStatusChange = { [weak self] status in
            Task { @MainActor in
                self?.onStatusChange?(status)
            }
        }

        self.client.onEventRecord = { [weak self] record in
            Task { @MainActor in
                self?.onEventRecord?(record)
            }
        }
    }

    func connect(to uniqueId: String) async throws {
        try await client.connect(to: uniqueId)
    }

    func disconnect() async {
        await client.disconnect()
    }

    func clearHistory() {
        client.clearHistory()
    }
}
