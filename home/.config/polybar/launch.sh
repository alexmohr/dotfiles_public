#!/usr/bin/env sh


function kill_polybar() {
  killall -q -9 polybar
  # Wait until the processes have been shut down
  while pgrep -x polybar >/dev/null; do sleep 1; done
}


LOG=-q
CFG=i3wm

max_x=0
for res in  $(xrandr | grep \*  | awk '{print $1 }'); do
  res_x=`echo $res | cut -d 'x' -f 1`

  if [[ "$res_x" -gt "$max_x" ]]; then
    max_x=$res_x
  fi
done

if ((  $max_x > 1920 )); then
  CFG=i3wm_hidpi
fi

# Terminate already running bar instances
kill_polybar

#polybar_screens=$(polybar --list-monitors | cut -d ':' -f 1)
xrandr_screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d " " -f 4-6 | sed 's/\ \ /_/g')
declare -A screens

for m in $xrandr_screens; do
  # x_pos=$(echo $m |  cut -d "+" -f 2)
  m=$(echo $m | cut -d "_" -f 2 )
  MONITOR=$m polybar $CFG $LOG &
done
