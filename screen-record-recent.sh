#!/usr/bin/env bash

mpv --loop-file=inf ~/Videos/Recordings/$(ls ~/Videos/Recordings -t | rg "screen" | ~/bin/select -l 10 -p "Recent Recording")
