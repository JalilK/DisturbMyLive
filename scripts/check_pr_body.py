#!/usr/bin/env python3
import os
import sys

body = os.environ.get("PR_BODY", "")

required_sections = [
    "## What changed",
    "## Why this change exists",
    "## Source of truth followed",
    "## Automated verification",
    "## Manual verification",
    "## Risks",
    "## ACP updates",
]

missing = [section for section in required_sections if section not in body]

if missing:
    print("Missing required PR sections")
    for section in missing:
        print(section)
    sys.exit(1)

manual_markers = [
    "- [x]",
    "Verified manually",
    "Manual verification completed",
]

if not any(marker in body for marker in manual_markers):
    print("PR body must contain documented manual verification evidence")
    sys.exit(1)

print("PR body validation passed")
