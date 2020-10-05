#!/bin/bash
dmenu="rofi -theme Arc-Dark -dmenu -i -fn 'FontAwesome-10' -nb #212121 -sf #fafafa -sb #3f51b5 -nf #fafafa -p"
t=1


function addState {
    for number in $( eval echo {0..$t} ); do
        x="$x\t"
    done
    y="$x $y"

    if [ `expr length "$y"` -gt 0 ]; then
        if [ `expr length "$options"` -gt 0 ]; then
            options=$options"\n$y"
        else 
            options="$y"
        fi
    fi
}



function toLower {
    y=`echo "$x" | tr '[:upper:]' '[:lower:]' | sed $'s/^\t*$//g'`
}
