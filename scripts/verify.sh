#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"
SIMULATOR_ID="2A706B68-0FFD-4C46-816F-2482EEB01E45"

need_cmd() {
  local cmd="$1"
  local hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd is required for ${MODE} mode"
    echo "$hint"
    exit 1
  fi
}

run_lint() {
  need_cmd swiftlint "CI bootstrap hint install SwiftLint before running ./scripts/verify.sh ${MODE}
Example for GitHub Actions
  - name: Install SwiftLint
    run: brew install swiftlint"
  swiftlint lint --strict
}

run_generate() {
  need_cmd xcodegen "CI bootstrap hint install XcodeGen before running ./scripts/verify.sh ${MODE}
Example for GitHub Actions
  - name: Install XcodeGen
    run: brew install xcodegen"
  xcodegen generate
}

run_resolve() {
  xcodebuild -resolvePackageDependencies -project DisturbMyLive.xcodeproj -scheme DisturbMyLive
}

run_build() {
  xcodebuild \
    -project DisturbMyLive.xcodeproj \
    -scheme DisturbMyLive \
    -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" \
    -derivedDataPath DerivedData \
    build
}

run_clean_test() {
  rm -rf DerivedData
  xcrun simctl shutdown all || true
  xcrun simctl boot "${SIMULATOR_ID}" || true
  xcodebuild \
    -project DisturbMyLive.xcodeproj \
    -scheme DisturbMyLive \
    -destination "platform=iOS Simulator,id=${SIMULATOR_ID}" \
    -derivedDataPath DerivedData \
    clean test
}

run_pr_verify() {
  run_lint
  run_generate
  run_resolve
  run_build
  run_clean_test
}

run_full_verify() {
  run_lint
  run_generate
  run_resolve
  run_clean_test
}

case "$MODE" in
  verify-pr)
    run_pr_verify
    ;;
  verify)
    run_full_verify
    ;;
  *)
    echo "Usage: ./scripts/verify.sh [verify-pr|verify]"
    exit 1
    ;;
esac
