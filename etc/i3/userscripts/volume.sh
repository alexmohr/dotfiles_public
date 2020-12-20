#!/bin/bash


# includes
source "/etc/i3/userscripts/util.sh"
MAX_SINKS=10

function getActiveSinkProfile {
    echo `pactl list sinks | grep profile.description` | cut -d "=" -f 2 | cut -d "\"" -f 2
}


function getSources {
    SOURCES=$(pactl list sources | grep "Source #"  | cut -d '#' -f 2)
}


function getSinks {
    SINKS=$(pactl list sinks | grep "Sink #"  | cut -d '#' -f 2)
}


function getSinkSelect { 
    x="Select Profile"
    y="`getActiveSinkProfile`"
    t=1
    addState
    sink=`echo -e $y`
}

function getSinkProfiles { 
    outputs=`pacmd list-cards | grep output | grep -v "available: no" | grep -v profile | cut -d "," -f 1 | rev | cut -d ":" -f 1 | rev |  sed -e 's/^[[:space:]]*//' | grep -v -i monitor | sed 's/(prio.*//g'`
    while read -r line; do
        x="$line\t"
        y="\u000"
        addState
    done <<< "$outputs"
}

function setSinkProfile { 
    outputs=`pacmd list-cards | grep output | grep -v "available: no" | grep -v profile | grep -v -i monitor`
    new_out=`echo $1 | tr -d '\t'`
    while read -r line; do
        if echo "$line" | grep "$new_out"; then
            name=`echo $line | cut -d ':'  -f 1,2`
            echo pactl set-card-profile 0 $name
            pactl set-card-profile 0 "$name"
            return
        fi
    done <<< "$outputs"
}

function muteSources {
    while read -r i; do
       pactl set-source-mute $i true
    done <<< $SOURCES
}

function muteSinks {
    getSinks
    while read -r i; do
       pactl set-sink-mute $i true
    done <<< $SINKS
}

function toggleMuteSources {
    getSources
    while read -r i; do
      pactl set-source-mute $i toggle
    done <<< $SOURCES
}

function toggleMuteSinks {
    getSinks
    while read -r i; do
       pactl set-sink-mute $i toggle
    done <<< $SINKS
}

function lowerVolume {
    getSinks
    while read -r i; do
       pactl set-sink-mute $i false
       pactl -- set-sink-volume $i -5%
    done <<< $SINKS
}


function raiseVolume {
    getSinks
    while read -r i; do
       pactl set-sink-mute $i false
       pactl -- set-sink-volume $i +5%
    done <<< $SINKS
}



function setVolume {
    result=`echo -e "" | $dmenu "Enter new volume"`
    getSinks
    while read -r i; do
      pactl set-sink-mute $i false
      pactl set-sink-volume $i $result%; 
    done <<< $SINKS   
}

function getDefaultSourceVolume {
  PAC=$(pacmd list-sources |  grep "\*.*index" -A 40)
  MUTED=$(echo "$PAC"  | grep mute |  cut -d : -f 2 | xargs)
  VOLUME=$(echo "$PAC" | grep "volume:" | grep -v base  | cut -d % -f 1 | cut -d / -f 2 | xargs  )
  if [[ "$MUTED" == "yes" ]]; then 
    echo "%{F#ffff00}" 
  else
    echo " $VOLUME%"
  fi

}

function getVolume {
    x="Volume"
    t=2
    pactl=`pactl list sinks`
    y=`pactl list sinks | grep "Volume"| grep -v Base  | awk '{print $5}'`
    mute=`pactl list sinks | grep "Mute" |  awk '{print $2}'`
    if [ "$mute" = "yes" ]; then
        y="\uf026 $y"
    elif [ ${y::-1} -eq "0" ]; then
        y="\uf026 $y"
    elif [ ${y::-1} -lt "45" ]; then
        y="\uf027 $y"
    else 
        y="\uf028 $y"
    fi

    addState $x $y
    volume=`echo -e $y`
}

function setPavu { 
    pavucontrol
}


function getPavu {
    x="Run"
    t=3
    y="\uf0ad Pavucontrol"
    addState $x $y

    pavu=`echo -e $y`
}

function setSinkProfileMenu {
    options=""
    getSinkProfiles
    result=`echo -e "$options" | $dmenu "Select Profile"`
    setSinkProfile "$result"
}

function showVolumeMenu { 
    options=""
    getSinkSelect
    getVolume
    getPavu

    result=`echo -e "$options" | $dmenu "Volume"`
    case "$result" in
        "$sink")
            setSinkProfileMenu
            ;;
        "$volume")
            setVolume
            ;;
         "$pavu")
            setPavu
            ;;
    	*)
            exit 1
    esac
}

