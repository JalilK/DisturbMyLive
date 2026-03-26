import SwiftUI

@main
struct DisturbMyLiveApp: App {
    private let service: LiveConnectionServiceProtocol = EulerLiveKitLiveConnectionService()

    @State private var isShowingSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                LiveConnectionRootView(service: service)
                    .ignoresSafeArea()

                if isShowingSplash {
                    SplashScreenView()
                        .ignoresSafeArea()
                }
            }
            .task {
                guard isShowingSplash else { return }
                try? await Task.sleep(nanoseconds: 1_350_000_000)
                isShowingSplash = false
            }
        }
    }
}
