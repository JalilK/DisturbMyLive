# Milestone 3

## Goal

Integrate SwiftUIEulerLiveKit for real stream connection attempts.

## Scope boundary

Replace mock connect behavior with real package backed connect logic and failure handling.

## Deliverables

- package based connection service
- surfaced error states
- connection success path

## Success criteria

- connection attempt uses package integration
- failures map to visible UI state
- success triggers route into catalog screen

## Required verification surface

- build
- tests
- manual simulator proof

## Blockers

- unknown package API gaps
- token service dependency

## Exit condition

Real connection behavior exists behind app UI.
