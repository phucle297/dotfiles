#!/bin/bash
CURRENT=$(bd kv get checkpoint:current 2>/dev/null)
[ -n "$CURRENT" ] && ~/.claude/scripts/checkpoint-write.sh $CURRENT
bd prime
