#!/bin/bash

conf="$HOME/.config/wallpaper-reddit/wallpaper-reddit.conf"

max_y=2160
max_x=3840

cp "$HOME/.config/wallpaper-reddit/wallpaper-reddit.template" $conf 
sed -i "s/\$res_x/$max_x/g" $conf
sed -i "s/\$res_y/$max_y/g" $conf

wallpaper-reddit
