#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-all}"
PROJECT="DisturbMyLive.xcodeproj"
SCHEME="DisturbMyLive"

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen is required"
  exit 1
fi

run_lint() {
  if ! command -v swiftlint >/dev/null 2>&1; then
    echo "swiftlint is required for lint mode"
    exit 1
  fi
  swiftlint lint --strict
}

run_build() {
  xcodegen generate
  xcodebuild -resolvePackageDependencies -project "$PROJECT" -scheme "$SCHEME"
  DESTINATION="$(python3 scripts/select_simulator.py)"
  echo "Using destination: $DESTINATION"
  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -derivedDataPath DerivedData \
    clean build
}

run_test_fast() {
  xcodegen generate
  xcodebuild -resolvePackageDependencies -project "$PROJECT" -scheme "$SCHEME"
  DESTINATION="$(python3 scripts/select_simulator.py)"
  echo "Using destination: $DESTINATION"
  xcrun simctl boot "$(echo "$DESTINATION" | sed 's/platform=iOS Simulator,id=//')" || true
  xcrun simctl bootstatus "$(echo "$DESTINATION" | sed 's/platform=iOS Simulator,id=//')" -b

  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -derivedDataPath DerivedData \
    -parallel-testing-enabled NO \
    -maximum-parallel-testing-workers 1 \
    test
}

case "$MODE" in
  lint)
    run_lint
    ;;
  build)
    run_build
    ;;
  test-fast)
    run_test_fast
    ;;
  all)
    run_lint
    run_build
    run_test_fast
    ;;
  *)
    echo "Unknown mode: $MODE"
    exit 1
    ;;
esac
