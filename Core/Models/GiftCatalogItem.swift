import Foundation

struct GiftCatalogItem: Identifiable, Equatable {
    let id: UUID
    let title: String
    let soundDescription: String
    let triggerKind: TriggerKind
    let iconURL: URL?

    init(
        id: UUID = UUID(),
        title: String,
        soundDescription: String,
        triggerKind: TriggerKind,
        iconURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.soundDescription = soundDescription
        self.triggerKind = triggerKind
        self.iconURL = iconURL
    }
}
