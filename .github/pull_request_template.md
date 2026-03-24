## What changed

Describe the actual repo surface that changed.

## Why this change exists

Describe the user-facing or system-facing reason for the change.

## Source of truth followed

List the exact files and docs used.
- AGENT.md
- agent/design/requirements.md
- agent/design/architecture.md
- agent/design/verification-strategy.md
- agent/design/repo-rules.md
- agent/design/source-of-truth-files.md

## Automated verification

List the exact commands you ran and the result.
- [ ] ./scripts/verify.sh lint
- [ ] ./scripts/verify.sh build
- [ ] ./scripts/verify.sh test

## Manual verification

Describe every manual check actually performed.
- [ ] Verified manually on simulator
- [ ] Verified connect flow
- [ ] Verified failure state
- [ ] Verified success route
- [ ] Verified no unrelated regressions

## Risks

List the real risks, if any.

## ACP updates

Confirm the ACP system was updated to match reality.
- [ ] progress.yaml updated
- [ ] task status updated
- [ ] verification docs updated if workflow changed
- [ ] source-of-truth docs updated if architecture changed
