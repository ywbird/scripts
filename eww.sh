#!/usr/bin/env bash

wm=$(cat /tmp/protocol)

case $wm in
  "x11")
    exec ~/prg/eww/eww-x11 "$@"
    ;;
  "wayland")
    exec ~/prg/eww/eww-wayland "$@"
    ;;
esac
