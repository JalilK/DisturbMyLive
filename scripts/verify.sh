#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

MODE="${1:-verify}"

SIMULATOR_ID="${SIMULATOR_ID:-}"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-DerivedData}"
PROJECT_NAME="${PROJECT_NAME:-DisturbMyLive}"
SCHEME_NAME="${SCHEME_NAME:-DisturbMyLive}"

need_cmd() {
  local cmd="$1"

  if command -v "$cmd" >/dev/null 2>&1; then
    return 0
  fi

  echo "$cmd is required for $MODE mode" >&2

  if [ "${CI:-}" = "true" ]; then
    case "$cmd" in
      swiftlint)
        echo "CI bootstrap hint install SwiftLint before running ./scripts/verify.sh $MODE" >&2
        echo "Example for GitHub Actions" >&2
        echo "  - name Install SwiftLint" >&2
        echo "    run brew install swiftlint" >&2
        ;;
      xcodegen)
        echo "CI bootstrap hint install XcodeGen before running ./scripts/verify.sh $MODE" >&2
        echo "Example for GitHub Actions" >&2
        echo "  - name Install XcodeGen" >&2
        echo "    run brew install xcodegen" >&2
        ;;
      *)
        echo "CI bootstrap hint install $cmd in the workflow before running verify" >&2
        ;;
    esac
  else
    case "$cmd" in
      swiftlint)
        echo "Local bootstrap hint install SwiftLint with Homebrew" >&2
        echo "  brew install swiftlint" >&2
        ;;
      xcodegen)
        echo "Local bootstrap hint install XcodeGen with Homebrew" >&2
        echo "  brew install xcodegen" >&2
        ;;
      *)
        echo "Local bootstrap hint install $cmd and retry" >&2
        ;;
    esac
  fi

  exit 1
}

find_simulator_id() {
  xcrun simctl list devices available | awk '
    /iPhone/ && /Shutdown|Booted/ {
      if (match($0, /\(([A-F0-9-]+)\)/)) {
        print substr($0, RSTART + 1, RLENGTH - 2)
        exit
      }
    }
  '
}

resolve_destination() {
  local id="${SIMULATOR_ID}"

  if [ -z "$id" ]; then
    id="$(find_simulator_id)"
  fi

  if [ -z "$id" ]; then
    echo "Could not find an available iPhone simulator" >&2
    xcrun simctl list devices available >&2
    exit 1
  fi

  echo "platform=iOS Simulator,id=${id}"
}

run_lint() {
  need_cmd swiftlint
  echo "Linting Swift files in current working directory"
  swiftlint lint --strict
}

run_build() {
  local destination

  need_cmd xcodegen

  destination="$(resolve_destination)"
  echo "Using destination ${destination}"

  xcodegen generate
  xcodebuild -resolvePackageDependencies -project "${PROJECT_NAME}.xcodeproj" -scheme "${SCHEME_NAME}"
  xcodebuild \
    -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "${SCHEME_NAME}" \
    -destination "${destination}" \
    -derivedDataPath "${DERIVED_DATA_PATH}" \
    clean build
}

run_test() {
  local destination

  need_cmd xcodegen

  destination="$(resolve_destination)"
  echo "Using destination ${destination}"

  xcodegen generate
  xcodebuild -resolvePackageDependencies -project "${PROJECT_NAME}.xcodeproj" -scheme "${SCHEME_NAME}"
  xcodebuild \
    -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "${SCHEME_NAME}" \
    -destination "${destination}" \
    -derivedDataPath "${DERIVED_DATA_PATH}" \
    test
}

run_verify() {
  run_lint
  run_build
  run_test
}

case "$MODE" in
  lint)
    run_lint
    ;;
  build)
    run_build
    ;;
  test)
    run_test
    ;;
  verify)
    run_verify
    ;;
  *)
    echo "Unknown mode ${MODE}"
    exit 1
    ;;
esac
