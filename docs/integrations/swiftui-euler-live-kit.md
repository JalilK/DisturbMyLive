# SwiftUIEulerLiveKit Integration Contract

## Package role in DisturbMyLive

SwiftUIEulerLiveKit is the live-stream connection substrate for DisturbMyLive.
It is responsible for:

- backend-token-based websocket credential retrieval
- websocket connection lifecycle
- typed TikTok LIVE event decoding
- debug record preservation

DisturbMyLive must treat this package as the source of truth for live event transport and model surface.

## DisturbMyLive integration responsibilities

DisturbMyLive must provide:

- username targeting UX
- package configuration wiring
- session state orchestration
- event-to-sound mapping
- audio playback
- app-specific debug and testing surfaces

## Event coverage required by DisturbMyLive

The package currently exposes at least these public event kinds:

- roomInfo
- member
- gift
- like
- comment
- follow
- share
- roomUser
- liveIntro
- roomMessage
- caption
- barrage
- linkMicFanTicket
- linkMicArmies
- goalUpdate
- linkMicMethod
- inRoomBanner
- linkLayer
- socialRepost
- linkMicBattle
- linkMicBattleTask
- unauthorizedMember
- moderationDelete
- linkMicBattlePunishFinish
- linkMessage
- workerInfo
- transportConnect
- unknown

## DisturbMyLive event grouping

### High-priority disruptive triggers

- gift
- comment
- barrage
- follow
- share
- member
- unauthorizedMember

### Session and room intelligence

- roomInfo
- roomUser
- liveIntro
- roomMessage
- caption
- inRoomBanner

### Battle and competitive events

- linkMicFanTicket
- linkMicArmies
- goalUpdate
- linkMicMethod
- linkLayer
- socialRepost
- linkMicBattle
- linkMicBattleTask
- linkMicBattlePunishFinish
- linkMessage

### Operational and debug events

- moderationDelete
- workerInfo
- transportConnect
- unknown

## Adapter rule

DisturbMyLive should use a thin adapter around EulerLiveClient rather than scattering package calls across views.
That adapter should translate package outputs into app-domain session updates and keep the rest of the app insulated from package churn.

## Contract tests to maintain

- app compiles against required package public types
- required event kinds remain supported
- connection status mapping remains aligned
- unknown payload path remains non-fatal

