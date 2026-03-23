#!/usr/bin/env bash

wm=$(cat /tmp/protocol)

case $wm in
  "x11")
    # rofi -modi "clipboard:greenclip print" -show clipboard 
    # greenclip print | dmenu -l 5 | ~/bin/copy
    clipcat-menu
    ;;
  "wayland")
    foot --title "Clipboard History" --app-id "custom.floating" -W 55x15 -e sh -c "cliphist list | sk --prompt \"History: \" --no-sort | cliphist decode | wl-copy"
    ;;
esac

