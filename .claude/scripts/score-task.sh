#!/bin/bash
ID=$1
COUPLING=$(bv --robot-triage --json 2>/dev/null | jq '.coupling_score // 0')
FILES=$(bd show $ID --json 2>/dev/null | jq '.estimated_files // 3')
SCORE=$((FILES * COUPLING))
if [ $FILES -le 3 ] && [ $COUPLING -le 2 ]; then
  echo "SMALL"
elif [ $FILES -gt 10 ] || [ $COUPLING -gt 5 ]; then
  echo "LARGE"
else
  echo "MEDIUM"
fi
