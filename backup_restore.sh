#!/bin/bash

# get the script path
pushd `dirname $0` > /dev/null
scriptpath=`pwd`

vim=~/.SpaceVim.d/init.toml

files=(
~/.Xresources
~/.bashrc
~/.zshrc
~/.zsh_bash_common_rc
~/.zshrc.zni
~/.zsh-update
~/.xbindkeysrc
~/.gtkrc-2.0
~/.profile
~/.wallpaper
)

usrBinFiles=(
/usr/bin/dmenu_styled
/usr/bin/battery_status.sh
)

etcFiles=(
/etc/i3status.conf
/etc/libinput-gestures.conf
/etc/i3/
/etc/acpi/
)

systemdFiles=(
/etc/systemd/system/battery_status.timer
/etc/systemd/system/battery_status.service
)

dotConfig=(
~/.config/settings.ini
~/.config/mimeapps.list  
~/.config/i3
~/.config/dunst
~/.config/gtk-3.0/
~/.config/sxiv/
~/.config/rofi/
~/.config/polybar
~/.config/wallpaper-reddit
)

dotLocalApps=(
 ~/.local/share/applications/bc.desktop
)


function fix_wps_office_theme(){
    sudo sed -i 's/${gInstallPath}\/office6\/${gApp} ${gOptExt} ${gOpt} "$@"/GTK2_RC_FILES=\/usr\/share\/themes\/Adwaita\/gtk-2.0\/gtkrc ${gInstallPath}\/office6\/${gApp} ${gOptExt} ${gOpt} "$@"/' /usr/bin/et
    sudo sed -i 's/${gInstallPath}\/office6\/${gApp} ${gOptExt} ${gOpt} "$@"/GTK2_RC_FILES=\/usr\/share\/themes\/Adwaita\/gtk-2.0\/gtkrc ${gInstallPath}\/office6\/${gApp} ${gOptExt} ${gOpt} "$@"/' /usr/bin/wpp
    sudo sed -i 's/${gInstallPath}\/office6\/${gApp}  ${gOptExt} ${gOpt} "$@"/GTK2_RC_FILES=\/usr\/share\/themes\/Adwaita\/gtk-2.0\/gtkrc ${gInstallPath}\/office6\/${gApp} ${gOptExt} ${gOpt} "$@"/' /usr/bin/wps
}

function list_packages(){
    pacman -Qt | cut -d ' ' -f 1 > installed_packages.txt
}

function restore(){
    sudo cp -r ./etc/* /etc/
    sudo cp -r ./usr/* /usr/

    cp -rT ./home $HOME
    cp -r home/.SpaceVim.d/ ~/
    echo "Install SpaceVim via curl -sLf https://spacevim.org/install.sh | bash"

    fix_wps_office_theme
}

function backup(){
    rm -rf home etc usr
    mkdir -p etc usr/bin home home/.SpaceVim.d home/.local/

    cp -r $vim home/.SpaceVim.d/

    for file in "${files[@]}"
    do
        cp -r -p "$file" ./home/
    done

    mkdir -p  home/.config/
    for file in "${dotConfig[@]}"
    do
      cp -r -p "$file" ./home/.config/
    done

    mkdir -p home/.local/share/applications
    for file in "${dotLocalApps[@]}"
    do
        cp -r -p "$file" ./home/.local/share/applications
    done


    for file in "${etcFiles[@]}"
    do
        cp -r -p "$file" ./etc/
    done

    mkdir -p etc/systemd/system/
    for file in "${systemdFiles[@]}"
    do
        cp -r -p "$file" ./etc/systemd/system
    done

    for file in "${usrBinFiles[@]}"
    do
        cp -r -p "$file" ./usr/bin/
    done

    list_packages
}

function main(){

    if [ -z "$1" ]
    then
        echo "Please provide argument backup, restore or wps"
        exit
    fi

    if [ "$1" == "backup" ]
    then
        backup
    elif [ "$1" == "restore" ]
    then
        restore
    elif [ "$1" == "wps" ]
    then
        fix_wps_office_theme
    else
        echo arg invalid
    fi

    popd > /dev/null
}

main $1
