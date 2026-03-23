#!/bin/bash

# Get a list of all windows in Sway, formatted for fzf
windows=$(swaymsg -t get_tree | jq -r '
    .nodes[] | recurse(.nodes[], .floating_nodes[]) | select(.type=="con" and .focused==false) |
    "\(.id) \(.app_id // .window_properties.title)"
')

# Use fzf to select a window
selected_window=$(echo "$windows" | fuzzel --dmenu --prompt="Switch to window: ")

# Extract the window ID and focus on it
if [ -n "$selected_window" ]; then
    window_id=$(echo "$selected_window" | awk '{print $1}')
    swaymsg "[con_id=$window_id]" focus
fi
