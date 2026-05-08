# Orchestrator Workflow Setup Guide

## Step 1 — CLAUDE.md

```bash
# Global
cp global-CLAUDE.md ~/.claude/CLAUDE.md

# Project
cp project-CLAUDE.md ~/Projects/<org>/<project>/CLAUDE.md
```

## Step 2 — Scripts

```bash
mkdir -p ~/.claude/scripts
# Create the 4 script files from the Scripts Reference section in project-CLAUDE.md
chmod +x ~/.claude/scripts/*.sh
```

## Step 3 — settings.json

Add to `~/.claude/settings.json`:

```json
"skillListingBudgetFraction": 0.03
```

Replace the entire `hooks` section with the hooks block from `project-CLAUDE.md`.

## Step 4 — Mempalace per-project

### Fix conflicts (if any)

```bash
claude mcp list                         # check if mempalace is failing
claude mcp remove mempalace -s user     # remove global if conflicting
claude mcp remove mempalace -s local    # remove old local if conflicting
```

### Setup palace for a project

```bash
# Init palace (run inside project directory)
cd ~/Projects/<org>/<project>
mempalace --palace ~/.mempalace/<project> init .

# Add MCP at local scope for this project
claude mcp add mempalace -s local -- mempalace-mcp --palace ~/.mempalace/<project>

# Verify
claude mcp list    # should show mempalace ✓ Connected
mempalace --palace ~/.mempalace/<project> status
```

### For each new project (template)

```bash
cd ~/Projects/<org>/<project>
mempalace --palace ~/.mempalace/<project> init .
claude mcp add mempalace -s local -- mempalace-mcp --palace ~/.mempalace/<project>
```

## Step 5 — PRIME.md

```bash
touch ~/Projects/<org>/<project>/.beads/PRIME.md
```

## Step 6 — Verify everything

```bash
claude mcp list                        # mempalace connected
~/.claude/scripts/session-start.sh    # runs without errors
bd status                              # beads working
```

---

## Daily Usage

**Start session:** Paste your issue/ticket into Claude. The `SessionStart` hook runs automatically — nothing else needed.

**Small task:** Same as current workflow. Claude scores and ships directly.

**Medium/large task:** Claude decomposes → spawns agents → checkpoints after each cycle. You only need to approve/reject when asked.

**End session:**

```bash
~/.claude/scripts/session-end.sh
```

**Context overflow:** Type `/clear` — Claude reloads from the last checkpoint automatically.

**Broken session:** Re-run `~/.claude/scripts/session-start.sh`.

---

## Troubleshooting

**mempalace failing to connect:**

```bash
mempalace-mcp --help    # confirm binary exists
claude mcp remove mempalace -s local
claude mcp add mempalace -s local -- mempalace-mcp --palace ~/.mempalace/<project>
```

**mempalace status shows "No palace found":**

```bash
mempalace --palace ~/.mempalace/<project> init .
```

**Scripts not executable:**

```bash
chmod +x ~/.claude/scripts/*.sh
which bd && which bv    # confirm tools are installed
```

**bd kv empty after /clear:**

```bash
bd kv list    # check for checkpoint:* keys
# If empty → paste a new ticket, Claude will create tasks from scratch
```

**Skills being dropped:**

```bash
# Add to ~/.claude/settings.json
"skillListingBudgetFraction": 0.03
```
