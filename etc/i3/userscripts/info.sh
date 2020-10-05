#!/bin/bash

script_path="/etc/i3/userscripts/"
options=""

# includes 
source "$script_path/util.sh"
source "$script_path/volume.sh"
source "$script_path/tlp.sh"


function rf {
	rf=$(rfkill list ${y} | grep Soft | cut -d ':' -f 2 | tr -d ' ' )
}

function getRfKill {
	toLower
	rf
	if [ "$rf" = "no" ]; then
		y="On"
	else
		y="Off"
	fi


}

function setBrightness {
	options=""	
	result=`echo -e "$options" | $dmenu "Enter new brightness"`
	light -S $result
}

function getBrightness {
	x="Brightness"
	t=2
	y=`light`
	y=`printf "\uf0eb %.0f" "${y}"`
	addState $x $y
	brightness=`echo -e $y`
}

function setRfKill {
	toLower
	rf
	if [ "$rf"  = "no" ]; then
		sudo rfkill block $y
	else
		sudo rfkill unblock $y
	fi

}

function getBluetooth {
	x="Bluetooth"
	t=2
	getRfKill
	y="\uf294 $y"
	addState $x $y
	bluetooth=`echo -e $y`
}

function getWifi {
	x="Wifi"
	t=3
	getRfKill
	y="\uf1eb $y"
	addState $x $y
	wifi=`echo -e $y`
}


function setWifi() {
	x="Wifi"
	setRfKill
}


function setBluetooth() {
	x="Bluetooth"
	setRfKill
}

function mainMenu {
	getWifi
	getBluetooth
	getPowerSettings
	getVolume
	getBrightness

	result=`echo -e "$options" | $dmenu "SysControl"`
	case "$result" in
		"$wifi")
			setWifi
			;;
		"$bluetooth")
			setBluetooth
			;;
		"$volume")
			showVolumeMenu
			;;
		"$brightness")
			setBrightness
			;;
		"$power")
			tlpMainMenu
			exit 0;
			;;
		*)
			exit 1
			;;
	esac
	options=""
}


mainMenu


