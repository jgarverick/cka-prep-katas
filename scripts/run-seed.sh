#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/common.sh"

EXERCISE_ID="${1:?Usage: run-seed.sh <exercise-number>}"
EXERCISE_DIR="$(exercise_dir_from_id "$EXERCISE_ID")"
TIMEOUT_MINUTES="$(read_timeout_minutes "$EXERCISE_DIR")"

"$EXERCISE_DIR/seed.sh"

if [[ "${EXAM_MODE:-0}" != "1" ]]; then
  "$ROOT_DIR/scripts/timer.sh" stop || true
  "$ROOT_DIR/scripts/timer.sh" start "$(printf "%02d" "$EXERCISE_ID")" "$TIMEOUT_MINUTES"
fi

echo "Seeded exercise $(printf "%02d" "$EXERCISE_ID") in $EXERCISE_DIR"
