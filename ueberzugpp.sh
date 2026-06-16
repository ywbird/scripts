#!/usr/bin/env bash

UB_PID=0
UB_SOCKET=""

case "$(uname -a)" in
    *Darwin*) UEBERZUG_TMP_DIR="$TMPDIR" ;;
    *) UEBERZUG_TMP_DIR="/tmp" ;;
esac

cleanup() {
    ueberzugpp cmd -s "$UB_SOCKET" -a exit
}
trap cleanup HUP INT QUIT TERM EXIT

UB_PID_FILE="$UEBERZUG_TMP_DIR/.$(uuidgen)"
ueberzugpp layer --no-stdin --silent --use-escape-codes --pid-file "$UB_PID_FILE"
UB_PID="$(cat "$UB_PID_FILE")"
export UB_SOCKET="$UEBERZUG_TMP_DIR"/ueberzugpp-"$UB_PID".socket



ueberzugpp cmd -s "$UB_SOCKET" -a add -i FZFPREVIEW -x "$1" -y "$2" --max-width "$3" --max-height "$4" -f "$5"
sleep 2
