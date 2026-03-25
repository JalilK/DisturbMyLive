# DisturbMyLive Testing Strategy

## Testing mandate

Everything at every layer must be exercised through automated testing and manual testing.
The repo should move toward packaging and faster iteration by removing unverified behavior.

## Automated testing surface

### Unit tests

#### Mapping engine

- event kind to sound decision logic
- disabled mapping behavior
- unknown event behavior
- priority and conflict resolution if multiple rules exist
- rule determinism for repeated identical input

#### Session state

- idle to connecting transitions
- connected state updates
- disconnect and reconnect transitions
- recent event feed retention
- recent trigger feed retention
- error propagation to UI state

#### Audio layer

- valid sound action playback path
- missing asset handling
- mute behavior
- stop behavior
- duplicate rapid-fire trigger handling if throttling exists

#### Configuration and persistence

- mapping config save and load
- default config bootstrap
- invalid config rejection or fallback

### Integration tests

#### Live client adapter

- adapter receives typed events from SwiftUIEulerLiveKit
- adapter forwards connection state changes
- adapter forwards disconnect reasons
- adapter preserves debug records

#### Event intake to audio pipeline

- typed event enters the app
- mapping engine chooses sound action
- audio service receives expected request
- UI state records the trigger

### Decoder and package contract tests

Where appropriate, DisturbMyLive should include contract tests tied to the package surface it depends on.

- compile against expected public EulerLiveKit types
- verify supported event names required by DisturbMyLive remain mapped
- verify unknown events degrade safely
- verify connection status mapping remains aligned

### UI tests

- connect flow
- disconnect flow
- visible connection state
- recent events visible
- mapping editor basic workflow
- safe stop or mute control

## Manual testing surface

### Manual live connection checklist

1. connect to a currently live username
2. verify visible connected state
3. verify recent events appear
4. verify mapped events trigger expected sounds
5. verify unmapped events do not trigger sounds
6. verify disconnect action works
7. verify bad username path surfaces a useful error
8. verify not-live target path surfaces a useful error
9. verify transport interruption surfaces reconnect or failure state
10. verify debug surface shows recent event and trigger history

### Manual sound checklist

1. each configured sound asset plays
2. rapid repeated events do not crash playback
3. mute disables audible playback
4. safe stop halts active sound output
5. missing sound asset fails visibly without crashing

### Manual regression checklist

1. app launches cleanly
2. package resolves cleanly
3. automated tests pass
4. live connection still works against a real live session
5. mapped events still trigger the same sounds after refactors

## CI expectations

CI should eventually run at minimum:

- build
- unit tests
- integration tests
- lint
- package resolution validation
- any snapshot or UI smoke tests that are stable enough for CI

## Exit criteria for implementation tasks

A task is not complete when code exists.
A task is complete when:

- automated tests for the changed surface pass
- manual validation steps for the changed surface are recorded and pass
- failure modes were exercised
- repo state stays packaging-safe for the next iteration

