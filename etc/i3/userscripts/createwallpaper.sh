#!/bin/bash

magick convert ~/.wallpaper/wallpaper.jpg ~/.wallpaper/wallpaper.png
feh --bg-max ~/.wallpaper/wallpaper.png
rm ~/.wallpaper/wallpaper.jpg
~/.wallpaper/lockscreen/makelockscreen.sh
