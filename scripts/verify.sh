#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-}"

need_cmd() {
  local cmd="$1"
  local hint="$2"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd is required for ${MODE} mode"
    echo "$hint"
    exit 1
  fi
}

pick_simulator_id() {
  python3 - <<'PY'
import json
import subprocess
import sys

preferred_names = [
    "iPhone 17 Pro",
    "iPhone 17",
    "iPhone 16 Pro",
    "iPhone 16",
    "iPhone 16e",
    "iPhone 15 Pro",
    "iPhone 15",
    "iPhone SE (3rd generation)",
]

output = subprocess.check_output(
    ["xcrun", "simctl", "list", "devices", "available", "-j"],
    text=True,
)

data = json.loads(output)
devices = []

for runtime, entries in data.get("devices", {}).items():
    for entry in entries:
        if not entry.get("isAvailable", False):
            continue
        devices.append({
            "name": entry["name"],
            "udid": entry["udid"],
            "runtime": runtime
        })

def runtime_rank(runtime):
    normalized = runtime.replace("com.apple.CoreSimulator.SimRuntime.", "")
    parts = normalized.replace("-", ".").split(".")
    nums = [int(p) for p in parts if p.isdigit()]
    major = nums[0] if len(nums) > 0 else 0
    minor = nums[1] if len(nums) > 1 else 0
    return (major, minor)

for preferred in preferred_names:
    matches = [d for d in devices if d["name"] == preferred]
    if matches:
        matches.sort(key=lambda d: runtime_rank(d["runtime"]), reverse=True)
        print(matches[0]["udid"])
        sys.exit(0)

iphone_matches = [d for d in devices if d["name"].startswith("iPhone")]
if iphone_matches:
    iphone_matches.sort(key=lambda d: runtime_rank(d["runtime"]), reverse=True)
    print(iphone_matches[0]["udid"])
    sys.exit(0)

sys.exit("No simulator found")
PY
}

run_lint() {
  need_cmd swiftlint "brew install swiftlint"
  swiftlint lint --strict
}

run_generate() {
  need_cmd xcodegen "brew install xcodegen"
  xcodegen generate
}

run_resolve() {
  xcodebuild -resolvePackageDependencies -project DisturbMyLive.xcodeproj -scheme DisturbMyLive
}

run_build() {
  local simulator_id="$1"
  xcodebuild \
    -project DisturbMyLive.xcodeproj \
    -scheme DisturbMyLive \
    -destination "platform=iOS Simulator,id=${simulator_id}" \
    -derivedDataPath DerivedData \
    build
}

run_test() {
  local simulator_id="$1"
  rm -rf DerivedData
  xcrun simctl shutdown all || true
  xcrun simctl boot "${simulator_id}" || true

  xcodebuild \
    -project DisturbMyLive.xcodeproj \
    -scheme DisturbMyLive \
    -destination "platform=iOS Simulator,id=${simulator_id}" \
    -derivedDataPath DerivedData \
    clean test
}

run_verify_pr() {
  local simulator_id
  simulator_id="$(pick_simulator_id)"
  echo "Using simulator ${simulator_id}"

  run_lint
  run_generate
  run_resolve
  run_build "${simulator_id}"
  run_test "${simulator_id}"
}

run_verify_full() {
  local simulator_id
  simulator_id="$(pick_simulator_id)"
  echo "Using simulator ${simulator_id}"

  run_lint
  run_generate
  run_resolve
  run_test "${simulator_id}"
}

case "$MODE" in
  verify-pr)
    run_verify_pr
    ;;
  verify)
    run_verify_full
    ;;
  *)
    echo "Usage ./scripts/verify.sh [verify-pr|verify]"
    exit 1
    ;;
esac
