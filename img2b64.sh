#!/usr/bin/env bash

# 파일 인자가 없는지 확인
if [ -z "$1" ]; then
    echo "사용법: $0 <이미지_파일_경로>"
    exit 1
fi

FILE_PATH="$1"

# 파일 존재 여부 확인
if [ ! -f "$FILE_PATH" ]; then
    echo "오류: 파일을 찾을 수 없습니다: $FILE_PATH"
    exit 1
fi

# MIME 타입 추출 (예: image/png, image/jpeg)
MIME_TYPE=$(file -b --mime-type "$FILE_PATH")

# Base64 변환 (줄바꿈 없이 -w 0)
BASE64_DATA=$(base64 -w 0 "$FILE_PATH")

# 최종 Data URL 생성
printf "data:$MIME_TYPE;base64,$BASE64_DATA"

