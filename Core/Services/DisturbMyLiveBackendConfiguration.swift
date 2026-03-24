import EulerLiveKit
import Foundation

enum DisturbMyLiveBackendConfiguration {
    static var backendBaseURL: URL {
        guard let url = URL(string: "http://127.0.0.1:8787") else {
            preconditionFailure("Invalid backend base URL")
        }
        return url
    }

    static var liveConfiguration: EulerLiveConfiguration {
        EulerLiveConfiguration(
            backendBaseURL: backendBaseURL,
            tokenEndpointPath: "/token",
            eventHistoryLimit: 250,
            requestTimeoutSeconds: 30
        )
    }
}
