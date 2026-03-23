#!/usr/bin/env bash

wm=$(cat /tmp/protocol)

case $wm in
  "x11")
    exec xclip -selection clipboard "$@"
    ;;
  "wayland")
    exec wl-copy "$@"
    ;;
esac
