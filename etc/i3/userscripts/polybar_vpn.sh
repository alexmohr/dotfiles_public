#/bin/bash

print_usage () {   
  SCRIPT_FILE=$(basename -- "$0")
  echo "Usage: ${SCRIPT_FILE} --state | --toggle | --connect | --disconnect"
  echo "state: show current state of vpn"
  echo "toggle: toggle vpn connection"
}

get_state () {
  FILE=/tmp/vpn.pid
  STATE="offline"
  COLOR="%{F#FF9800}"
  if pgrep openconnect > /dev/null; then
     COLOR="%{F#4CAF50}"
     STATE="online"
  fi
}

connect_vpn () {
  get_state
  echo $STATE
  if [ "$STATE" = "offline" ]; then
    sudo openconnect --config=$HOME/.config/vpn/openconnect.conf "https://emea.sra.corpshared.net/always-on" -i vpn_tun &
  fi 
}

disconnect_vpn () { 
  sudo killall openconnect
}


toggle_vpn () {
  get_state
  if [ "$STATE" = "offline" ]; then
    connect_vpn
  else
    disconnect_vpn
  fi
  echo $STATE
}

[ $# -gt 0 ] ||  print_usage 
while [ $# -gt 0 ]; do   
  PARAM=`echo $1 | awk -F= '{print $1}'`   
  case ${PARAM} in     -h | --help)       
    print_usage       
    ;;     
  --state)
    get_state
    echo "$COLOR VPN: $STATE"
    exit
    ;;
  --toggle)
    toggle_vpn
    exit
    ;; 
  --connect)
    connect_vpn
    exit
    ;; 
  --disconnect)
    disconnect_vpn
    exit
    ;;
  *)
    echo invalid command
    print_usage
    exit
    ;;
esac
done


