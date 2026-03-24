import Foundation
import Observation

@Observable
final class GiftCatalogViewModel {
    var items: [GiftCatalogItem] = [
        GiftCatalogItem(title: "Rose", soundDescription: "Soft chime", triggerKind: .gift),
        GiftCatalogItem(title: "TikTok", soundDescription: "Sharp digital hit", triggerKind: .gift),
        GiftCatalogItem(title: "Like Threshold", soundDescription: "Fast pulse", triggerKind: .like),
        GiftCatalogItem(title: "Follow", soundDescription: "Bright confirm tone", triggerKind: .follow),
        GiftCatalogItem(title: "Share", soundDescription: "Wide sweep", triggerKind: .share),
        GiftCatalogItem(title: "Comment", soundDescription: "Short pop", triggerKind: .comment),
        GiftCatalogItem(title: "Join", soundDescription: "Crowd tick", triggerKind: .join)
    ]
}
