# DisturbMyLive Verification Strategy

## Automated verification surfaces

- SwiftLint
- Package resolution
- App build
- Unit tests
- PR body validation

## Manual verification surfaces

For every user-visible change
- launch the app
- verify the changed flow end to end
- verify the primary success path
- verify the primary failure path
- verify no obvious unrelated regression in adjacent screens

## Canonical verification commands

cd ~/Desktop/DisturbMyLive
./scripts/verify.sh lint
./scripts/verify.sh build
./scripts/verify.sh test

## Pull request verification rule

A pull request is not ready until
- automated checks are green
- manual verification is documented in the PR body
- ACP artifacts match the merged reality

## Expected validation artifacts

- passing lint check
- passing build check
- passing test check
- passing PR body check
- updated progress.yaml
- updated task file if status changed
