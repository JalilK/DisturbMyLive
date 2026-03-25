import SwiftUI

@main
struct DisturbMyLiveApp: App {
    private let service: LiveConnectionServiceProtocol = EulerLiveKitLiveConnectionService()

    var body: some Scene {
        WindowGroup {
            LiveConnectionRootView(service: service)
        }
    }
}
