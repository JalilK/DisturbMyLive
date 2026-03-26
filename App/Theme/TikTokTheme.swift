import SwiftUI

enum TikTokTheme {
    enum Palette {
        static let backgroundBase = Color(red: 0.10, green: 0.05, blue: 0.10)
        static let backgroundTop = Color(red: 0.22, green: 0.00, blue: 0.10)
        static let backgroundBottom = Color(red: 0.04, green: 0.10, blue: 0.12)

        static let surface = Color.white.opacity(0.08)
        static let surfaceStrong = Color.white.opacity(0.14)
        static let border = Color.white.opacity(0.12)
        static let primaryText = Color.white
        static let secondaryText = Color.white.opacity(0.72)
        static let tertiaryText = Color.white.opacity(0.54)
        static let accentPink = Color(red: 1.0, green: 0.04, blue: 0.44)
        static let accentCyan = Color(red: 0.15, green: 0.95, blue: 1.0)
        static let success = Color.green.opacity(0.9)
        static let warning = Color.orange.opacity(0.95)
        static let danger = Color.red.opacity(0.95)
    }

    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 18
        static let controlCornerRadius: CGFloat = 14
        static let compactSpacing: CGFloat = 10
        static let regularSpacing: CGFloat = 14
    }
}

struct TikTokBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    TikTokTheme.Palette.backgroundTop,
                    TikTokTheme.Palette.backgroundBase,
                    TikTokTheme.Palette.backgroundBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [
                    TikTokTheme.Palette.accentPink.opacity(0.30),
                    TikTokTheme.Palette.accentPink.opacity(0.10),
                    .clear
                ],
                center: UnitPoint(x: 0.08, y: 0.12),
                startRadius: 20,
                endRadius: 420
            )

            RadialGradient(
                colors: [
                    TikTokTheme.Palette.accentCyan.opacity(0.24),
                    TikTokTheme.Palette.accentCyan.opacity(0.08),
                    .clear
                ],
                center: UnitPoint(x: 0.92, y: 0.88),
                startRadius: 20,
                endRadius: 420
            )

            LinearGradient(
                colors: [
                    Color.white.opacity(0.03),
                    Color.clear,
                    Color.black.opacity(0.08)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct TikTokPanel<Content: View>: View {
    let title: String
    let subtitle: String?
    @ViewBuilder var content: Content

    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(TikTokTheme.Palette.primaryText)

                if let subtitle, subtitle.isEmpty == false {
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(TikTokTheme.Palette.secondaryText)
                        .lineLimit(2)
                }
            }

            content
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: TikTokTheme.Layout.cardCornerRadius, style: .continuous)
                .fill(TikTokTheme.Palette.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: TikTokTheme.Layout.cardCornerRadius, style: .continuous)
                .stroke(TikTokTheme.Palette.border, lineWidth: 1)
        )
    }
}

struct TikTokPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(TikTokTheme.Palette.primaryText)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: TikTokTheme.Layout.controlCornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                TikTokTheme.Palette.accentPink,
                                TikTokTheme.Palette.accentCyan
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .opacity(configuration.isPressed ? 0.86 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}

struct TikTokSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(TikTokTheme.Palette.primaryText)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: TikTokTheme.Layout.controlCornerRadius, style: .continuous)
                    .fill(TikTokTheme.Palette.surfaceStrong)
            )
            .overlay(
                RoundedRectangle(cornerRadius: TikTokTheme.Layout.controlCornerRadius, style: .continuous)
                    .stroke(TikTokTheme.Palette.border, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.86 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
    }
}

struct TikTokToggleChip: View {
    let title: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Circle()
                    .fill(isOn ? TikTokTheme.Palette.accentPink : TikTokTheme.Palette.tertiaryText)
                    .frame(width: 8, height: 8)

                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(TikTokTheme.Palette.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer(minLength: 0)

                Text(isOn ? "ON" : "OFF")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(isOn ? TikTokTheme.Palette.primaryText : TikTokTheme.Palette.secondaryText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(isOn ? TikTokTheme.Palette.accentPink.opacity(0.95) : TikTokTheme.Palette.surfaceStrong)
                    )
            }
            .padding(.horizontal, 12)
            .frame(height: 42)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(TikTokTheme.Palette.surfaceStrong)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(TikTokTheme.Palette.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
