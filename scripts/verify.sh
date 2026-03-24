#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-all}"
PROJECT="DisturbMyLive.xcodeproj"
SCHEME="DisturbMyLive"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen is required"
  exit 1
fi

if [[ "$MODE" == "lint" || "$MODE" == "all" ]]; then
  if ! command -v swiftlint >/dev/null 2>&1; then
    echo "swiftlint is required for lint mode"
    exit 1
  fi
  swiftlint lint --strict
fi

xcodegen generate
xcodebuild -resolvePackageDependencies -project "$PROJECT" -scheme "$SCHEME"

if [[ "$MODE" == "build" || "$MODE" == "test" || "$MODE" == "all" ]]; then
  DESTINATION="$(python3 scripts/select_simulator.py)"
  echo "Using destination: $DESTINATION"
fi

if [[ "$MODE" == "build" || "$MODE" == "all" ]]; then
  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -derivedDataPath DerivedData \
    clean build
fi

if [[ "$MODE" == "test" || "$MODE" == "all" ]]; then
  xcrun simctl boot "$(echo "$DESTINATION" | sed 's/platform=iOS Simulator,id=//')" || true
  xcrun simctl bootstatus "$(echo "$DESTINATION" | sed 's/platform=iOS Simulator,id=//')" -b

  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -derivedDataPath DerivedData \
    -parallel-testing-enabled NO \
    -maximum-parallel-testing-workers 1 \
    -quiet \
    test
fi
