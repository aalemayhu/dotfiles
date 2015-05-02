#!/bin/bash

gicp() {
  GITHUB_USER=$(basename `pwd`)
  GITHUB_PROJECT=$1
  if [ ! -d "$GITHUB_PROJECT" ]; then
    echo Cloning $GITHUB_PROJECT
    git clone https://github.com/$GITHUB_USER/$GITHUB_PROJECT
  else
    echo There seems to already be directory named $GITHUB_PROJECT
    echo Updating instead.
    cd $GITHUB_PROJECT
    git pull
    cd ..
  fi
}


create_directories() {
  mkdir -p $GITHUB_ME
  for d in `cat directories`; do
    mkdir -p $HOME/$d
  done
}

copy_config_files() {
  cp $CONFIG_FILES_DIR/ssh/config $HOME/.ssh/config

  cp $CONFIG_FILES_DIR/mutt/muttrc $HOME/.muttrc
  cp -r $CONFIG_FILES_DIR/mutt/mutt/* $HOME/.mutt/
  cp -r $CONFIG_FILES_DIR/mutt/mutt_files/* $HOME/.mutt_files/
  cp $CONFIG_FILES_DIR/mutt/signature $HOME/.signature
  cp $CONFIG_FILES_DIR/mutt/offlineimaprc $HOME/.offlineimaprc

  cp $CONFIG_FILES_DIR/db/psqlrc $HOME/.psqlrc

  cp $CONFIG_FILES_DIR/term/aliases $HOME/.term/.aliases
  cp $CONFIG_FILES_DIR/term/funcs $HOME/.term/.funcs
  cp $CONFIG_FILES_DIR/term/env $HOME/.term/.env

  cp $CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
  cp $CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash

  cp $CONFIG_FILES_DIR/term/bashrc $HOME/.bashrc
  cp $CONFIG_FILES_DIR/term/lintianrc $HOME/.lintianrc

  cp $CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc

  cp $CONFIG_FILES_DIR/X/xbindkeysrc $HOME/.xbindkeysrc
  cp $CONFIG_FILES_DIR/X/xsession $HOME/.xsession
  cp $CONFIG_FILES_DIR/X/Xdefaults $HOME/.Xdefaults
  cp $CONFIG_FILES_DIR/X/Xmodmap $HOME/.Xmodmap
  cp $CONFIG_FILES_DIR/X/Xresources $HOME/.Xresources

  cd $GITHUB_ME
  gicp Vundle.vim
  cd $GITHUB_ME

  cp $CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/
  cp $CONFIG_FILES_DIR/jrnl_config $HOME/.jrnl_config
}

install_packages() {
  for p in $(cat $CONFIG_FILES_DIR/packages);
  do
    $S apt install -y
  done
}

install_extra() {
  install_packages
}

init() {
  S=/usr/bin/sudo
  GITHUB_ME=$HOME/src/github.com/scanf
  CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  LIBS=$HOME/libs
  if [ ! -d "$GITHUB_ME/config-files" ]; then
    cd $GITHUB_ME
    git clone https://github.com/scanf/config-files
    cd config-files
  fi
}

extras() {
  if [[ $1 == *setup* ]]; then
    install_extra
    echo ssh-keygen -t rsa -C alexander@alemayhu.com
  fi
}

main() {
  init
  create_directories
  copy_config_files
  extras $1
}

main $1
