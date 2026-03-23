#!/usr/bin/env bash

CFG_FILE=~/prg/scripts/xidlehookstate

echo "false" > $CFG_FILE
echo "NULL" >> $CFG_FILE

printf 1 >> $CFG_FILE

~/prg/scripts/xidlehook.sh
