#!/bin/bash

# dmenu replacement using alacritty
# Reads from stdin, displays options, returns selected choice

tmpfile=$(mktemp)
cat > "$tmpfile"

alacritty \
  --class "custom.floating" \
  -e bash -c "cat $tmpfile | fzf --no-info --no-preview --height 100% > /tmp/dmenu_result"

# Read the result and output it
if [ -f /tmp/dmenu_result ]; then
  cat /tmp/dmenu_result
  rm -f /tmp/dmenu_result
fi

rm -f "$tmpfile"
