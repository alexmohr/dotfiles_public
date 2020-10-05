#!/bin/bash
xrandr -q  | grep $1  | grep "+0 (" ; 
r=$? 
if [ $r == 0 ]; then 
	xrandr --output $1 --off
else
       	xrandr --output $1 --auto --primary
fi
