# Task 1

**Milestone**
Milestone 2

**Status**
completed

**Dependencies**
Milestone 1 complete

**Estimated Time**
45 minutes

## Objective

Wire a minimal app shell that can generate into an Xcode project and present the connect screen.

## Source of truth inputs

- agent/design/requirements.md
- agent/design/architecture.md
- project.yml

## Constraints

- must remain iOS 17
- must use SwiftUI
- must preserve package dependency

## Steps

1. Generate Xcode project
2. Build app
3. Fix project generation or compile issues
4. Confirm connect screen appears

## Verification

cd ~/Desktop/DisturbMyLive
xcodegen generate
xcodebuild -resolvePackageDependencies -project DisturbMyLive.xcodeproj -scheme DisturbMyLive
xcodebuild -project DisturbMyLive.xcodeproj -scheme DisturbMyLive -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.2' build
xcodebuild -project DisturbMyLive.xcodeproj -scheme DisturbMyLive -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.2' test

## Output

- generated Xcode project
- buildable app shell

## Completion note

Mark Milestone 2 Task 1 complete and create the next task for real connection work.
