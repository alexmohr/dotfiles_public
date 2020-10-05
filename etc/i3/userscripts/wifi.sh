#!/bin/bash
ip link | grep $1  | grep "state DOWN"
res=$?
echo $res
if [[ $res -eq 0 ]]; then
    sudo rfkill unblock wlan
fi
