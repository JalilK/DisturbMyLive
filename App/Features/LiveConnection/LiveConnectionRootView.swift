import SwiftUI

struct LiveConnectionRootView: View {
    @StateObject private var viewModel: LiveConnectionViewModel

    init(service: LiveConnectionServiceProtocol) {
        _viewModel = StateObject(wrappedValue: LiveConnectionViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("DisturbMyLive")
                    .font(.largeTitle.bold())

                Text("Connect to a live TikTok username and inspect the adapter event feed.")
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("TikTok username")
                        .font(.headline)

                    TextField("@username", text: $viewModel.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    Text(stateText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 12) {
                    Button("Connect") {
                        viewModel.connect()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Disconnect") {
                        viewModel.disconnect()
                    }
                    .buttonStyle(.bordered)
                }

                List(viewModel.recentEvents) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.kind.rawValue)
                            .font(.headline)
                        Text(event.title)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("Live Connection")
        }
    }

    private var stateText: String {
        switch viewModel.connectionState {
        case .idle:
            return "Idle"
        case .connecting(let username):
            return "Connecting to @\(username)"
        case .connected(let username):
            return "Connected to @\(username)"
        case .disconnected:
            return "Disconnected"
        case .failed(let message):
            return "Failed: \(message)"
        }
    }
}
