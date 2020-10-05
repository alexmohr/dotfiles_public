#!/bin/bash

res_x=`xrandr | grep \*  | xargs echo | cut -d ' ' -f 1  | cut -d 'x' -f 1`
if (( $res_x > 1920 )); then
  xrandr --dpi 120
fi

