#!/usr/bin/env bash

WM=$(cat /tmp/protocol)

CFG_FILE=~/prg/scripts/screen-record_cfg
OPTION=$(echo -e "[01] Whole Output\n[02] Rectangle\n[03] File Type" | ~/.scripts/select.sh --fzf-flags "--prompt Option: ")

case "$OPTION" in
  "[01] Whole Output")
    case $WM in
      "x11")
          REC_OUTPUT=$(xdpyinfo | grep dimensions | awk '{printf $2}')
        ;;
      "wayland")
          REC_OUTPUT=$(swaymsg -t get_outputs | jq -rc 'map(.name) | join("\n")' | fuzzel --dmenu -p "Output: ")
        ;;
    esac
    
    sed -i "1cWHOLE"         $CFG_FILE
    sed -i "2c${REC_OUTPUT}" $CFG_FILE
    
    notify-send "Set screen recording output." "'${REC_OUTPUT}'."
  ;;
  "[02] Rectangle")
    case $WM in
      "x11")
        REC_RECT=$(slop)
        ;;
      "wayland")
        REC_RECT=$(slurp -d)
        ;;
    esac

    sed -i "1cRECT"        $CFG_FILE
    sed -i "2c${REC_RECT}" $CFG_FILE

    notify-send "Set screen recording rectangle" "'${REC_RECT}'."
  ;;
  "[03] File Type")
    EXT=$(echo -e "mp4\nwebm" | ~/.scripts/select.sh --fzf-flags"--prompt Extension")
    sed -i "3c${EXT}" $CFG_FILE
  ;;
esac 

