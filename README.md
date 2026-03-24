# DisturbMyLive

DisturbMyLive is a native iOS app that connects to a TikTok LIVE stream through SwiftUIEulerLiveKit.

The user enters a TikTok username.
The app attempts a connection.
If the connection fails, the app shows a clear error.
If the connection succeeds, the app navigates to a screen showing TikTok gifts and interactions with the sound each one should trigger.

## Current scope

This repo starts with

- local repo bootstrap
- ACP operating system files
- minimal iOS app shell
- package hookup to SwiftUIEulerLiveKit
- project specific task and milestone structure

## Core rules

- no secrets in the app
- backend token flow stays outside the client
- ACP files are first class source of truth
- verification is required before handoff
