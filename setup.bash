#!/bin/bash

CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

install_linux_extra() {

  S=/usr/bin/sudo

  $S apt-get update
  $S apt-get autoclean
  $S apt-get autoremove

  for package in $(cat packages); do
    $S apt-get install $package
  done
}

install_osx_extra() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  for prog in $(cat beverage); do
    brew install $prog
  done

  cp $CONFIG_FILES_DIR/term/bash_profile $HOME/.bash_profile
  cp $CONFIG_FILES_DIR/term/profile $HOME/.profile
  curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
}

copy_config_files() {
  echo "Creating default directories."

  mkdir -p $HOME/.ssh
  mkdir -p $HOME/.cantera
  mkdir -p $HOME/.gnupg
  mkdir -p $HOME/.mutt
  mkdir -p $HOME/.mutt_files
  mkdir -p $HOME/.vim
  mkdir -p $HOME/Documents
  mkdir -p $HOME/Downloads
  mkdir -p $HOME/Movies
  mkdir -p $HOME/Music
  mkdir -p $HOME/Pictures
  mkdir -p $HOME/libs
  mkdir -p $HOME/opt
  mkdir -p $HOME/opt/og
  mkdir -p $HOME/src/bitbucket.org
  mkdir -p $HOME/src/github.com
  mkdir -p $HOME/src/tmp

  echo "Placing configuration files."

  cp $CONFIG_FILES_DIR/ssh/config $HOME/.ssh/config

  cp $CONFIG_FILES_DIR/mutt/muttrc $HOME/.muttrc
  cp -r $CONFIG_FILES_DIR/mutt/mutt/* $HOME/.mutt/
  cp -r $CONFIG_FILES_DIR/mutt/mutt_files/* $HOME/.mutt_files/

  cp $CONFIG_FILES_DIR/db/psqlrc $HOME/.psqlrc

  cp $CONFIG_FILES_DIR/term/aliases $HOME/.aliases
  cp $CONFIG_FILES_DIR/term/funcs $HOME/.funcs
  cp $CONFIG_FILES_DIR/term/env $HOME/.env

  cp $CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
  cp $CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash

  cp $CONFIG_FILES_DIR/term/zshrc $HOME/.zshrc
  cp $CONFIG_FILES_DIR/term/bashrc $HOME/.bashrc
  cp $CONFIG_FILES_DIR/term/lintianrc $HOME/.lintianrc

  cp $CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc

  git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

  mkdir -p $HOME/github/nojhan

  git clone https://github.com/nojhan/liquidprompt.git $HOME/src/github/nojhan/liquidprompt.git

  cp $CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/

  cp -r $CONFIG_FILES_DIR/i3 $HOME/.i3

  echo "Done."
}

install_stuff() {
  if [[ $1 == *setup* ]]; then
    curl -L http://install.ohmyz.sh | sh
    unamestr=`uname`
    if [[ "$unamestr" == 'Linux' ]]; then
      echo "Linux OS detected"
      install_linux_extra $1
    elif [[ "$unamestr" == 'Darwin' ]]; then
      echo "OS X detected"
      install_osx_extra
    fi
    if [ ! -d "$HOME/.ssh" ]; then
      ssh-keygen -t rsa -C "alexander.alemayhu@googlemail.com"
    fi
  fi
}

main() {
  install_stuff $1
  copy_config_files
}

main $1
