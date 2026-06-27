#!/usr/bin/env bash
# List issue rows (with branch) from all issue-batch-sdd progress.md files.
# Usage: ./scripts/list-issues.sh
#
# Output format: <batch>\t<progress row>

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
  awk -v batch="$batch" '
    /^\| Issue \|/ { in_status=1; next }
    in_status && /^\| ---/ { next }
    in_status && /^## / { in_status=0; next }
    in_status && /^\|/ {
      split($0, c, "|")
      branch=c[4]
      gsub(/^ +| +$/, "", branch)
      if (branch == "" ) next
      printf "%s\t%s\n", batch, $0
    }
  ' "$f"
done
