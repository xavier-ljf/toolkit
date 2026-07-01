#!/usr/bin/env bash
# Initialize an issue-batch-sdd workspace and ensure it is gitignored.
# Usage: ./init-workspace.sh

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
DIR="$ROOT/.agents/issue-sdd"
mkdir -p "$DIR"

echo '*' > "$DIR/.gitignore"

# GITIGNORE="$ROOT/.gitignore"
# ENTRY=".agents/issue-sdd/"
# if [ ! -f "$GITIGNORE" ]; then
#   echo "$ENTRY" > "$GITIGNORE"
# elif ! grep -qxF "$ENTRY" "$GITIGNORE"; then
#   printf '\n# issue-batch-sdd artifacts\n%s\n' "$ENTRY" >> "$GITIGNORE"
# fi

echo "Ready: $DIR"
