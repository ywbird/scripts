#!/bin/bash

IMG=$(xdg-user-dir PICTURES)/Captures/$(date +'%Y%m%d%H%M%S')

grim "${IMG}.png"

swayimg "${IMG}.png" -f --config=info.show=no &
IMGVIEWER_PID=$!

OUTPUT="eDP-1"

geom=$(slurp)   # e.g. "2784,813 461x464"
read xy wh <<<"$geom"
IFS=',' read x y <<<"$xy"

# get this output's origin (rect.x, rect.y)
read ox oy <<<"$(swaymsg -t get_outputs \
  | jq -r --arg o "$OUTPUT" '.[] | select(.name==$o).rect | "\(.x) \(.y)"')"

lx=$((x - ox))
ly=$((y - oy))

crop="${wh}+${lx}+${ly}"
magick "${IMG}.png" -crop "$crop" +repage "${IMG}_cropped.png"

kill $IMGVIEWER_PID

notify-send "Took cropped screenshot." "${IMG}_cropped.png"

wl-copy < "${IMG}_cropped.png"
