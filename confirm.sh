#!/usr/bin/env bash
#!/bin/bash
# confirm.sh - yes/no 선택을 통해 명령 실행

if [[ $# -lt 2 ]]; then
    echo "Usage: confirm.sh <message> <command> [args...]" >&2
    exit 1
fi

message="$1"
shift

# 프롬프트 메시지와 함께 선택
choice=$(printf "no\nyes" | ~/.scripts/select.rb -p '$message')

# 선택 결과에 따라 명령 실행
if [[ "$choice" == "yes" ]]; then
    $@
    exit $?
else
    exit 1
fi
