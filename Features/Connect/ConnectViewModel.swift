import EulerLiveKit
import Foundation
import Observation

@MainActor
@Observable
final class ConnectViewModel {
    var username = ""
    var connectionState: StreamConnectionState = .idle
    var connectedUsername: String?

    private let connectionService: LiveConnectionService
    private var attemptedUsername: String?
    private var isUserInitiatedDisconnect = false

    init(connectionService: LiveConnectionService) {
        self.connectionService = connectionService

        self.connectionService.onStatusChange = { [weak self] status in
            self?.handleConnectionStatus(status)
        }
    }

    convenience init() {
        self.init(connectionService: LiveConnectionService())
    }

    var canSubmit: Bool {
        guard username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            return false
        }

        switch connectionState {
        case .idle, .failed:
            return true
        case .connecting, .connected, .disconnecting:
            return false
        }
    }

    func attemptConnection() async {
        let cleanUsername = normalizedUsername(from: username)

        guard cleanUsername.isEmpty == false else { return }

        isUserInitiatedDisconnect = false
        attemptedUsername = cleanUsername
        connectedUsername = nil
        connectionState = .connecting(username: cleanUsername)

        do {
            try await connectionService.connect(to: cleanUsername)
        } catch {
            connectedUsername = nil
            connectionState = .failed(
                username: cleanUsername,
                message: userFacingMessage(for: error)
            )
        }
    }

    func disconnectAndReset() {
        let activeUsername = connectedUsername ?? attemptedUsername ?? normalizedUsername(from: username)

        isUserInitiatedDisconnect = true
        connectionState = .disconnecting(username: activeUsername)

        Task {
            await connectionService.disconnect()
            connectionService.clearHistory()

            await MainActor.run {
                self.connectedUsername = nil
                self.attemptedUsername = nil
                self.connectionState = .idle
            }
        }
    }

    private func handleConnectionStatus(_ status: EulerConnectionStatus) {
        let activeUsername = attemptedUsername ?? normalizedUsername(from: username)

        switch status {
        case .idle:
            if isUserInitiatedDisconnect {
                connectionState = .idle
            }

        case .fetchingToken, .connecting:
            connectionState = .connecting(username: activeUsername)

        case .connected:
            isUserInitiatedDisconnect = false
            connectedUsername = activeUsername
            connectionState = .connected(username: activeUsername)

        case .failed(let error):
            isUserInitiatedDisconnect = false
            connectedUsername = nil
            connectionState = .failed(
                username: activeUsername,
                message: error.description
            )

        case .disconnected(let reason):
            connectedUsername = nil

            if isUserInitiatedDisconnect {
                attemptedUsername = nil
                connectionState = .idle
                return
            }

            connectionState = .failed(
                username: activeUsername,
                message: String(describing: reason)
            )
        }
    }

    private func normalizedUsername(from rawValue: String) -> String {
        rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "@", with: "")
    }

    private func userFacingMessage(for error: Error) -> String {
        if let liveError = error as? EulerLiveError {
            return liveError.description
        }

        return String(describing: error)
    }
}
