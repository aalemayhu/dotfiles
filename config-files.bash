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
  for d in `cat all/directories`; do
    mkdir -p $HOME/$d
  done
}

copy_config_files() {
  cp $CONFIG_FILES_DIR/all/ssh/config $HOME/.ssh/config
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
}

install_go() {
  cd $GITHUB_ME && gicp go
  cd go/src/ && git ch go1.4
  ./all.bash
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

  if ! [ -x "$(command -v brew)" ]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew install the_silver_searcher
  fi
}

main() {
  init
  create_directories
  copy_config_files
  extras $1
}

main $1
