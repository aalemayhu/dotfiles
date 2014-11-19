#!/bin/bash

CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

linux_default_tools_server() {
  apt-get install sudo vim git-core suckless-tools rxvt-unicode make build-essential libpng12-dev libfreetype6-dev links console-data tig autoconf automake autotools-dev debhelper dh-make devscripts fakeroot file gfortran git gnupg lintian patch patchutils pbuilder perl python quilt xutils-dev vym xclip apt-file htop screen -y
}

linux_default_tools_user() {
  apt-get install sudo vim git-core suckless-tools rxvt-unicode xbindkeys x-window-system make build-essential libpng12-dev libxrender-dev libx11-dev libxinerama-dev libfreetype6-dev libxxf86vm-dev libglu1-mesa-dev libxft-dev libglew-dev links chromium keepassx nicovideo-dl mplayer feh nitrogen scrot zathura xterm mutt console-data tig arandr autoconf automake autotools-dev debhelper dh-make devscripts fakeroot file gfortran git gnupg lintian patch patchutils pbuilder perl python quilt xutils-dev youtube-dl vym xclip apt-file htop screen i3 -y
}

install_linux() {

  if [[ "$1" == "" ]]
  then
    print_usage
    exit
  fi

  # TODO: Merge linux_default_tools_server and linux_default_tools_user
  if [[ "$1" == "user" ]]
  then
    linux_default_tools_user
  elif [[ "$1" == "server" ]]
  then
    linux_default_tools_server
  else
    echo Nothing todo for $1
    exit
  fi
}

install_osx() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  brew install imagemagick wget youtube-dl
  cp $CONFIG_FILES_DIR/term/bash_profile $HOME/.bash_profile
  cp $CONFIG_FILES_DIR/term/profile $HOME/.profile
  curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
}



print_usage() {
  echo "Please add an argument!"
  echo "user or server"
}

copy_config_files() {
  echo "Creating default directories."

  mkdir -p $HOME/.cantera
  mkdir -p $HOME/.gnupg
  mkdir -p $HOME/.vim
  mkdir -p $HOME/Documents
  mkdir -p $HOME/Downloads
  mkdir -p $HOME/Movies
  mkdir -p $HOME/Music
  mkdir -p $HOME/Pictures
  mkdir -p $HOME/libs
  mkdir -p $HOME/opt
  mkdir -p $HOME/opt/og
  mkdir -p $HOME/src

  echo "Placing configuration files."


  cp $CONFIG_FILES_DIR/db/psqlrc $HOME/.psqlrc

  cp $CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
  cp $CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash

  cp $CONFIG_FILES_DIR/term/bashrc $HOME/.bashrc
  cp $CONFIG_FILES_DIR/term/lintianrc $HOME/.lintianrc

  cp $CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc
  cp -r $CONFIG_FILES_DIR/vim/syntax $HOME/.vim/syntax

  git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

  mkdir -p $HOME/github/nojhan

  git clone https://github.com/nojhan/liquidprompt.git $HOME/src/github/nojhan/liquidprompt.git

  cp $CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/

  cp -r $CONFIG_FILES_DIR/i3 $HOME/.i3

  echo "Done."
}

main() {

  if [[ $1 == *setup* ]]; then
    unamestr=`uname`
    if [[ "$unamestr" == 'Linux' ]]; then
      echo "Linux OS detected"
      install_linux $1
    elif [[ "$unamestr" == 'Darwin' ]]; then
      echo "OS X detected"
      install_osx
    fi
    if [ ! -d "$HOME/.ssh" ]; then
      ssh-keygen -t rsa -C "alexander.alemayhu@googlemail.com"
    fi

  fi

  copy_config_files
}

main $1
