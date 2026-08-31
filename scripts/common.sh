#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HISTORY_FILE="$ROOT_DIR/.progress/history.tsv"

mkdir -p "$ROOT_DIR/.progress"
if [[ ! -f "$HISTORY_FILE" ]]; then
  printf "exercise\ttimestamp\telapsed_seconds\ttimeout_minutes\tresult\n" > "$HISTORY_FILE"
fi

exercise_dir_from_id() {
  local exercise_id
  exercise_id="$(printf "%02d" "$1")"
  local dir
  dir="$(find "$ROOT_DIR/exercises" -maxdepth 1 -mindepth 1 -type d -name "${exercise_id}-*" | sort | head -n1)"
  if [[ -z "$dir" ]]; then
    echo "Exercise ${exercise_id} was not found under exercises/." >&2
    return 1
  fi
  printf "%s\n" "$dir"
}

read_timeout_minutes() {
  local exercise_dir="$1"
  local timeout
  timeout="$(awk -F': *' '/^timeout:/ {print $2; exit}' "$exercise_dir/meta.yaml")"
  if [[ -z "${timeout:-}" ]]; then
    echo "Missing timeout in $exercise_dir/meta.yaml" >&2
    return 1
  fi
  printf "%s\n" "$timeout"
}

log_attempt() {
  local exercise_id="$1"
  local elapsed_seconds="$2"
  local timeout_minutes="$3"
  local result="$4"
  local timestamp
  timestamp="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  printf "%s\t%s\t%s\t%s\t%s\n" "$exercise_id" "$timestamp" "$elapsed_seconds" "$timeout_minutes" "$result" >> "$HISTORY_FILE"
}
