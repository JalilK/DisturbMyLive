# DisturbMyLive Verification Strategy

## Verification model

This repo uses two verification lanes.

Fast lane runs on every pull request and is the merge gate.

Deep lane runs on demand and on schedule for slower system validation.

## Fast lane

Fast lane is required before merge.

It includes

- SwiftLint
- package resolution
- app build
- fast automated tests
- PR body validation

## Deep lane

Deep lane is required for higher risk validation and release confidence.

It includes

- full system validation workflow
- hosted simulator validation
- slower end to end style checks
- broader regression checks when needed

## Manual verification rule

For every user-visible change, the PR must document manual verification.

Minimum manual surface

- primary success path
- primary failure path
- adjacent regression check

## Canonical local commands

cd ~/Desktop/DisturbMyLive
./scripts/verify.sh lint
./scripts/verify.sh build
./scripts/verify.sh test-fast

## Fast lane CI checks

- verify
- pr-body

## Deep lane CI check

- system-validation

## Pull request readiness rule

A PR is merge-ready only when

- fast lane checks are green
- manual verification is documented
- ACP artifacts match implementation reality

## Expected validation artifacts

- passing verify check
- passing pr-body check
- updated progress.yaml
- updated task state
- optional passing system-validation run when required by risk level
