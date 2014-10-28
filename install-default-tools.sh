#!/bin/bash
install_linux() {
	apt-get install sudo vim git-core suckless-tools rxvt-unicode xbindkeys x-window-system make build-essential libpng12-dev libxrender-dev libx11-dev libxinerama-dev libfreetype6-dev libxxf86vm-dev libglu1-mesa-dev libxft-dev libglew-dev links chromium keepassx nicovideo-dl mplayer feh nitrogen scrot zathura xterm mutt console-data tig arandr autoconf automake autotools-dev debhelper dh-make devscripts fakeroot file gfortran git gnupg lintian patch patchutils pbuilder perl python quilt xutils-dev youtube-dl vym xclip apt-file htop screen i3 -y
}

install_osx() {
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install imagemagick
}

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
echo "Linux OS detected"
install_linux
elif [[ "$unamestr" == 'Darwin' ]]; then
echo "OS X detected"
install_osx
fi
