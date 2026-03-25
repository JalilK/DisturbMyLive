import Foundation

enum LiveConnectionState: Equatable {
    case idle
    case connecting(username: String)
    case connected(username: String)
    case disconnected
    case failed(message: String)
}

enum LiveEventKind: String, CaseIterable, Equatable {
    case roomInfo
    case member
    case gift
    case like
    case comment
    case follow
    case share
    case roomUser
    case liveIntro
    case roomMessage
    case caption
    case barrage
    case linkMicFanTicket
    case linkMicArmies
    case goalUpdate
    case linkMicMethod
    case inRoomBanner
    case linkLayer
    case socialRepost
    case linkMicBattle
    case linkMicBattleTask
    case unauthorizedMember
    case moderationDelete
    case linkMicBattlePunishFinish
    case linkMessage
    case workerInfo
    case transportConnect
    case unknown
}

struct LiveEventEnvelope: Identifiable, Equatable, Sendable {
    let id: UUID
    let kind: LiveEventKind
    let title: String
    let timestamp: Date
    let rawPayload: String?

    init(
        id: UUID = UUID(),
        kind: LiveEventKind,
        title: String,
        timestamp: Date = Date(),
        rawPayload: String? = nil
    ) {
        self.id = id
        self.kind = kind
        self.title = title
        self.timestamp = timestamp
        self.rawPayload = rawPayload
    }
}
