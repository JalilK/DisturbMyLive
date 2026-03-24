# Requirements

## Project goal

Build an iOS app called DisturbMyLive that connects to TikTok LIVE event streams through EulerLiveKit-backed infrastructure and maps gifts or interactions to user-visible sound-trigger behavior.

## User visible outcome

The user can enter a TikTok LIVE username, attempt connection, see failure if connection does not succeed, and navigate to a gift and interaction catalog view after successful connection.

## Explicit constraints

- iOS 17 target
- SwiftUI app
- XcodeGen project
- SwiftLint enforced
- ACP-driven repo workflow
- PR-gated main branch
- fast-lane CI required before merge

## Acceptance criteria

- local ./scripts/verify.sh verify passes
- CI verify and pr-body pass
- ACP progress is recoverable by a fresh session
- command-first repo workflow is active

## Non goals

- raw TikTok integration outside the Euler-backed flow
- ad hoc untracked repo workflow

## Failure conditions

- code enters main without PR and verification
- ACP state drifts from repo reality
- command-first workflow is ignored for recurring repo operations
