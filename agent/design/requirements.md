# DisturbMyLive Requirements

## Project goal

Build a native iPhone app that connects to a TikTok LIVE stream and then shows a catalog of gift and interaction driven sounds.

## User visible outcome

The user can enter a TikTok username.
The app attempts to connect.
If connection fails the app shows a clear error state.
If connection succeeds the app transitions to a catalog screen that lists official TikTok gift icons and interaction items with a description of the sound tied to each trigger.

## Explicit constraints

- Native SwiftUI app
- iOS 17 minimum
- Use SwiftUIEulerLiveKit as the live event transport layer
- Do not ship Euler credentials in the client
- Assume backend issued token flow
- Repo must use ACP artifacts as working memory
- Delivery must remain full replacement friendly
- Verification must be written before feature implementation expands

## Repo names

- App repo name is DisturbMyLive
- Dependency repo is SwiftUIEulerLiveKit

## Platform targets

- iPhone
- Portrait first UI

## Acceptance criteria

- Local repo can be generated and opened as an iOS project
- ACP scaffold exists and reflects project specific rules
- App has a connection entry screen
- App has a post connect catalog screen
- App state supports idle, connecting, connected, and failed
- Verification files exist for future implementation

## Non goals for bootstrap

- Real token service implementation
- Real gift icon ingestion
- Real audio playback
- Production styling
- Creator configuration persistence

## Failure conditions

- App ships secrets in client
- Repo loses task continuity across sessions
- Implementation proceeds without verification surface
- Agent relies on chat memory over repo truth
