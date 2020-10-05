export DISPLAY=:0.0
export XAUTHORITY=/home/me/.Xauthority

notify-send -u normal 'Suspending...'
systemctl suspend
