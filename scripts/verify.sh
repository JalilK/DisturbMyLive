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
  echo "Using destination $DESTINATION"
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
  echo "Using destination $DESTINATION"
  SIM_ID="$(echo "$DESTINATION" | sed 's/platform=iOS Simulator,id=//')"
  xcrun simctl boot "$SIM_ID" || true
  xcrun simctl bootstatus "$SIM_ID" -b

  xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -derivedDataPath DerivedData \
    -parallel-testing-enabled NO \
    -maximum-parallel-testing-workers 1 \
    test
}

run_verify() {
  run_lint
  run_build
  run_test_fast
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
  verify)
    run_verify
    ;;
  all)
    run_verify
    ;;
  *)
    echo "Unknown mode $MODE"
    exit 1
    ;;
esac
