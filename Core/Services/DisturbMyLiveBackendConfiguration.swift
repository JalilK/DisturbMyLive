import Foundation
import EulerLiveKit

enum DisturbMyLiveBackendConfiguration {
    static let backendBaseURL = URL(string: "http://127.0.0.1:8787")!

    static let liveConfiguration = EulerLiveConfiguration(
        backendBaseURL: backendBaseURL,
        tokenEndpointPath: "/token",
        eventHistoryLimit: 250,
        requestTimeoutSeconds: 30
    )
}
