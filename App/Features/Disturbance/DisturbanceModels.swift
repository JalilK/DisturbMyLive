import Foundation

enum DisturbanceAction: String, CaseIterable, Equatable {
    case airhorn
    case commentPulse
    case likeMilestone

    var displayName: String {
        switch self {
        case .airhorn:
            return "Airhorn"
        case .commentPulse:
            return "Comment Pulse"
        case .likeMilestone:
            return "Like Milestone"
        }
    }
}

struct DisturbanceTrigger: Identifiable, Equatable, Sendable {
    let id: UUID
    let sourceEventKind: LiveEventKind
    let action: DisturbanceAction
    let message: String
    let timestamp: Date

    init(
        id: UUID = UUID(),
        sourceEventKind: LiveEventKind,
        action: DisturbanceAction,
        message: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.sourceEventKind = sourceEventKind
        self.action = action
        self.message = message
        self.timestamp = timestamp
    }
}
