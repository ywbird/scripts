#!/bin/bash

IMG=$(xdg-user-dir PICTURES)/Captures/$(date +'%Y%m%d%H%M%S.png')

grim IMG

sleep 0.5

notify-send "Took screenshot." "$IMG"

wl-copy < $IMG
