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
                    EmptyView()

                case .connecting(let username):
                    ProgressView("Connecting to \(username)")

                case .connected(let username):
                    NavigationLink("Open Gift Sounds") {
                        GiftCatalogView(username: username)
                    }

                case .failed(_, let message):
                    Text(message)
                        .foregroundStyle(.red)
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ConnectView()
}
