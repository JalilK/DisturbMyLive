# DisturbMyLive Architecture

## System boundary

DisturbMyLive is an iOS SwiftUI app that depends on SwiftUIEulerLiveKit for connection authentication, websocket lifecycle management, typed TikTok LIVE event decoding, and debug event preservation.

## High-level flow

TikTok username
-> app connection request
-> backend token route
-> short-lived websocket credentials
-> SwiftUIEulerLiveKit live client
-> websocket transport
-> typed event decoding
-> DisturbMyLive event intake
-> mapping engine
-> sound action selection
-> audio playback
-> UI state updates
-> debug event history

## Architectural layers

### 1. Targeting layer

Responsibility

- hold the requested TikTok username
- validate connect intent
- initiate and cancel connection attempts

Inputs

- user-entered username

Outputs

- connect request
- disconnect request

### 2. Live transport layer

Responsibility

- use SwiftUIEulerLiveKit client as the single mobile-side transport entry point
- request credentials
- open websocket
- maintain connection state
- receive typed events

Inputs

- target username
- backend token configuration

Outputs

- connection status
- disconnect reason
- typed live events
- debug records

### 3. Session state layer

Responsibility

- own the current live session state for the app
- expose connection state to the UI
- store recent events and recent sound triggers
- coordinate reconnect behavior if supported

Inputs

- transport status updates
- typed events
- disconnect reasons

Outputs

- observable app state for screens and controls

### 4. Mapping layer

Responsibility

- convert typed live events into sound trigger decisions
- centralize all business rules about which events matter
- keep decisions deterministic and testable

Inputs

- typed live events
- user or default mapping config

Outputs

- zero or more sound actions
- audit-friendly trigger decision records

### 5. Audio layer

Responsibility

- resolve sound assets
- play audio
- report playback success or failure
- expose mute and stop controls

Inputs

- sound actions

Outputs

- playback result
- playback state
- error records

### 6. Presentation layer

Responsibility

- show username targeting UI
- show connection status
- show recent event feed
- show mapping config
- show recent triggered sounds
- show debug and failure state in development surfaces

Inputs

- observable session state
- mapping config
- audio status

Outputs

- user actions
- visible feedback

## Recommended module responsibility split inside DisturbMyLive

### App shell

- app entry
- dependency wiring
- environment configuration

### Features

- connect screen
- live session screen
- mapping editor screen
- debug screen

### Domain

- event-to-sound rules
- sound action definitions
- mapping config definitions
- validation logic

### Services

- live connection adapter that wraps SwiftUIEulerLiveKit
- audio playback service
- persistence for local mapping config
- logger or debug recorder

### Test support

- fake live client adapter
- fake audio engine
- deterministic sample events
- manual verification scripts and checklists

## Single operational truth

SwiftUIEulerLiveKit owns:

- token provider contract
- websocket client contract
- typed live event surface
- debug event record shape
- session transport state

DisturbMyLive owns:

- target selection UX
- session orchestration at the app level
- event-to-sound mapping logic
- sound playback behavior
- debugging UX specific to this app
- automation and packaging discipline for this repo

## Failure model

The system must explicitly model and surface at least these failure classes:

- empty or invalid target username
- target user not currently live
- backend token failure
- websocket connect failure
- websocket disconnect
- event decode failure
- unknown event payload
- missing audio asset
- audio playback failure

## Initial implementation sequence

1. Wrap SwiftUIEulerLiveKit in a DisturbMyLive adapter.
2. Expose connection state and recent typed events through observable app state.
3. Implement deterministic event-to-sound mapping engine.
4. Add audio playback layer.
5. Add development debug surfaces.
6. Expand automated and manual validation coverage until all layers are exercised.

