import AudioToolbox
import Foundation

protocol DisturbanceAudioServiceProtocol: AnyObject {
    func play(action: DisturbanceAction)
    func stopAll()
}

final class SystemDisturbanceAudioService: DisturbanceAudioServiceProtocol {
    func play(action: DisturbanceAction) {
        AudioServicesPlaySystemSound(systemSoundID(for: action))
    }

    func stopAll() {
    }

    private func systemSoundID(for action: DisturbanceAction) -> SystemSoundID {
        switch action {
        case .airhorn:
            return 1016
        case .commentPulse:
            return 1104
        case .likeMilestone:
            return 1025
        }
    }
}
