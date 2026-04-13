#!/bin/bash
# Output pane label: ~/path ‹branch*› or just ~/path
# Usage: pane-label.sh /full/path
DIR="$1"
[ -z "$DIR" ] && exit 0

# Shorten to last two path components
LABEL=$(echo "$DIR" | awk -F'/' '{if(NF>=2) print $(NF-1)"/"$NF; else print $NF}')

# Git branch + dirty
if branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$DIR" rev-parse --abbrev-ref HEAD 2>/dev/null); then
  dirty=""
  if ! GIT_OPTIONAL_LOCKS=0 git -C "$DIR" diff --quiet HEAD 2>/dev/null; then
    dirty="*"
  fi
  echo "${LABEL} ‹${branch}${dirty}›"
else
  echo "$LABEL"
fi
