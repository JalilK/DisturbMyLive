#!/usr/bin/env python3
import json
import subprocess
import sys

result = subprocess.run(
    ["xcrun", "simctl", "list", "devices", "available", "-j"],
    capture_output=True,
    text=True,
    check=True,
)

payload = json.loads(result.stdout)
devices = payload.get("devices", {})

preferred_names = [
    "iPhone 17 Pro",
    "iPhone 17",
    "iPhone 16e",
    "iPhone 15 Pro",
    "iPhone 15",
    "iPhone SE (3rd generation)",
]

candidates = []
for runtime, runtime_devices in devices.items():
    for device in runtime_devices:
        if not device.get("isAvailable", False):
            continue
        name = device.get("name", "")
        udid = device.get("udid", "")
        if "iPhone" not in name:
            continue
        candidates.append((name, udid, runtime))

for preferred in preferred_names:
    for name, udid, runtime in candidates:
        if name == preferred:
            print(f"platform=iOS Simulator,id={udid}")
            sys.exit(0)

if candidates:
    name, udid, runtime = candidates[0]
    print(f"platform=iOS Simulator,id={udid}")
    sys.exit(0)

print("No available iPhone simulator found.", file=sys.stderr)
sys.exit(1)
