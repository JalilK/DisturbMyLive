# Requirements

## Project goal

DisturbMyLive is a native iOS app that lets a user enter a TikTok LIVE username, attempt a live connection through EulerLiveKit, and move into a post-connect catalog surface that shows gifts and interactions with the sound each one should trigger.

## User visible outcome

The user can

- open the app
- enter a TikTok username
- start a connection attempt
- see a clear loading state
- see a clear failure state if connection fails
- reach a post-connect catalog surface if connection succeeds

## Explicit constraints

- platform is iOS 17 and newer
- app uses SwiftUI
- project generation uses XcodeGen
- package dependency is EulerLiveKit from the configured GitHub source
- no secrets may live in the client app
- backend token handling stays outside the app boundary
- repo work must move through ACP and pull requests
- verification must pass before PR creation or merge
- user-visible changes require manual verification notes in the PR body

## Acceptance criteria

### Repo and workflow

- project.yml remains the source of truth for project generation
- scripts/verify.sh remains the canonical local verification entrypoint
- .github/workflows/ci.yml runs the same verification surface expected locally
- ACP progress and milestone files reflect actual repo state

### App shell

- the app builds on an available iOS simulator
- the initial flow supports username entry and connection attempt state
- connection state is explicit and testable
- success can route into a post-connect surface
- failure is visible to the user

### Live connection milestone

- mock or placeholder connection behavior is replaced with EulerLiveKit-backed integration
- package failures are surfaced as explicit UI errors
- no token or secret handling is embedded in the client

### Catalog milestone

- the post-connect screen can present gifts and interactions in a stable model shape
- each item can represent an icon path or icon placeholder
- each item can represent a sound description or sound mapping target
- the catalog surface is simple enough to validate with tests and simulator proof

## Non goals

- storing creator tokens or secrets inside the app
- building backend token services in this repo
- implementing final production sound playback logic during bootstrap
- shipping analytics, auth, payments, or unrelated app surfaces before the core connection and catalog flow works
- adding compatibility layers for abandoned implementation paths

## Failure conditions

- ACP progress points to the wrong milestone or task
- placeholder design docs remain in source-of-truth files
- local verification and CI verification drift apart
- the app cannot generate, build, or test from project.yml
- connection failures are hidden or ambiguous
- package integration depends on guessed APIs instead of inspected repo truth
