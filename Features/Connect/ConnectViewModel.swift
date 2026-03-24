import Foundation
import Observation

@Observable
final class ConnectViewModel {
    var username = ""
    var connectionState: StreamConnectionState = .idle

    var canSubmit: Bool {
        username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
    }

    func attemptConnection() async {
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        guard cleanUsername.isEmpty == false else { return }

        connectionState = .connecting(username: cleanUsername)

        try? await Task.sleep(nanoseconds: 500_000_000)

        connectionState = .connected(username: cleanUsername)
    }

    func setFailure(message: String) {
        let cleanUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        connectionState = .failed(username: cleanUsername, message: message)
    }
}
