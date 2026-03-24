# DisturbMyLive Command Surface

This repo uses ACP style command intent.

## Required execution loop

1. Read agent/progress.yaml
2. Read current task
3. Read all indexed files whose applies surface matches the current command
4. Execute bounded work only
5. Run verification
6. Update ACP artifacts

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

- run verification strategy commands and report failures exactly
