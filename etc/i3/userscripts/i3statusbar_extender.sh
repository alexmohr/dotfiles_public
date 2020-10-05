#!/bin/sh
# -*- coding: utf-8 -*-
# shell script to prepend i3status with more stuff
# todo rewrite this shitty script in pyhton.

# get the script path
pushd `dirname $0` > /dev/null
scriptpath=`pwd`
popd > /dev/null

# timing for costly scripts
intervall=1 # update intervall in seconds
intervall_medium=10
intervall_long=1800 # slow update intervall in seconds

start=0
start_medium=0
start_long=0
wan='[{ \"full_text\": \"?\", \"color\":\"FFFFFFF\"},'
weather='{ "full_text": "?", "color":"#000000"},'
space='   '

i3status | (read line && echo $line && read line && echo $line && while :
do
	read line

	now=$(date +%s)
	diff=$((now-start))
	diff_medium=$((now-start_long))
	diff_long=$((now-start_medium))

	if (("$diff_long" >= "$intervall_long"));  then
		weather=`$scriptpath/weather.py --i3bar`
		fuel=`$scriptpath/fuel.py` 
		fuel="{\"full_text\":\"$space\uf52f $fuel$space\"},"

		start_long=$(date +%s)
	fi

	if (("$diff_medium" >= "$intervall_medium"));  then
		cpu=`{ printf "{ \"full_text\": \" $space  "; cpupower frequency-info  | grep "Hz" | grep "current CPU" | xargs |  cut -d ' ' -f 4-5 | xargs -I {} printf  {};  echo -e "  \"}, "; }`
		cpu=$cpu $space
		start_medium=$(date +%s)
	fi

	if (("$diff" >= "$intervall"));  then
		# update the slow scripts every 30 seconds
		layout=`setxkbmap -query | grep layout  | sed 's/\     / /g' | sed 's/layout://g'`

		layout=`printf "\uf11c %s" $layout`
		layout="{\"full_text\":\"$space$layout$space\"},"

		brightness=`light`
		brightness=`printf "\uf0eb %.0f" "${brightness}"` 
		brightness="{\"full_text\":\"$space$brightness$space\"},"

		# reset start data 
		start=$(date +%s)
	fi 

	output="$fuel $weather $cpu $layout $brightness"
	echo "${line/[/[ $output  } " 
	sleep 0.1
done)



