# Architecture

## System boundaries

DisturbMyLive is an iOS SwiftUI client application.

## Major layers

- App
- Features
- Core
- Tests
- ACP repo operating layer

## Integration points

- EulerLiveKit package
- local token service during development
- GitHub CI and PR enforcement

## State ownership

- app runtime state belongs in app code
- repo workflow state belongs in ACP artifacts
- merge and review policy belongs in GitHub and repo policy files

## Error boundaries

- connection and backend failures must surface as user-visible failure state
- repo workflow failures must surface through verify and PR gates
