import SwiftUI

struct SplashScreenView: View {
    @State private var titleScale: CGFloat = 0.7
    @State private var titleOpacity: Double = 0.0
    @State private var glowIntensity: Double = 0.0
    @State private var pulse: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                TikTokBackgroundView()
                    .ignoresSafeArea()

                RadialGradient(
                    colors: [
                        TikTokTheme.Palette.accentPink.opacity(glowIntensity),
                        TikTokTheme.Palette.accentCyan.opacity(glowIntensity * 0.62),
                        .clear
                    ],
                    center: .center,
                    startRadius: 20,
                    endRadius: 220
                )
                .blur(radius: 34)
                .scaleEffect(pulse ? 1.10 : 0.90)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: pulse)

                VStack(spacing: 18) {
                    Spacer(minLength: 0)

                    VStack(spacing: 20) {
                        HStack(spacing: 18) {
                            glowDot(
                                color: TikTokTheme.Palette.accentCyan,
                                size: 22,
                                scale: pulse ? 1.22 : 0.84,
                                yOffset: pulse ? -2 : 2
                            )

                            glowDot(
                                color: TikTokTheme.Palette.accentPink,
                                size: 22,
                                scale: pulse ? 0.84 : 1.22,
                                yOffset: pulse ? 2 : -2
                            )
                        }

                        VStack(spacing: 6) {
                            Text("DISTURB")
                                .font(.system(size: 44, weight: .black, design: .rounded))
                                .foregroundStyle(TikTokTheme.Palette.primaryText)

                            Text("MY LIVE")
                                .font(.system(size: 44, weight: .black, design: .rounded))
                                .foregroundStyle(TikTokTheme.Palette.primaryText)

                            Text("Live interaction engine")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(TikTokTheme.Palette.secondaryText)
                                .padding(.top, 8)
                        }
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)
                    }
                    .offset(y: 8)

                    Spacer(minLength: 0)
                }
                .padding(.top, geometry.safeAreaInsets.top + 8)
                .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                .padding(.horizontal, 24)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .task {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.65)) {
                titleScale = 1.05
                titleOpacity = 1.0
            }

            try? await Task.sleep(nanoseconds: 180_000_000)

            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                titleScale = 1.0
            }

            withAnimation(.easeOut(duration: 0.4)) {
                glowIntensity = 0.68
            }

            pulse = true
        }
    }

    private func glowDot(
        color: Color,
        size: CGFloat,
        scale: CGFloat,
        yOffset: CGFloat
    ) -> some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .offset(y: yOffset)
            .shadow(color: color.opacity(0.95), radius: 18)
            .shadow(color: color.opacity(0.55), radius: 32)
            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: scale)
    }
}
