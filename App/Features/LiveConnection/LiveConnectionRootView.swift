import SwiftUI

struct LiveConnectionRootView: View {
    @StateObject private var viewModel: LiveConnectionViewModel

    init(service: LiveConnectionServiceProtocol) {
        _viewModel = StateObject(
            wrappedValue: LiveConnectionViewModel(service: service)
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    controlsSection
                    triggersSection
                    eventsSection
                }
                .padding()
            }
            .navigationTitle("DisturbMyLive")
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Live disturbance MVP")
                .font(.largeTitle.bold())

            Text("Connect to a live TikTok username, map events to disruptive audio, and surface the trigger log in real time.")
                .foregroundStyle(.secondary)

            Text(stateText)
                .font(.headline)
        }
    }

    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Connection")
                .font(.title3.bold())

            TextField("@username", text: $viewModel.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

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

            Toggle("Disturbances enabled", isOn: $viewModel.disturbancesEnabled)
            Toggle("Mute audio", isOn: $viewModel.isMuted)
        }
    }

    private var triggersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent triggers")
                .font(.title3.bold())

            if viewModel.recentTriggers.isEmpty {
                Text("No trigger yet")
                    .foregroundStyle(.secondary)
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.recentTriggers) { trigger in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trigger.action.displayName)
                                .font(.headline)
                            Text(trigger.message)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }

    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent live events")
                .font(.title3.bold())

            if viewModel.recentEvents.isEmpty {
                Text("No event yet")
                    .foregroundStyle(.secondary)
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.recentEvents) { event in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.kind.rawValue)
                                .font(.headline)
                            Text(event.title)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
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
            return "Failed \(message)"
        }
    }
}
