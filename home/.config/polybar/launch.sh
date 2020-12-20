#!/usr/bin/env bash


function kill_polybar() {
  killall -q -9 polybar
  # Wait until the processes have been shut down
  while pgrep -x polybar >/dev/null; do sleep 1; done
}


LOG=-q

BATTERY="battery"
if [ -f /sys/class/power_supply/BAT1/status ]; then
  export BATTERY="$BATTERY battery-ext battery-total"
fi

LIGHT=""
if command -v COMMAND &> /dev/null; then
  LIGHT="light"
fi

FS_HOME=""
if df | grep home; then
  FS_HOME="filesystem-home"
fi

VPN=""
if  which openconnect > /dev/null ; then
  VPN="vpn"
fi

export WLAN=$(ip a | grep wl | cut -d : -f 2  | head -n 1 | xargs)
export LAN=$(ip a | grep en | grep -v lo | cut -d : -f 2  | head -n 1 | xargs )

export MODULES="fuel weather $LIGHT cpu-freq filesystem-root $FS_HOME wlan eth $VPN $BATTERY pulseaudio microphone date"

# Terminate already running bar instances
kill_polybar

xrandr_screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d " " -f 4-6 | sed 's/\ \ /_/g')
declare -A screens

for m in $xrandr_screens; do
  y=$(echo $m | cut -d / -f 1)
  if [ $y -gt 1920 ]; then
    CFG=i3wm_hidpi
  else 
    CFG=i3wm
  fi

  m=$(echo $m | cut -d "_" -f 2 )
  MONITOR=$m polybar $CFG $LOG &
done
