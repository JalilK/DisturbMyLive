import SwiftUI

struct ConnectView: View {
    @State private var viewModel = ConnectViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("DisturbMyLive")
                    .font(.largeTitle.bold())

                Text("Enter a TikTok LIVE username")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                TextField("@username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                Button("Connect") {
                    Task {
                        await viewModel.attemptConnection()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.canSubmit == false)

                switch viewModel.connectionState {
                case .idle:
                    Text("Backend token service 127.0.0.1 on port 8787")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                case .connecting(let username):
                    ProgressView("Connecting to \(username)")

                case .connected(let username):
                    Text("Connected to \(username)")
                        .foregroundStyle(.green)

                case .failed(_, let message):
                    Text(message)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding()
            .navigationDestination(
                isPresented: Binding(
                    get: { viewModel.connectedUsername != nil },
                    set: { isPresented in
                        if isPresented == false {
                            viewModel.disconnectAndReset()
                        }
                    }
                )
            ) {
                if let connectedUsername = viewModel.connectedUsername {
                    GiftCatalogView(username: connectedUsername)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    ConnectView()
}
