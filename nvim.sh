#!/bin/sh

TERM_EXEC="alacritty -e"

if [ $# -ne 4 ]; then
    echo "USAGE: $0 <socket> <file> <line> <column>"
    exit 1
fi

SOCKET="$1"
FILE="$2"
LINE="$3"
COL="$4"

[ -S "$SOCKET" ] &&
    # Connect to running nvim server if socket exists
    nvim --server "$SOCKET" --remote-send ":n +call\ cursor($LINE,$COL) $FILE<CR>" || (
    # Create new server if socket doesn't exist
    tty -s && # Test if shell session is interactive, or a terminal should be opened
        nvim --listen "$SOCKET" "+call cursor($LINE,$COL)" "$FILE" || (
        nohup $TERM_EXEC nvim --listen "$SOCKET" "+call cursor($LINE,$COL)" "$FILE" > /dev/null 2>&1 & ) )
