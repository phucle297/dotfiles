# Project Orchestrator Rules

## Session Start

`~/.claude/scripts/session-start.sh`

## Task Management (AI only)

- Score first: `~/.claude/scripts/score-task.sh <bd-id>`
- Claim: `bd update <id> --claim --json`
- Pin to agent: `bd pin <id> --for agent-N --start`
- Reserve files: `bd reserve <file> --for agent-N`
- Close: `bd close <id> --json` (checkpoint-write.sh runs after)
- Re-queue: `bd reopen <id>` → `bd pin <id> --for agent-N`
- Never TodoWrite — bd only

## Agent Communication

- Assign: `bd pin <id> --for agent-N`
- Signal done: `bd mail send orchestrator "done:<id>"`
- Orchestrator reads: `bd mail inbox`
- Conflict guard: `bd reserve <file>` before any multi-agent work

## Large Task Gate

Before any task touching >5 files:

1. `score-task.sh <id>` → must output LARGE
2. Create bd epic → phase subtasks
3. Phase 0 commit required before Phase 1

## Session End

`~/.claude/scripts/session-end.sh`
