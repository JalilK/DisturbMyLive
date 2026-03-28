import AVFoundation
import SwiftUI
import UIKit

@MainActor
final class CameraCatalogViewModel: ObservableObject {
    enum CameraState: Equatable {
        case idle
        case authorized
        case denied
        case unavailable
        case failed(message: String)
    }

    struct OverlayRule: Identifiable, Equatable {
        let id = UUID()
        let trigger: String
        let consequence: String
        let accent: Color
    }

    @Published private(set) var state: CameraState = .idle
    @Published private(set) var rules: [OverlayRule] = [
        OverlayRule(trigger: "Rose", consequence: "Airhorn", accent: .pink),
        OverlayRule(trigger: "Comment", consequence: "Comment Pulse", accent: .cyan),
        OverlayRule(trigger: "100 Likes", consequence: "Like Milestone", accent: .orange)
    ]
    @Published var activeEffectBanner: String?
    @Published var isShowingActiveEffect: Bool = false

    let session = AVCaptureSession()

    private var isConfigured = false
    private let sessionQueue = DispatchQueue(label: "com.jalilkennedy.DisturbMyLive.camera-session")

    func start() {
        Task {
            let granted = await requestAccessIfNeeded()

            guard granted else {
                state = .denied
                return
            }

            do {
                try configureIfNeeded()
                state = .authorized
                startRunning()
            } catch {
                state = .failed(message: String(describing: error))
            }
        }
    }

    func stop() {
        sessionQueue.async { [session] in
            if session.isRunning {
                session.stopRunning()
            }
        }
    }

    func demoTrigger() {
        guard let sample = rules.randomElement() else { return }
        activeEffectBanner = "\(sample.trigger) → \(sample.consequence)"
        withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
            isShowingActiveEffect = true
        }

        Task {
            try? await Task.sleep(nanoseconds: 1_300_000_000)
            withAnimation(.easeInOut(duration: 0.25)) {
                isShowingActiveEffect = false
            }
        }
    }

    private func requestAccessIfNeeded() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }

    private func configureIfNeeded() throws {
        guard isConfigured == false else { return }

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            state = .unavailable
            return
        }

        session.beginConfiguration()
        session.sessionPreset = .high

        defer {
            session.commitConfiguration()
        }

        let input = try AVCaptureDeviceInput(device: device)
        guard session.canAddInput(input) else {
            throw CameraCatalogError.cannotAddInput
        }
        session.addInput(input)

        isConfigured = true
    }

    private func startRunning() {
        sessionQueue.async { [session] in
            if session.isRunning == false {
                session.startRunning()
            }
        }
    }
}

enum CameraCatalogError: LocalizedError {
    case cannotAddInput

    var errorDescription: String? {
        switch self {
        case .cannotAddInput:
            return "Front camera input could not be added."
        }
    }
}

struct CameraCatalogView: View {
    let username: String
    @StateObject private var viewModel = CameraCatalogViewModel()

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .authorized, .idle:
                CameraPreviewView(session: viewModel.session)
                    .ignoresSafeArea()

            case .denied:
                fallbackView(
                    title: "Camera Access Needed",
                    message: "Allow camera access in Settings to use the live catalog surface."
                )

            case .unavailable:
                fallbackView(
                    title: "Front Camera Unavailable",
                    message: "This device could not provide a front camera preview."
                )

            case .failed(let message):
                fallbackView(
                    title: "Camera Failed",
                    message: message
                )
            }

            overlayChrome
        }
        .background(Color.black)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
    }

    private var overlayChrome: some View {
        VStack(spacing: 0) {
            topBar
            Spacer()
            ruleLegend
            activeEffectBanner
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 24)
        .ignoresSafeArea(edges: .bottom)
    }

    private var topBar: some View {
        HStack(alignment: .center, spacing: 12) {
            HStack(spacing: 8) {
                Circle()
                    .fill(.red)
                    .frame(width: 8, height: 8)

                Text("LIVE")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.black.opacity(0.48))
            .clipShape(Capsule())

            Text("@\(username)")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.black.opacity(0.35))
                .clipShape(Capsule())

            Spacer()

            Button {
                viewModel.demoTrigger()
            } label: {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.black.opacity(0.35))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private var ruleLegend: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Viewer actions")
                .font(.system(size: 12, weight: .heavy))
                .foregroundStyle(.white.opacity(0.92))
                .textCase(.uppercase)

            VStack(spacing: 10) {
                ForEach(viewModel.rules) { rule in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(rule.accent)
                            .frame(width: 10, height: 10)

                        Text(rule.trigger)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundStyle(.white.opacity(0.7))

                        Text(rule.consequence)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.88))
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 48)
                    .background(.black.opacity(0.42))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
        .padding(14)
        .background(.ultraThinMaterial.opacity(0.72))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .padding(.bottom, 14)
    }

    @ViewBuilder
    private var activeEffectBanner: some View {
        if let text = viewModel.activeEffectBanner, viewModel.isShowingActiveEffect {
            HStack(spacing: 10) {
                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Text(text)
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(.black.opacity(0.62))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(.pink.opacity(0.45), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    @ViewBuilder
    private func fallbackView(title: String, message: String) -> some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)

                Text(message)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.78))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        if let connection = view.previewLayer.connection, connection.isVideoMirroringSupported {
            connection.automaticallyAdjustsVideoMirroring = false
            connection.isVideoMirrored = true
        }
        return view
    }

    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        uiView.previewLayer.session = session
    }
}

final class CameraPreviewUIView: UIView {
    override static var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        guard let previewLayer = layer as? AVCaptureVideoPreviewLayer else {
            preconditionFailure("Expected AVCaptureVideoPreviewLayer backing layer")
        }
        return previewLayer
    }
}
