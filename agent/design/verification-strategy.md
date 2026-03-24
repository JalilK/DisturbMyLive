# DisturbMyLive Verification Strategy

## Compile checks

- xcodegen generate
- xcodebuild resolve package dependencies
- xcodebuild build for simulator

## Unit checks

- xcodebuild test for DisturbMyLiveTests

## File contract checks

- ACP structure exists
- required design files exist
- index file exists
- progress.yaml exists

## Proof commands

cd ~/Desktop/DisturbMyLive
xcodegen generate
xcodebuild -resolvePackageDependencies -project DisturbMyLive.xcodeproj -scheme DisturbMyLive
xcodebuild -project DisturbMyLive.xcodeproj -scheme DisturbMyLive -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.2' build
xcodebuild -project DisturbMyLive.xcodeproj -scheme DisturbMyLive -destination 'platform=iOS Simulator,name=iPhone 15,OS=17.2' test

## Expected validation artifacts

- Generated Xcode project
- Successful package resolution
- Successful simulator build
- Successful test run
- Updated progress.yaml reflecting actual status
