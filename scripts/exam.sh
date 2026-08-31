#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/scripts/common.sh"

EXAM_SECONDS=$((120 * 60))
start_ts="$(date +%s)"
pass_count=0
attempt_count=0

"$ROOT_DIR/scripts/timer.sh" stop || true
"$ROOT_DIR/scripts/timer.sh" start exam 120

mapfile -t dirs < <(
  find "$ROOT_DIR/exercises" -maxdepth 1 -mindepth 1 -type d \
    | awk 'BEGIN{srand()} {printf "%.12f\t%s\n", rand(), $0}' \
    | sort -k1,1n \
    | cut -f2-
)

for dir in "${dirs[@]}"; do
  now="$(date +%s)"
  elapsed_total=$((now - start_ts))
  if (( elapsed_total >= EXAM_SECONDS )); then
    echo "Exam clock reached 120 minutes."
    break
  fi

  ex_id="$(basename "$dir" | cut -d- -f1)"
  timeout="$(read_timeout_minutes "$dir")"

  echo
  echo "=== Exercise $ex_id ($(basename "$dir")) ==="
  echo "Exam remaining: $((EXAM_SECONDS - elapsed_total))s"

  EXAM_MODE=1 "$ROOT_DIR/scripts/run-seed.sh" "$ex_id"
  ex_start="$(date +%s)"

  read -r -p "Press Enter when you are ready to verify exercise $ex_id..." _

  set +e
  EXAM_MODE=1 "$ROOT_DIR/scripts/run-verify.sh" "$ex_id"
  status=$?
  set -e

  ex_elapsed=$(( $(date +%s) - ex_start ))
  if (( status == 0 )); then
    pass_count=$((pass_count + 1))
  fi
  attempt_count=$((attempt_count + 1))

  ex_budget=$((timeout * 60))
  if (( ex_elapsed <= ex_budget )); then
    echo "Exercise $ex_id finished under its ${timeout}m budget."
  else
    echo "Exercise $ex_id finished over its ${timeout}m budget."
  fi

  echo "Exercise $ex_id took ${ex_elapsed}s."
done

"$ROOT_DIR/scripts/timer.sh" stop || true

if (( attempt_count == 0 )); then
  echo "No exercises attempted."
  exit 1
fi

score=$((pass_count * 100 / attempt_count))
echo
echo "Exam summary: $pass_count/$attempt_count passed (${score}%)."
if (( score >= 66 )); then
  echo "Result: pass (>=66%)."
else
  echo "Result: fail (<66%)."
fi
