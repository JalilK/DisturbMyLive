# DisturbMyLive Architecture

## System boundaries

The iOS app owns UI state, navigation, catalog presentation, and client side connection feedback.
SwiftUIEulerLiveKit owns websocket transport, token service integration boundary, and typed event decoding.
A backend token service will own short lived JWT issuance.

## Module boundaries

- App
  - app entry
- Features/Connect
  - username input
  - connection attempt state
  - connection failure display
  - route to next screen on success
- Features/GiftCatalog
  - gift and interaction catalog presentation
- Core/Models
  - app domain models
- Core/Services
  - app level service protocols and state

## Data flow

User enters username.
Connect feature starts connection request.
Connection layer attempts stream connection through SwiftUIEulerLiveKit.
Success updates app state and routes to catalog screen.
Failure updates app state and presents an error.

## Integration points

- SwiftUIEulerLiveKit package dependency
- Future backend token endpoint
- Future official gift metadata source
- Future audio playback engine

## Naming conventions

- Human readable Swift names
- Feature based folder structure
- App facing wrappers around external transport layer

## State ownership

ConnectViewModel owns connection state for bootstrap.
GiftCatalogViewModel owns visible catalog bootstrap data.

## Error handling boundary

Connection errors must be surfaced as explicit UI state.
Transport errors must not silently fail.
