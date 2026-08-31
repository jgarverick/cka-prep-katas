#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/common.sh"

EXERCISE_ID="${1:?Usage: run-verify.sh <exercise-number>}"
EXERCISE_DIR="$(exercise_dir_from_id "$EXERCISE_ID")"
TIMEOUT_MINUTES="$(read_timeout_minutes "$EXERCISE_DIR")"
PADDED_ID="$(printf "%02d" "$EXERCISE_ID")"

start_ts="$(date +%s)"
if [[ -f "$ROOT_DIR/.timer.state" ]]; then
  IFS=$'\t' read -r timer_exercise timer_start_ts _ < "$ROOT_DIR/.timer.state"
  if [[ "$timer_exercise" == "$PADDED_ID" ]]; then
    start_ts="$timer_start_ts"
  fi
fi

set +e
"$EXERCISE_DIR/verify.sh"
status=$?
set -e

elapsed=$(( $(date +%s) - start_ts ))

if [[ "${EXAM_MODE:-0}" != "1" ]]; then
  "$ROOT_DIR/scripts/timer.sh" stop || true
fi

if (( status == 0 )); then
  result="pass"
else
  result="fail"
fi

log_attempt "$PADDED_ID" "$elapsed" "$TIMEOUT_MINUTES" "$result"

budget=$((TIMEOUT_MINUTES * 60))
if (( elapsed <= budget )); then
  echo "Finished in ${elapsed}s (under ${TIMEOUT_MINUTES}m budget)."
else
  echo "Finished in ${elapsed}s (over ${TIMEOUT_MINUTES}m budget)."
fi

exit "$status"
