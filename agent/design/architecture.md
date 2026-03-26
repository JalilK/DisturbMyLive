# Architecture

## System boundaries

DisturbMyLive is a native iOS client.

Its responsibility is to

- collect a TikTok LIVE username
- trigger a live connection attempt through app-side services
- present connection state to the user
- route into a post-connect catalog surface
- show gift and interaction metadata relevant to sound triggering

It must not

- own backend token issuance
- store secrets
- invent package APIs that have not been verified against source

## Module boundaries

### App

App-level entrypoint, app bootstrapping, app-wide routing, and theme wiring.

Current repo folders include

- App
- App/Features
- App/Theme

### Core

Shared models and services that should not depend on feature view details.

Current repo folders include

- Core/Models
- Core/Services

### Features

User-visible product surfaces.

Current repo folders include

- Features/Connect
- Features/GiftCatalog

### Tests

Unit tests for app behavior and stable model logic.

Current repo folder

- Tests/DisturbMyLiveTests

## Integration points

### Project generation

- project.yml is the project-generation source of truth
- XcodeGen generates DisturbMyLive.xcodeproj
- App/Info.plist is repo-owned and preserved through ACP overlay updates

### Package integration

- EulerLiveKit is pulled from the configured Swift package source in project.yml
- package inspection must drive implementation decisions for live connection work
- app-side wrappers may adapt package types into repo-owned view state

### ACP integration

- ACP status, progress, milestones, tasks, and indexed design docs govern workflow execution
- recurring repo workflows should use ./scripts/acp/acp.sh where possible

## State ownership

### View state

Feature-specific view models own transient UI state such as

- username input
- idle state
- connecting state
- connected state
- error state

### Domain state

Core-owned models should represent stable shapes such as

- connection request input
- connection result mapping
- catalog item model
- gift or interaction metadata

### Workflow state

ACP owns planning and execution state through

- agent/progress.yaml
- milestone files
- task files

## Error boundaries

### Connection errors

Errors from EulerLiveKit or app-side connection services must map into explicit UI-visible error states.

### Verification errors

Verification failures must stop PR readiness and merge readiness.

### Repo workflow errors

If ACP state and repo reality diverge, ACP files must be updated before feature work proceeds.

## Naming conventions

- user-visible features live under Features with human-readable names
- reusable app logic lives under Core
- route and state names should describe user intent and screen truth
- one operational path per feature area
- remove dead mocks and stale compatibility paths once the real path is in place unless a source-of-truth file explicitly requires otherwise

## Current operational flow

1. User launches app
2. User enters TikTok username
3. App attempts connection
4. UI shows connecting, success, or failure
5. Success routes into gift and interaction catalog
6. Catalog prepares the surface for icon and sound mapping behavior
