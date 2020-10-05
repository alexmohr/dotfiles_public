#!/bin/bash

dmenu="rofi -dmenu -i -fn 'RobotoMonoRegular-Regular-10' -nb #212121 -sf #fafafa -sb #3f51b5 -nf #fafafa -p"
function selectDisplay() {
  all=$(xrandr | grep " connected " | awk '{ print$1 }')
    displays=""
    if [ "$displaySource" != "" ]; then
        for display in $all; do
            if [ "$display" != "$displaySource" ]; then
                if [ ${#displays} -gt 0 ]; then
                    displays="${displays}\n${display}"
                else
                    displays=$display
                fi
            fi
        done
    else
        displays=$all
    fi
    count=`echo -e $displays | wc | awk '{print $2}'`
    if [[ $count = 1 ]]; then
      display=$displays
    else
      display=$(echo -e "$displays" | $dmenu "$mode Select display")
      if [ "$display" == "" ]; then
          exit
      fi
    fi
}

function getDisplayState() {
    xrandr -q | grep $display | grep "connected ("
    result=$?
    if [ 0 == $result ]; then
        state="off"
    else
        state="on"
    fi
}

function selectAlign() {
    options="left-of\nright-of\nbelow\nabove\nmirror"
    result=$(echo -e "$options" | $dmenu "$mode Select Mode")
    if [ "$result" == "mirror" ]; then
        result="same-as"
    fi

    if [ "$result" == "" ]; then
        exit
    fi

    displaySource=$display
    selectDisplay # select target display
    xrandr --output $displaySource --$result $display
    displaySource=""
}

function selectPower() {
    cmd="xrandr --output $display --auto"
    case "$state" in
    "on")
        $($cmd)
        selectAlign
        ;;
    "off")
        $($cmd --off)
        ;;
    esac
}

function selectResolution() {
    res=$(xrandr |
        awk -v monitor="^$display connected" '/connected/ {p = 0}
        $0 ~ monitor {p = 1}
    p')

    options=""
    for item in $res; do
        if [ ${#item} -le 5 ]; then
            continue
        fi
        if [[ $item == *"+"* ]]; then
            continue
        fi
        if [[ $item == *"x"* ]]; then
            if [ ${#options} -gt 0 ]; then
                options=$options\\n$item
            else
                options=$item
            fi
        fi
    done

    result=$(echo -e "$options" | dmenu_styled "$mode Select Resolution for $display")
    if [ "$result" == "" ]; then
        exit
    fi

    xrandr --output $display --mode $result
}

function selectRotate() {
    options="normal\ninverted\nleft\nright"
    result=$(echo -e "$options" | $dmenu "$mode Rotate display $display")

    cmd="xrandr --output $display --rotate "
    $($cmd $result)
}

function selectFunction() {
    getDisplayState
    if [ "$state" == "off" ]; then
        state="on"
    else
        state="off"
    fi

    options="Turn $state\nAlign\nResolution\nRotate\n← Back"
    result=$(echo -e "$options" | $dmenu "$mode Select function for $display")

    case "$result" in
    "Turn $state")
        selectPower
        ;;
    "Align")
        selectAlign
        ;;
    "Resolution")
        selectResolution
        ;;
    "Rotate")
        selectRotate
        ;;
    "← Back")
        main
        ;;
    esac
}

function main() {
    selectDisplay
    selectFunction
}

main
