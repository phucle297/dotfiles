#!/bin/bash
# jira-to-bd.sh <JIRA-KEY> [parent-bd-id]
# Finds or creates a bead for a Jira issue.
# Output: bd-id only (for scripting)
#
# Examples:
#   BD_ID=$(~/.claude/scripts/jira-to-bd.sh WLB-2046)
#   BD_ID=$(~/.claude/scripts/jira-to-bd.sh WLB-2046 gigsberg-wlb-7zu)

set -euo pipefail

JIRA_KEY="${1:-}"
PARENT_ID="${2:-}"

if [ -z "$JIRA_KEY" ]; then
  echo "Usage: jira-to-bd.sh <JIRA-KEY> [parent-bd-id]" >&2
  exit 1
fi

JIRA_KEY=$(echo "$JIRA_KEY" | tr '[:lower:]' '[:upper:]')

# 1. Search by external-ref
EXISTING=$(bd list --json 2>/dev/null |
  jq -r --arg key "$JIRA_KEY" \
    '.[] | select((.external_ref // "") | ascii_downcase == ($key | ascii_downcase)) | .id' |
  head -1)

if [ -n "$EXISTING" ]; then
  echo "$EXISTING"
  exit 0
fi

# 2. Fallback: search by title containing Jira key
EXISTING=$(bd list --json 2>/dev/null |
  jq -r --arg key "$JIRA_KEY" \
    '.[] | select(.title | test($key; "i")) | .id' |
  head -1)

if [ -n "$EXISTING" ]; then
  echo "$EXISTING"
  exit 0
fi

# 3. Not found — create
DATE_PREFIX=$(date +%Y-%m-%d)
TITLE="$DATE_PREFIX [$JIRA_KEY]"

CREATE_ARGS=(
  --title "$TITLE"
  --external-ref "$JIRA_KEY"
  --silent
)

if [ -n "$PARENT_ID" ]; then
  CREATE_ARGS+=(--parent "$PARENT_ID")
fi

NEW_ID=$(bd create "${CREATE_ARGS[@]}" 2>/dev/null)

if [ -z "$NEW_ID" ]; then
  echo "ERROR: bd create failed for $JIRA_KEY" >&2
  exit 1
fi

echo "$NEW_ID"
