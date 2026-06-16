#!/usr/bin/env bash

wezterm start \
  --class="custom.floating" \
  -- bash -c 'find ~/Pictures/Captures/* | \
    sort --reverse | \
    fzf \
      --preview="chafa -f iterm -s \
        \${FZF_PREVIEW_COLUMNS}x\${FZF_PREVIEW_LINES} {}" \
      --delimiter="/" --with-nth -1 \
      --bind="ctrl-e:execute-silent(nohup kolourpaint {})+abort" \
    > /tmp/fzf_result'

# Read the result and output it
if [ -f /tmp/fzf_result ]; then

  if [ -s /tmp/fzf_result ]; then
    xclip -i -sel clip -t image/png $(cat /tmp/fzf_result)
  fi
  rm -f /tmp/fzf_result
fi

