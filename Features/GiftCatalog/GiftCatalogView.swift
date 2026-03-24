import SwiftUI

struct GiftCatalogView: View {
    let username: String
    @State private var viewModel = GiftCatalogViewModel()

    var body: some View {
        List(viewModel.items) { item in
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)

                Text(item.soundDescription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(item.triggerKind.rawValue.capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle(username)
    }
}

#Preview {
    NavigationStack {
        GiftCatalogView(username: "jalil2567")
    }
}
