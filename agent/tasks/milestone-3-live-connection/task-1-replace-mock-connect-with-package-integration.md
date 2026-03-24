# Task 1

**Milestone**
Milestone 3

**Status**
pending

**Dependencies**
Milestone 2 complete

**Estimated Time**
90 minutes

## Objective

Replace the temporary connection simulation with real SwiftUIEulerLiveKit backed connection logic.

## Source of truth inputs

- agent/design/requirements.md
- agent/design/architecture.md
- agent/design/source-of-truth-files.md
- external package source

## Constraints

- no secrets in app
- backend token boundary must remain external
- failure must map to visible UI state

## Steps

1. Inspect package APIs
2. Build app side connection service
3. Surface package errors as explicit app states
4. Route success to catalog screen

## Verification

To be finalized after package API inspection.

## Output

- real connection service
- updated view model
- UI error handling

## Completion note

Update progress.yaml with package integration status and blockers if token endpoint is required.
