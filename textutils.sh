#!/usr/bin/env bash

TEXT=$(~/.scripts/paste.sh)

OPTIONS="[ 1] Capitalize
[ 2] Uppercase
[ 3] Lowercase
[ 4] B64 Encode
[ 5] B64 Decode
[ 6] Extract URL
[ 7] Redact username ($USER)
"

TASK=$(echo -ne "$OPTIONS" | ~/.scripts/select.sh)

case "$TASK" in
    "[ 1] Capitalize")
        echo -n "${TEXT^}" | ~/.scripts/copy.sh
        ;;
    "[ 2] Uppercase")
        echo -n "${TEXT^^}" | ~/.scripts/copy.sh
        ;;
    "[ 3] Lowercase")
        echo -n "${TEXT,,}" | ~/.scripts/copy.sh
        ;;
    "[ 4] B64 Encode")
        RESULT=$(echo -n "${TEXT}" | base64)
        echo $RESULT | ~/.scripts/copy.sh
        notify-send "B64 Encoded to" "$RESULT"
        ;;
    "[ 5] B64 Decode")
        RESULT=$(echo -n "${TEXT}" | base64 --decode --ignore-garbage)
        echo $RESULT | ~/.scripts/copy.sh
        notify-send "B64 Decoded to" "$RESULT"
        ;;
    "[ 6] Extract URL")
        RESULT=$(echo -n "${TEXT}" | rg "((http|ftp|https):\/\/([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-]))" -o)
        echo $RESULT | ~/.scripts/copy.sh
        notify-send "Extracted URL" "$RESULT"
        ;;
    "[ 7] Redact username ($USER)")
        RESULT=$(echo -n "${TEXT}" | sed -e 's/'$USER'/\[USERNAME REDACTED\]/g')
        echo $RESULT | ~/.scripts/copy.sh
        notify-send "Redacted username ($USER)" "$RESULT"
        ;;
esac
