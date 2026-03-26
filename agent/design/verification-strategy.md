# Verification Strategy

## Verification model

This repo uses one canonical local verification entrypoint and one matching CI lane.

The canonical local command is

- `./scripts/verify.sh verify`

The canonical ACP wrapper is

- `./scripts/acp/acp.sh verify`

CI should run the same verification surface.

## Fresh session recovery

Use these commands at the start of a fresh session

- `./scripts/acp/update.sh`
- `rm -rf scripts/acp/__pycache__`
- `./scripts/acp/acp.sh doctor`
- `./scripts/acp/acp.sh status`
- `./scripts/acp/acp.sh next`
- `./scripts/acp/acp.sh context export init`

## Local verification surface

The verify command currently covers

- swiftlint strict linting
- XcodeGen project generation
- Swift package dependency resolution
- simulator-based test execution

The verification script selects an available iPhone simulator dynamically.

## CI verification surface

CI must

- check out the repo
- install required tools such as xcodegen and swiftlint
- run `./scripts/verify.sh verify`

A passing pull request proves the merge gate surface is healthy.

## Manual verification rule

For every user-visible change, the PR body must document the manual verification performed.

Examples include

- app launch proof
- connect flow proof
- visible error proof
- success navigation proof
- catalog rendering proof

## Command-first rule

Use ACP and verification commands instead of ad hoc shell for recurring repo workflows.

## Failure policy

A task is not complete when any of the following is true

- local verification fails
- CI verification fails
- PR body is incomplete
- manual verification for user-visible changes is missing
- ACP progress does not match repo reality
