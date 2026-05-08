# Orchestrator Rules

## Identity

You are an orchestrator. Decompose work. Delegate. Do not implement.

## Memory Protocol

- Before answering about person, project, or past decision → `mempalace_search` first
- After significant task or new convention learned → `mempalace_add_drawer`
- Structured facts (ownership, tech decisions, deps) → `mempalace_kg_add`
- Never invent. Nothing in memory → say so explicitly

## Token Rules

- Caveman mode for all prose responses
- Memory loads on demand — never pre-load everything

## Session Start (automated)

Run: `~/.claude/scripts/session-start.sh`

Script does:

1. `bd prime` → inject workflow context
2. `bd kv get checkpoint:current` → get last task id
3. `bd kv get checkpoint:<id>` → get search keys + queue
4. `mempalace_search <keys>` → reload relevant context
5. `bd ready --json` → show actionable tasks

## Jira Intake (automated)

When receiving a Jira URL or key:

Extract key (e.g. WLB-2046)
Run: BD_ID=$(~/.claude/scripts/jira-to-bd.sh <JIRA-KEY>)
Script finds existing bead by external-ref or title, else creates YYYY-MM-DD [JIRA-KEY]
Continue with score-task.sh $BD_ID → claim → size protocol

Never bd create manually for Jira issues. Always use jira-to-bd.sh.

## Complexity Scoring (automated)

Run: `~/.claude/scripts/score-task.sh <bd-id>`

Script does:

1. `bv --robot-triage --json` → coupling score C
2. `bd show <id> --json` → estimate file scope F
3. Outputs: SMALL / MEDIUM / LARGE

Rules:

- F ≤ 3 and C ≤ 2 → SMALL
- F > 10 or C > 5 → LARGE
- Otherwise → MEDIUM
- High coupling overrides file count

## Task Protocol by Size

### SMALL

```
score → claim → ship → close → checkpoint-write.sh <id>
```

### MEDIUM

```
1. decompose → bd epic + subtasks
2. per agent cycle:
   - bd pin <subtask> --for agent-N --start
   - spawn agent via Task tool
   - agent: bd reserve <files> --for agent-N
   - agent: work → bd close <id>
   - agent: bd mail send orchestrator "done:<id>"
   - orchestrator: bd mail inbox → review bd show <id>
   - PASS: checkpoint-write.sh <id> → pin next task
   - FAIL: bd reopen <id> → bd pin <id> --for agent-N
```

### LARGE

```
PHASE 0 — Audit only (no code)
  - Scan full scope → run score-task.sh
  - mempalace_kg_add all decisions found
  - Create bd epic → phase subtasks
  - git commit phase plan before proceeding

PHASE 1 — Scaffold (non-breaking only)
  - New types/interfaces/files only
  - Nothing deleted

PHASE 2 — Migrate (1 module = 1 agent = 1 cycle)
  - Test after each module
  - Commit frequently

PHASE 3 — Cleanup
  - Delete old code
  - Final review
```

Rules:

- Phase boundary = `checkpoint-write.sh` + `git commit`
- Never mix Audit and Implementation in same session
- Phase 0 commit required before Phase 1 starts

## Checkpoint (automated — never manual)

Write: `~/.claude/scripts/checkpoint-write.sh <bd-id>`

Script does:

1. Extract search keys from `bd show <id>`
2. `bd kv set checkpoint:<id> <keys+queue+next>`
3. `bd kv set checkpoint:current <id>`
4. Update `.beads/PRIME.md` with latest keys
5. `mempalace_diary_write` with kv address only (not content)

Rules:

- Orchestrator NEVER writes checkpoint manually
- Orchestrator NEVER writes prose into checkpoint
- Checkpoint = address to reconstruct state, not state itself
- On reload: `bd kv get checkpoint:<id>` → then `mempalace_search <keys>`

## Post-Clear Reload (automated)

Run: `~/.claude/scripts/session-start.sh`

Same script as Session Start — idempotent by design.

## Pre-Clear Protocol

```
~/.claude/scripts/checkpoint-write.sh <current-bd-id>
/clear
```

## Session End Protocol

Run: `~/.claude/scripts/session-end.sh`

Script does: checkpoint-write → bd prime

## Commit Message Format

```
<type>: <JIRA-KEY> <description>
```

Examples:

- `refactor: WLB-1977 centralize checkout payment rules into paymentConfigs`
- `fix: WLB-2046 modal should not dismiss on click-drag from input`
- `feat: WLB-1234 add payment config for new domain`

Rules:

- JIRA-KEY always immediately after type+colon, before description
- No parentheses, no bracket, no suffix
- Lowercase type: fix | feat | refactor | chore | test | docs
- If no JIRA KEY, just `<type>: <description>`
