# DisturbMyLive Agent Operating Law

This repo uses ACP as a repo level operating system for AI assisted coding.

The agent must treat ACP artifacts as first class source of truth.
The agent must not begin implementation before design and verification surfaces exist.
The agent must not guess repo facts when repo files can answer them.
The agent must verify work before handoff.
The agent must update ACP artifacts after meaningful progress.

## Project summary

DisturbMyLive is an iOS app that connects to TikTok LIVE streams through SwiftUIEulerLiveKit.
The user enters a TikTok username.
The app attempts to connect.
The app shows an error when connection fails.
On success the app routes to a screen that lists official TikTok gift icons and interaction entries with the sound each trigger maps to.

## Delivery law

- Prefer full file replacements
- Prefer full repo replacements when structure changes broadly
- No placeholder commands
- No unverified handoff
- No dead code paths without reason
- Repo rules outrank chat memory
