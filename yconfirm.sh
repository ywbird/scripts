#!/bin/bash

msg=$1
cmd=$2
yes=$3
if [ -z $3 ]; then
  yes="Yes"
fi
no=$4
if [ -z $4 ]; then
  no="No"
fi

msglen=${#msg}

ans=$(printf "$no\n$yes" | ~/bin/select -c -p "$msg: " )

if [ "$ans" = "$yes" ]; then
  $cmd
fi
