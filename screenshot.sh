#!/bin/bash

IMG=$(xdg-user-dir PICTURES)/Captures/$(date +'%Y%m%d%H%M%S.png')


wm=$(cat /tmp/protocol)

case $wm in
  "x11")
    flameshot gui 
    ;;
  "wayland")
    grim -g "$(slurp -d)" $IMG

    sleep 0.5

    notify-send "Took screenshot." "$IMG"

    wl-copy < $IMG
    ;;
esac
