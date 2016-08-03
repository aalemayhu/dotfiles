#!/bin/bash

create_directories() {
  mkdir -p $GITHUB_ME
  for d in `cat all/directories`; do
    mkdir -p $HOME/$d
  done
}

copy_config_files() {
  
  cp $CONFIG_FILES_DIR/all/ssh/config $HOME/.ssh/config
  cp $CONFIG_FILES_DIR/all/mutt/muttrc $HOME/.muttrc
  cp -r $CONFIG_FILES_DIR/all/mutt/mutt/* $HOME/.mutt/
  cp -r $CONFIG_FILES_DIR/all/mutt/mutt_files/* $HOME/.mutt_files/
  cp $CONFIG_FILES_DIR/all/mutt/signature $HOME/.signature

  if [ ! -f $HOME/.offlineimaprc ]; then
    cp $CONFIG_FILES_DIR/all/mutt/offlineimaprc $HOME/.offlineimaprc
  fi
  cp $CONFIG_FILES_DIR/all/mutt/colors $HOME/.mutt/colors

  cp $CONFIG_FILES_DIR/all/term/aliases $HOME/.term/.aliases
  cp $CONFIG_FILES_DIR/all/term/funcs $HOME/.term/.funcs
  cp $CONFIG_FILES_DIR/all/term/env $HOME/.term/.env
  cp $CONFIG_FILES_DIR/all/term/tmux.conf $HOME/.tmux.conf

  cp $CONFIG_FILES_DIR/all/git/gitconfig $HOME/.gitconfig
  cp $CONFIG_FILES_DIR/all/git/git-completion.bash $HOME/.git-completion.bash

  cp $CONFIG_FILES_DIR/all/term/bashrc $HOME/.bashrc

  cp $CONFIG_FILES_DIR/all/vim/vimrc $HOME/.vimrc

  cd $HOME/src/github.com/VundleVim
  if [ ! -d "Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git
  fi

  cp $CONFIG_FILES_DIR/all/gnupg/gpg.conf $HOME/.gnupg/
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
