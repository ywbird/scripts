#!/usr/bin/env bash
set -e

CFG_FILE=~/prg/scripts/xidlehookstate

if [ -f "$CFG_FILE" ]; then
    XIDLEHOOKSTATE=$(sed '1q;d' $CFG_FILE)
else
    XIDLEHOOKSTATE="false"  # Replace with your desired fallback
    echo "false" > $CFG_FILE
    echo "NULL" >> $CFG_FILE
fi

case $XIDLEHOOKSTATE in
  "true")
    XIDLEHOOK_PID=$(sed '2q;d' $CFG_FILE)

    if ps -p "$XIDLEHOOK_PID" > /dev/null 2>&1; then
      kill $XIDLEHOOK_PID
    fi

    echo "false" > $CFG_FILE
    echo "NULL" >> $CFG_FILE
    ;;
  "false")
    xidlehook \
      --not-when-fullscreen --not-when-audio \
      --timer 1800 \
        'betterlockscreen -l dim' \
        '' \
      --timer 2100 \
        'xset dpms force off' \
        'xset dpms force on' \
      --timer 2400 \
        'systemctl suspend' \
        '' &

    XIDLEHOOK_PID=$!

    echo "true" >        $CFG_FILE
    echo $XIDLEHOOK_PID >> $CFG_FILE
    ;;
  # *)
  #   echo -e "false\nNULL" > $CFG_FILE 
  #   killall xidlehook
  #
  #   ~/prg/scripts/xidlehook.sh
  #   ;;
esac


printf 1 >> $CFG_FILE
