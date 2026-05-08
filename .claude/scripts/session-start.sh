#!/bin/bash
# Load last checkpoint and reload context
LAST_ID=$(bd kv get checkpoint:current 2>/dev/null)
if [ -n "$LAST_ID" ]; then
  CHECKPOINT=$(bd kv get checkpoint:$LAST_ID 2>/dev/null)
  echo "=== CHECKPOINT ==="
  echo "$CHECKPOINT"
  echo "=================="
fi
bd prime
bd ready --json
