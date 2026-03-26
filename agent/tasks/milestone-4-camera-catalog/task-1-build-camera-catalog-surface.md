# Task: Build Camera-Based Catalog Surface

## Objective

Replace static catalog UI with full-screen front camera feed that becomes the primary user-facing surface.

## Why

The product is not a list UI. The product is the live experience. The camera feed is the canvas where all interactions become visible and meaningful.

## Requirements

- Full-screen front camera preview
- No UIKit leakage into higher-level views
- Deterministic lifecycle (start/stop session)
- Works on physical device
- No overlays in v1

## Acceptance Criteria

- Camera feed fills entire screen
- No black bars or safe-area issues
- Session starts on appear and stops on disappear
- App does not crash if permission denied

## Validation

- Build passes via ./scripts/verify.sh verify
- Manual test on device confirms camera feed renders full screen

