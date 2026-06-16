#!/usr/bin/env bash

set -e

wm=$(cat /tmp/protocol)

histfile="$HOME/.cache/cliphist"

case $wm in
  "x11")
    clipcontent=$(xclip -sel clip -o)
    if [[ -z "$clipcontent" ]]; then exit 1; fi
    if [ -f "$histfile" ]; then
      if [ -s "$histfile" ]; then
        printf "\0" >> $histfile
      fi
    else
      touch $histfile
    fi
    printf "%s" "$clipcontent" >> $histfile
    ;;
  "wayland")
    # TODO
    ;;
esac

