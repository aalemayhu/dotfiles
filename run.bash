#!/bin/bash

create_directories() {
  mkdir -p $GITHUB_ME
  for d in `cat all/directories`; do
    mkdir -p $HOME/$d
  done
}

copy_files() {


  cp $ALL_CONFIG_FILES_DIR/ssh/config $HOME/.ssh/config
  cp $ALL_CONFIG_FILES_DIR/mutt/muttrc $HOME/.muttrc
  cp -r $ALL_CONFIG_FILES_DIR/mutt/mutt/* $HOME/.mutt/
  cp -r $ALL_CONFIG_FILES_DIR/mutt/mutt_files/* $HOME/.mutt_files/
  cp $ALL_CONFIG_FILES_DIR/mutt/signature $HOME/.signature

  cp $ALL_CONFIG_FILES_DIR/mutt/colors $HOME/.mutt/colors

  cp $ALL_CONFIG_FILES_DIR/term/aliases $HOME/.term/.aliases
  cp $ALL_CONFIG_FILES_DIR/term/funcs $HOME/.term/.funcs
  cp $ALL_CONFIG_FILES_DIR/term/env $HOME/.term/.env
  cp $ALL_CONFIG_FILES_DIR/term/tmux.conf $HOME/.tmux.conf

  cp $ALL_CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
  cp $ALL_CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash

  cp $ALL_CONFIG_FILES_DIR/term/bashrc $HOME/.bashrc

  cp $ALL_CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc


  cp $ALL_CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/
}

install_packages() {
  for p in $(cat $CONFIG_FILES_DIR/all/packages);
  do
    $S aptitude install -y $p
  done
}

configure() {
  S=/usr/bin/sudo
  GITHUB_ME=$HOME/src/github.com/scanf
  CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  ALL_CONFIG_FILES_DIR=$CONFIG_FILES_DIR/all
  echo "configure() {"
  echo "    S=$S"
  echo "    GITHUB_ME=$GITHUB_ME"
  echo "    CONFIG_FILES_DIR=$CONFIG_FILES_DIR"
  echo "    ALL_CONFIG_FILES_DIR=$ALL_CONFIG_FILES_DIR"
  echo "}"
}

clone_or_update() {
  if [ ! -d "$GITHUB_ME/config-files" ]; then
    cd $GITHUB_ME
    git clone https://github.com/scanf/config-files
    cd config-files
  else
    cd $CONFIG_FILES_DIR
    git pull
    cd -
  fi
  cd $HOME/src/github.com/VundleVim
  if [ ! -d "Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git
  else
    cd Vundle.vim
    git pull
  fi
}

main() {
  configure
  clone_or_update
  create_directories
  copy_files
  install_packages
  if [ ! -d "$HOME/.ssh" ]; then
    ssh-keygen -t rsa -C alexander@alemayhu.com
  fi
}

main $1
