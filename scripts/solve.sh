#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/common.sh"

EXERCISE_ID="${1:?Usage: solve.sh <exercise-number>}"
EXERCISE_DIR="$(exercise_dir_from_id "$EXERCISE_ID")"

if [[ -x "$EXERCISE_DIR/solution/solve.sh" ]]; then
  "$EXERCISE_DIR/solution/solve.sh"
else
  echo "No executable solver for exercise $(printf "%02d" "$EXERCISE_ID")."
  echo "Apply manifests from: $EXERCISE_DIR/solution"
fi
