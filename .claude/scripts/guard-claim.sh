#!/bin/bash
CLAIMED=$(bd list --claimed --mine --json 2>/dev/null | jq length)
if [ "$CLAIMED" -eq 0 ]; then
  echo "ERROR: No task claimed. Run score-task.sh + bd update --claim before editing files." >&2
  exit 1
fi
exit 0
