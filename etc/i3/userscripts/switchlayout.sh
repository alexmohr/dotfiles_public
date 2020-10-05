#!/bin/bash
# Script to change keyboard layout in i3
layout=`setxkbmap -query | grep layout  | sed 's/\     //g' | sed 's/\layout\://g'`

new_layout=""
if [ "$layout" = "de" ]; then
  new_layout="us"
else
	new_layout="de"
fi

setxkbmap $new_layout
notify-send -u normal 'Layout: '$new_layout -h string:x-canonical-private-synchronous:anything

