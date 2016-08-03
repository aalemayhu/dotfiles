#!/bin/bash

create_directories() {
  mkdir -p $GITHUB_ME
  for d in `cat all/directories`; do
    mkdir -p $HOME/$d
  done
}

copy_config_files() {
 
  ALL_CONFIG_FILES_DIR=$CONFIG_FILES_DIR/all

  cp $ALL_CONFIG_FILES_DIR/ssh/config $HOME/.ssh/config
  cp $ALL_CONFIG_FILES_DIR/mutt/muttrc $HOME/.muttrc
  cp -r $ALL_CONFIG_FILES_DIR/mutt/mutt/* $HOME/.mutt/
  cp -r $ALL_CONFIG_FILES_DIR/mutt/mutt_files/* $HOME/.mutt_files/
  cp $ALL_CONFIG_FILES_DIR/mutt/signature $HOME/.signature

  if [ ! -f $HOME/.offlineimaprc ]; then
    cp $ALL_CONFIG_FILES_DIR/mutt/offlineimaprc $HOME/.offlineimaprc
  fi
  cp $ALL_CONFIG_FILES_DIR/mutt/colors $HOME/.mutt/colors

  cp $ALL_CONFIG_FILES_DIR/term/aliases $HOME/.term/.aliases
  cp $ALL_CONFIG_FILES_DIR/term/funcs $HOME/.term/.funcs
  cp $ALL_CONFIG_FILES_DIR/term/env $HOME/.term/.env
  cp $ALL_CONFIG_FILES_DIR/term/tmux.conf $HOME/.tmux.conf

  cp $ALL_CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
  cp $ALL_CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash

  cp $ALL_CONFIG_FILES_DIR/term/bashrc $HOME/.bashrc

  cp $ALL_CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc

  cd $HOME/src/github.com/VundleVim
  if [ ! -d "Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git
  fi

  cp $ALL_CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/
}

install_packages() {
  for p in $(cat $CONFIG_FILES_DIR/all/packages);
  do
    $S apt install -y $p
  done
}

install_extra() {
  install_packages
}

init() {
  S=/usr/bin/sudo
  GITHUB_ME=$HOME/src/github.com/scanf
  CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
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
