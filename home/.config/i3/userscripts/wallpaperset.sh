#!/bin/sh
# This scripts allows us to change the wallpaper wihtout remebering the commands
# It will generate a nnew script what will be called by i3 at init
# get path where the script is located
# its used for the lock icon

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

# read image parameter
img=$@

# path to the wallpapper
mkdir $SCRIPTPATH/../wallpapers -p
wpPath=$SCRIPTPATH/../wallpapers/activewallpaper

# the path to set the set wallpaper script
wpSetScript=$SCRIPTPATH/currentwallpaper.sh

# copy file to wallpaper directory
cp $img $wpPath

# write batch header 
echo '#/bin/bash' > $wpSetScript

#echo 'convert' $img -draw "text 190,120 'abc'" test1.png >> $wpSetScript 

scale='choose how the background should be scaled '
options=("Max" "Fill" "Scale" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Max")
          echo 'feh --bg-max' $wpPath >> $wpSetScript
          break
	  ;;
        "Scale")
           echo 'feh --bg-scale' $wpPath >> $wpSetScript 
	   break
	   ;;
        "Fill")
           echo 'feh --bg-fill' $wpPath >> $wpSetScript 
   	   break
	   ;;
        *) echo invalid option;;
    esac
done

# execute the script we build
chmod +x $wpSetScript
$wpSetScript

