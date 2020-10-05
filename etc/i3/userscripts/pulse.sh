#!/bin/bash
function mute_src {
  out=$(pactl set-$1-mute $i true 2>&1)
  echo $out

  if [ -z "$out" ]; then
    echo Muted $1 $i
    return
  fi

  if [[ $out == *"Connection failure"* ]]; then
    killall pulseaudio
    pulseaudio --start
    sleep 3
    mute_src $1 $i
  else
    echo $out
  fi
}

function mute {
  mute_src "source"
  mute_src "sink"
}

for i in {0..3}; do # for i in 0 1; do # to disable others
  mute
done;
