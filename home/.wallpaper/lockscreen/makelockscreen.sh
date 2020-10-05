#!/bin/bash

# Dependencies: imagemagick, i3lock-color-git, scrot

IMAGE_IN=~/.wallpaper/wallpaper.png
IMAGE_OUT=/tmp/lockscreen.png
TEXT="Type password to unlock"

# get path where the script is located
# its used for the lock icon
pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd`
popd > /dev/null

# l10n support
case $LANG in
    fr_* ) TEXT="Entrez votre mot de passe" ;; # Français
    es_* ) TEXT="Ingrese su contraseña" ;; # Española
    pl_* ) TEXT="Podaj hasło" ;; # Polish
esac

LOCK="lock"
VALUE="55" #brightness value to compare to
COLOR=`convert $IMAGE_IN -colorspace hsb -resize 1x1 txt:- | sed -E '/.*$/ {
                             N
                             s/.*\n.*([0-9]{1,2}[^\.])\.[0-9]+%\)$/\1/
                             }'`;
if [ "$COLOR" -gt "$VALUE" ]; then #white background image and black text
    COLOR=black
    LOCK="lockdark"
else #black
    COLOR=white
fi

convert $IMAGE_IN -level 0%,100%,0.6 \
        -font Liberation-Sans -pointsize 26 -fill $COLOR -gravity center \
        -annotate +0+160 "$TEXT" \
        $SCRIPTPATH/$LOCK.png -gravity center -composite $IMAGE_OUT



