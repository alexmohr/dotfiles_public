export DISPLAY=:0
export XAUTHORITY=/home/me/.Xauthority
EXTERNAL_DISPLAY=DP2-1
state=$(echo "$1" | cut -d " " -f 3)
case "$state" in
  open*)
    # enable internal display
    xrandr --output eDP1 --auto --primary 
    xrandr --output $EXTERNAL_DISPLAY --auto --left-of eDP1 	
    # todo set docked display to edp1 
    ;;
  close*)
    # put system into suspend to ram when lid is closed on battery mode
    if [[ `cat /sys/class/power_supply/AC/online` -eq 0 ]]; then 
      /etc/i3/userscripts/i3lock-fancy/lock & systemctl suspend
    else
      # disable the internal display when the lid is closed
      xrandr --output eDP1 --auto --off	
      xrandr --output $EXTERNAL_DISPLAY --auto --left-of eDP1 --primary
    fi


    ;;
  *)
esac
