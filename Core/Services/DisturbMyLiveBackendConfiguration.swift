import EulerLiveKit
import Foundation

enum DisturbMyLiveBackendConfiguration {
    static var backendBaseURL: URL {
        guard let url = URL(string: "https://euler-token-worker.swiftui-euler-api-key.workers.dev") else {
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
