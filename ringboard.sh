#!/usr/bin/bash

killall ringboard-server

ringboard-server &

wm=$(cat /tmp/protocol)

case $wm in
  "x11")
    killall ringboard-x11
    ringboard-x11
    ;;
  "wayland")
    ;;
esac
