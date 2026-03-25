# DisturbMyLive Requirements

## Product intent

DisturbMyLive is an iPhone app that connects to a currently live TikTok creator through SwiftUIEulerLiveKit and converts selected TikTok LIVE events into disruptive sound effects intended to interrupt, distract, or pressure the streamer in real time.

## Live connection definition

A live connection is a client session created from a TikTok username that is actively live.
The app uses SwiftUIEulerLiveKit as the live transport and event decoding layer.
The mobile app does not hold Euler secrets directly.
The app requests backend-issued short-lived credentials, connects to the websocket, listens for typed live events, and forwards those typed events into the DisturbMyLive event mapping pipeline.

## Primary user goals

1. Enter or select a TikTok username for a creator who is currently live.
2. Connect reliably to that stream.
3. Observe typed TikTok LIVE events as they arrive.
4. Map selected event types to one or more disruptive sound actions.
5. Play the mapped sound action locally with low enough latency to feel live.
6. Surface connection state, recent event activity, and mapping state clearly in the UI.
7. Fail safely when the target user is not live, credentials are invalid, transport drops, or event decoding fails.

## Non-negotiable constraints

1. SwiftUIEulerLiveKit is the source-of-truth integration boundary for the live stream connection and typed event model surface.
2. DisturbMyLive must not reimplement websocket auth or raw Euler transport logic inside the app when the package already owns that responsibility.
3. API keys and signing secrets must stay on the backend.
4. The app must preserve a debugging path for raw payload visibility and decode outcomes.
5. The event-to-sound mapping layer must be deterministic and testable.
6. Every meaningful layer must support automated tests and explicit manual validation steps.

## Core functional requirements

### Stream targeting

- User can provide a TikTok username.
- App requests a connection for that username.
- App rejects empty usernames.
- App surfaces "not live" or "cannot connect" states explicitly.

### Connection lifecycle

- App surfaces idle, connecting, connected, reconnecting, disconnected, and failed states.
- App can disconnect intentionally.
- App can reconnect after transport interruption.
- App records a recent connection history for debugging during development.

### Event intake

- App receives typed events from SwiftUIEulerLiveKit.
- App stores a rolling recent-event feed for the UI.
- App stores enough event metadata to understand what triggered a sound.
- Unknown events remain observable and do not crash the app.

### Event mapping

- Each supported live event kind can be mapped to zero or more sound actions.
- Mappings are editable and visible.
- The mapping engine decides whether an incoming event should trigger audio.
- The mapping engine is pure and deterministic given event input and current mapping config.

### Audio behavior

- Sound playback is local to the device.
- The app can play different sounds for different mapped events.
- The app prevents broken or missing sound assets from crashing the session.
- The app exposes a mute or safe stop control.
- The app logs sound trigger decisions in development builds.

### Debugging and observability

- App surfaces recent typed events.
- App surfaces recent triggered sounds.
- App surfaces decode failures, unknown payloads, and disconnect reasons.
- App preserves a traceable path from TikTok username to connection state to incoming event to chosen sound action.

## Supported event groups

The initial mapping and testing surface must cover at minimum:

- room and audience events
- member and unauthorized member events
- gift events
- like events
- chat and barrage events
- follow and share events
- room message and banner events
- caption events
- goal and battle events
- link and cohost events
- moderation delete events
- worker and transport connection metadata
- unknown events

## Out of scope for bootstrap

- remote multi-device synchronization
- creator-side permissions tooling
- monetization and billing
- cloud analytics beyond basic development logging
- autonomous mapping generation
- packaging automation beyond repo operating system bootstrap and validation setup

## Acceptance criteria for this bootstrap task

1. Repo docs clearly define the live connection boundary.
2. Repo docs clearly define the event surface and mapping surface.
3. Repo docs clearly define transport, decoding, state, UI, and audio responsibilities.
4. Repo docs clearly define what must be tested automatically and manually.
5. Repo planning state is now specific enough to support implementation tasks without guessing.

