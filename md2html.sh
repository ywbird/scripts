#!/bin/bash

pandoc --standalone --mathjax -f markdown+latex_macros -t html "$@"
