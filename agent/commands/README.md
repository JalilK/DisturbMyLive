# DisturbMyLive Command Surface

This repo uses ACP style command intent.

## Required execution loop

1. Read agent/progress.yaml
2. Read current task
3. Read all indexed files whose applies surface matches the current command
4. Execute bounded work only
5. Run verification
6. Update ACP artifacts
7. Prepare pull request artifacts when the feature is complete

## Command meanings

@acp.init

- read AGENT.md
- read local.main.yaml
- load highest priority indexed files
- confirm current task from progress.yaml

@acp.status

- report milestone and task strictly from progress.yaml

@acp.proceed

- execute the current task only
- do not skip verification
- update progress on completion

@acp.validate

- run ./scripts/verify.sh lint
- run ./scripts/verify.sh build
- run ./scripts/verify.sh test

@acp.pr.prepare

- generate a completed PR body from ACP artifacts
- include exact source-of-truth files followed
- include exact automated verification performed
- include exact manual verification performed
- do not mark a PR ready until ACP state matches reality
