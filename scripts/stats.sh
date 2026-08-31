#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HISTORY_FILE="$ROOT_DIR/.progress/history.tsv"

if [[ ! -f "$HISTORY_FILE" ]]; then
  echo "No history found."
  exit 0
fi

awk -F'\t' 'NR>1 {
  ex=$1
  elapsed=$3+0
  result=$5
  attempts[ex]++
  if (!(ex in best) || elapsed < best[ex]) best[ex]=elapsed
  last[ex]=elapsed
  if (result=="pass") passes[ex]++
}
END {
  printf "%-10s %-10s %-10s %-10s %-10s\n", "exercise", "attempts", "best_s", "last_s", "pass_rate"
  for (ex in attempts) {
    rate=(passes[ex]/attempts[ex])*100
    printf "%-10s %-10d %-10d %-10d %6.1f%%\n", ex, attempts[ex], best[ex], last[ex], rate
  }
}' "$HISTORY_FILE" | sort
