import Foundation

struct EventToDisturbanceMapper {
    let likeThreshold: Int
    private(set) var accumulatedLikeCount: Int

    init(
        likeThreshold: Int = 100,
        accumulatedLikeCount: Int = 0
    ) {
        self.likeThreshold = max(1, likeThreshold)
        self.accumulatedLikeCount = max(0, accumulatedLikeCount)
    }

    mutating func map(event: LiveEventEnvelope) -> DisturbanceTrigger? {
        switch event.kind {
        case .gift:
            return DisturbanceTrigger(
                sourceEventKind: event.kind,
                action: .airhorn,
                message: "Gift triggered \(DisturbanceAction.airhorn.displayName)"
            )

        case .comment:
            return DisturbanceTrigger(
                sourceEventKind: event.kind,
                action: .commentPulse,
                message: "Comment triggered \(DisturbanceAction.commentPulse.displayName)"
            )

        case .like:
            accumulatedLikeCount += 1

            guard accumulatedLikeCount.isMultiple(of: likeThreshold) else {
                return nil
            }

            return DisturbanceTrigger(
                sourceEventKind: event.kind,
                action: .likeMilestone,
                message: "\(accumulatedLikeCount) likes triggered \(DisturbanceAction.likeMilestone.displayName)"
            )

        default:
            return nil
        }
    }
}
