#!/usr/bin/env bash

wm=$(cat /tmp/protocol)

case $wm in
  "x11")
    exec dmenu -l 6 -i "$@"
    ;;
  "wayland")
    exec fuzzel -d "$@"
    ;;
esac
