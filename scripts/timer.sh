#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PID_FILE="$ROOT_DIR/.timer.pid"
STATE_FILE="$ROOT_DIR/.timer.state"

notify_user() {
  local title="$1"
  local message="$2"
  local banner="\n========== ${title} =========="

  if [[ -w /dev/tty ]]; then
    printf "%b\n%s\n============================\n" "$banner" "$message" > /dev/tty || true
  else
    printf "%b\n%s\n============================\n" "$banner" "$message"
  fi

  case "$(uname -s)" in
    Linux)
      if command -v notify-send >/dev/null 2>&1; then
        notify-send "$title" "$message" >/dev/null 2>&1 || true
      fi
      ;;
    Darwin)
      if command -v osascript >/dev/null 2>&1; then
        osascript -e "display notification \"${message}\" with title \"${title}\"" >/dev/null 2>&1 || true
      fi
      ;;
  esac

  printf '\a' > /dev/tty 2>/dev/null || printf '\a'
}

is_running() {
  [[ -f "$PID_FILE" ]] || return 1
  local pid
  pid="$(cat "$PID_FILE")"
  kill -0 "$pid" 2>/dev/null
}

start_timer() {
  local exercise="$1"
  local timeout_minutes="$2"

  if is_running; then
    echo "A timer is already running (PID $(cat "$PID_FILE")). Stop it first." >&2
    return 1
  fi

  local start_ts
  start_ts="$(date +%s)"
  printf "%s\t%s\t%s\n" "$exercise" "$start_ts" "$timeout_minutes" > "$STATE_FILE"

  nohup "$0" _run "$exercise" "$start_ts" "$timeout_minutes" > /tmp/cka-timer.log 2>&1 &
  echo $! > "$PID_FILE"
  echo "Started timer for exercise $exercise (${timeout_minutes}m)."
}

run_timer_loop() {
  local exercise="$1"
  local start_ts="$2"
  local timeout_minutes="$3"
  local total_seconds=$((timeout_minutes * 60))
  local warn50=0
  local warn80=0
  local alert100=0

  while true; do
    local now elapsed
    now="$(date +%s)"
    elapsed=$((now - start_ts))

    if (( elapsed >= (total_seconds / 2) )) && (( warn50 == 0 )); then
      notify_user "CKA timer $exercise" "50% time used (${timeout_minutes}m total)."
      warn50=1
    fi

    if (( elapsed >= (total_seconds * 80 / 100) )) && (( warn80 == 0 )); then
      notify_user "CKA timer $exercise" "80% time used (${timeout_minutes}m total)."
      warn80=1
    fi

    if (( elapsed >= total_seconds )) && (( alert100 == 0 )); then
      notify_user "CKA timer $exercise" "Time is up (${timeout_minutes}m)."
      alert100=1
      break
    fi

    sleep 1
  done
}

stop_timer() {
  local keep_state="${1:-false}"
  if is_running; then
    local pid
    pid="$(cat "$PID_FILE")"
    kill "$pid" >/dev/null 2>&1 || true
    rm -f "$PID_FILE"
    echo "Stopped timer."
  else
    echo "No running timer."
  fi

  if [[ "$keep_state" != "true" ]]; then
    rm -f "$STATE_FILE"
  fi
}

status_timer() {
  if [[ ! -f "$STATE_FILE" ]]; then
    echo "No timer state found."
    return 0
  fi

  local exercise start_ts timeout_minutes
  IFS=$'\t' read -r exercise start_ts timeout_minutes < "$STATE_FILE"

  local now elapsed total remaining
  now="$(date +%s)"
  elapsed=$((now - start_ts))
  total=$((timeout_minutes * 60))
  remaining=$((total - elapsed))
  if (( remaining < 0 )); then
    remaining=0
  fi

  local status="stopped"
  if is_running; then
    status="running"
  fi

  echo "Exercise: $exercise"
  echo "Status: $status"
  echo "Elapsed: ${elapsed}s"
  echo "Remaining: ${remaining}s"
  echo "Timeout: ${timeout_minutes}m"
}

case "${1:-}" in
  start)
    start_timer "$2" "$3"
    ;;
  _run)
    run_timer_loop "$2" "$3" "$4"
    ;;
  stop)
    stop_timer "${2:-false}"
    ;;
  status)
    status_timer
    ;;
  *)
    echo "Usage: $0 {start <exercise> <minutes>|stop [true]|status}" >&2
    exit 1
    ;;
esac
