#!/bin/bash

option_logout="Logout"
option_reboot="Restart / Reboot"
option_hibernate="Hibernate"
option_suspend="Suspend then hibernate"
option_shutdown="Shutdown"

result=`echo -e "$option_logout\n$option_reboot\n$option_hibernate\n$option_suspend\n$option_shutdown" | rofi -dmenu -theme Arc-Dark -i -fn 'RobotoMonoRegular-Regular-10' -nb '#212121' -sf '#fafafa' -sb '#3f51b5' -nf '#fafafa' -p "Exit"`

case "$result" in
  "$option_logout")
    i3-msg exit
    ;;

  "$option_reboot")
    reboot
    ;;

  "$option_hibernate")
    systemctl hibernate
    ;;

  "$option_suspend")
    /etc/i3/userscripts/i3lock-fancy/lock & systemctl suspend-then-hibernate
    ;;

  "$option_shutdown")
    systemctl poweroff
    ;;

  *)
    exit 1
esac


