#!/bin/bash

#
# This script checks the power state of the system and shuts it down if it gets
# below a certain level and the system is not plugged into ac
#

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export XAUTHORITY=/home/me/.Xauthority
THRESHOLD_WARN=10
THRESHOLD_SHUT=7

POWER_SUPPLIES=($(ls /sys/class/power_supply/))

BATTERY_CLASS="/sys/class/power_supply/"
BATTERY_INFO="/uevent "
BATTERIES=''

update_status(){
for SUPPLY in "${POWER_SUPPLIES[@]}"
do
    if [ "$SUPPLY" == "AC" ]; then
        if [ `cat $BATTERY_CLASS/$SUPPLY/online` -eq 1 ]; then
            echo AC is online.
            exit
        fi
    else
        BATTERIES+=$BATTERY_CLASS$SUPPLY$BATTERY_INFO
   fi
done
}

update_status
BATTERY_STATUS=`paste $BATTERIES |awk '{split($0,a,"="); split(a[2],b," "); (a[3] == "Charging" || b[1] == "Charging") ? $5 = "Charging" : $5 = (a[3] + b[1])/2; print a[1] "=" $5}'`
CAPACITY=`echo $BATTERY_STATUS | cut -d ' ' -f 12 | cut -d '=' -f 2`

# handle shutdown THRESHOLD
if (( $(echo "$CAPACITY < $THRESHOLD_SHUT" |bc -l) )); then
    echo "Shutdown in 1 minute"
    su me -c 'zenity --notification --window-icon="error" --text "Battery level is critical system suspending to disk in 1 minute, unless power is connected"'
    sleep 1m
    update_status
    echo LOW BATTERY SHUTDOWN INITIATED!
    systemctl suspend
    exit
fi

# handle warning threshold
if (( $(echo "$CAPACITY < $THRESHOLD_WARN " |bc -l) )); then
    echo "Warning threshold reached"
    su me -c 'zenity --notification --window-icon="error" --text "Battery level is very low. Connect charger soon"'
    exit
fi

echo "Battery at $CAPACITY%, AC not plugged in."
