import EulerLiveKit
import Foundation

@MainActor
final class LiveConnectionService {
    private let client: EulerLiveClient

    var onStatusChange: ((EulerConnectionStatus) -> Void)?

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
