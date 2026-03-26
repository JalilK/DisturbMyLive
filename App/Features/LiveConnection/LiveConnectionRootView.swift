import SwiftUI

struct LiveConnectionRootView: View {
    @StateObject private var viewModel: LiveConnectionViewModel
    @State private var isShowingCatalog = false

    init(service: LiveConnectionServiceProtocol) {
        _viewModel = StateObject(
            wrappedValue: LiveConnectionViewModel(service: service)
        )
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    TikTokBackgroundView()
                        .ignoresSafeArea()

                    VStack(spacing: TikTokTheme.Layout.regularSpacing) {
                        topBar
                        connectionPanel
                        triggerPanel
                        eventsPanel
                            .frame(maxHeight: .infinity)
                    }
                    .padding(.horizontal, TikTokTheme.Layout.screenHorizontalPadding)
                    .padding(.top, geometry.safeAreaInsets.top + 24)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 12)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height,
                        alignment: .top
                    )
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .top
                )
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $isShowingCatalog) {
                if let username = viewModel.connectedUsername {
                    GiftCatalogView(username: username)
                }
            }
            .onChange(of: viewModel.connectionState) { _, newValue in
                if case .connected = newValue {
                    isShowingCatalog = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

private extension LiveConnectionRootView {
    var topBar: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("DISTURB MY LIVE")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(TikTokTheme.Palette.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(stateText)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(stateColor)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            HStack(spacing: 6) {
                Circle()
                    .fill(TikTokTheme.Palette.accentCyan)
                    .frame(width: 10, height: 10)

                Circle()
                    .fill(TikTokTheme.Palette.accentPink)
                    .frame(width: 10, height: 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var connectionPanel: some View {
        TikTokPanel(
            title: "Live connection",
            subtitle: "Compact full-screen control surface"
        ) {
            VStack(spacing: 12) {
                usernameField
                actionButtons
                toggleRow

                if case .failed(let message) = viewModel.connectionState {
                    errorBanner(message)
                }
            }
        }
    }

    var triggerPanel: some View {
        TikTokPanel(
            title: "Recent triggers",
            subtitle: "High-visibility reactions"
        ) {
            VStack(spacing: 8) {
                if triggerRows.isEmpty {
                    compactEmptyState("No trigger yet")
                } else {
                    ForEach(triggerRows) { trigger in
                        triggerRow(trigger)
                    }
                }
            }
        }
    }

    var eventsPanel: some View {
        TikTokPanel(
            title: "Recent live events",
            subtitle: "Compact event feed"
        ) {
            Group {
                if eventRows.isEmpty {
                    compactEmptyState("No event yet")
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 8) {
                            ForEach(eventRows) { event in
                                eventRow(event)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    var usernameField: some View {
        ZStack(alignment: .leading) {
            if viewModel.username.isEmpty {
                Text("@username")
                    .foregroundStyle(TikTokTheme.Palette.tertiaryText)
                    .padding(.horizontal, 14)
            }

            TextField("", text: $viewModel.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(TikTokTheme.Palette.primaryText)
                .padding(.horizontal, 14)
        }
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: TikTokTheme.Layout.controlCornerRadius, style: .continuous)
                .fill(TikTokTheme.Palette.surfaceStrong)
        )
        .overlay(
            RoundedRectangle(cornerRadius: TikTokTheme.Layout.controlCornerRadius, style: .continuous)
                .stroke(TikTokTheme.Palette.border, lineWidth: 1)
        )
    }

    var actionButtons: some View {
        HStack(spacing: 10) {
            Button("Connect") {
                viewModel.connect()
            }
            .buttonStyle(TikTokPrimaryButtonStyle())

            Button("Disconnect") {
                viewModel.disconnect()
            }
            .buttonStyle(TikTokSecondaryButtonStyle())
        }
    }

    var toggleRow: some View {
        HStack(spacing: 10) {
            TikTokToggleChip(
                title: "Disturbances",
                isOn: viewModel.disturbancesEnabled
            ) {
                viewModel.disturbancesEnabled.toggle()
            }

            TikTokToggleChip(
                title: "Mute",
                isOn: viewModel.isMuted
            ) {
                viewModel.isMuted.toggle()
            }
        }
    }

    func triggerRow(_ trigger: DisturbanceTrigger) -> some View {
        HStack(alignment: .top, spacing: 10) {
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(triggerAccent(for: trigger.action))
                .frame(width: 5)

            VStack(alignment: .leading, spacing: 3) {
                Text(trigger.action.displayName.uppercased())
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(TikTokTheme.Palette.primaryText)
                    .lineLimit(1)

                Text(trigger.message)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(TikTokTheme.Palette.secondaryText)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(TikTokTheme.Palette.surfaceStrong)
        )
    }

    func eventRow(_ event: LiveEventEnvelope) -> some View {
        HStack(alignment: .center, spacing: 10) {
            Text(event.kind.rawValue.uppercased())
                .font(.system(size: 11, weight: .heavy))
                .foregroundStyle(TikTokTheme.Palette.primaryText)
                .lineLimit(1)
                .padding(.horizontal, 10)
                .frame(height: 28)
                .background(
                    Capsule()
                        .fill(TikTokTheme.Palette.surfaceStrong)
                )

            Text(event.title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(TikTokTheme.Palette.secondaryText)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(TikTokTheme.Palette.surfaceStrong)
        )
    }

    var triggerRows: ArraySlice<DisturbanceTrigger> {
        viewModel.recentTriggers.prefix(3)
    }

    var eventRows: ArraySlice<LiveEventEnvelope> {
        viewModel.recentEvents.prefix(25)
    }

    @ViewBuilder
    func compactEmptyState(_ text: String) -> some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(TikTokTheme.Palette.surfaceStrong)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .overlay(
                Text(text)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(TikTokTheme.Palette.secondaryText)
            )
    }

    @ViewBuilder
    func errorBanner(_ message: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(TikTokTheme.Palette.danger)
                .frame(width: 10, height: 10)
                .padding(.top, 4)

            Text(message)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(TikTokTheme.Palette.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(TikTokTheme.Palette.surfaceStrong)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(TikTokTheme.Palette.danger.opacity(0.45), lineWidth: 1)
        )
    }

    func triggerAccent(for action: DisturbanceAction) -> Color {
        switch action {
        case .airhorn:
            return TikTokTheme.Palette.accentPink
        case .commentPulse:
            return TikTokTheme.Palette.accentCyan
        case .likeMilestone:
            return TikTokTheme.Palette.warning
        }
    }

    var stateText: String {
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

    var stateColor: Color {
        switch viewModel.connectionState {
        case .idle, .disconnected:
            return TikTokTheme.Palette.secondaryText
        case .connecting:
            return TikTokTheme.Palette.warning
        case .connected:
            return TikTokTheme.Palette.success
        case .failed:
            return TikTokTheme.Palette.danger
        }
    }
}
