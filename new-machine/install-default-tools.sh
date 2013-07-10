#!/bin/sh
apt-get install sudo vim git-core suckless-tools rxvt-unicode xbindkeys x-window-system make autoconf build-essential libpng12-dev libxrender-dev libx11-dev libxinerama-dev libfreetype6-dev libxxf86vm-dev libglu1-mesa-dev libxft-dev libglew-dev links chromium-browser keepassx nicovideo-dl zathura xterm alpine-y console-data && cd /home/ccscanf/src && git clone https://github.com/scanf/hest.git && cd hest/ && autoreconf -i && ./configure && make && make install && cd /home/ccscanf/src && git clone https://github.com/scanf/cantera-lock.git && cd cantera-lock/ && autoreconf -i && ./configure && make && make install && cd /home/ccscanf/src && git clone https://github.com/mortehu/cantera-term && cd cantera-term/ && autoreconf -i && ./configure && make && make install


