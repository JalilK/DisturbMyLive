# DisturbMyLive Repo Rules

## Exact repo folder name

DisturbMyLive

## Default local path

~/Desktop/DisturbMyLive

## Branch and merge law

- No direct pushes to main
- All code reaches main through pull requests only
- Main must be protected
- Required status checks must pass before merge
- At least one approving review is required before merge
- Code owner review is required before merge
- Dismiss stale approvals when new commits are pushed
- Require approval of the most recent push before merge
- Require conversation resolution before merge
- Apply protection to administrators
- Prefer squash merge only

## Required status checks

- lint
- build
- test
- pr-body

## Pull request law

- Every feature branch must open a pull request
- The pull request body must be created from the repository template
- The assistant must fill the pull request body for every feature we build
- The PR body must document exact source-of-truth files followed
- The PR body must document exact automated verification run
- The PR body must document exact manual verification performed
- A PR without completed verification sections is not merge-ready

## Verification law

- Any code merged into main must be verified automatically
- Any user-visible change must also be verified manually
- If automated verification is missing, the work is incomplete
- If manual verification is missing for a user-visible change, the work is incomplete

## Handoff rules

- No partial snippet handoff for multi-file repo changes
- No placeholder shell commands
- No unverified delivery
- No guessed APIs when package or repo docs can answer
- Full replacement files preferred
- Terminal code must never include markdown fences or formatting syntax
- All commands must be directly executable with no cleanup required

## Operational truth rule

One active architecture path only.
Dead compatibility layers should not remain without explicit need.
