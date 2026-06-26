#!/usr/bin/env bash
# List issue rows (with branch) from all issue-batch-sdd progress.md files.
# Usage: ./list-issues.sh

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
DIR="$ROOT/.agents/issue-sdd"

shopt -s nullglob
files=("$DIR"/*/progress.md)

if [ ${#files[@]} -eq 0 ]; then
  echo "No progress.md found under $DIR" >&2
  exit 0
fi

for f in "${files[@]}"; do
  batch="$(basename "$(dirname "$f")")"
  while IFS= read -r line; do
    case "$line" in
      '| Issue ID'*|'| ---'*|'|-') continue ;;
    esac
    printf '%s\t%s\n' "$batch" "$line"
  done < "$f"
done
