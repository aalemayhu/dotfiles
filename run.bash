#!/bin/bash

create_directories() {
  mkdir -p $GITHUB_ME
  for d in `cat $CONFIG_FILES_DIR/DirectoriesList`; do
    mkdir -p $HOME/$d
  done
}

copy_files() {
  
  # mutt 
  cp $CONFIG_FILES_DIR/mutt/colors $HOME/.mutt/colors
  cp $CONFIG_FILES_DIR/mutt/muttrc $HOME/.muttrc
  cp $CONFIG_FILES_DIR/mutt/signature $HOME/.signature
  cp -r $CONFIG_FILES_DIR/mutt/mutt/* $HOME/.mutt/
  cp -r $CONFIG_FILES_DIR/mutt/mutt_files/* $HOME/.mutt_files/
  cp -r $CONFIG_FILES_DIR/vim/syntax $HOME/.vim/syntax

  # X11

  cp $CONFIG_FILES_DIR/X/xbindkeysrc $HOME/.xbindkeysrc
  cp $CONFIG_FILES_DIR/X/xsession $HOME/.xsession
  cp $CONFIG_FILES_DIR/X/Xdefaults $HOME/.Xdefaults
  cp $CONFIG_FILES_DIR/X/Xmodmap $HOME/.Xmodmap
  cp $CONFIG_FILES_DIR/X/Xresources $HOME/.Xresources

  # Shell
  cp $CONFIG_FILES_DIR/shell/aliases $HOME/.shell/.aliases
  cp $CONFIG_FILES_DIR/shell/bashrc $HOME/.bashrc
  cp $CONFIG_FILES_DIR/shell/env $HOME/.shell/.env
  cp $CONFIG_FILES_DIR/shell/funcs $HOME/.shell/.funcs
  cp $CONFIG_FILES_DIR/shell/tmux.conf $HOME/.tmux.conf

  # Misc
  cp $CONFIG_FILES_DIR/cantera/config $HOME/.cantera/
  cp $CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/
  cp $CONFIG_FILES_DIR/ssh/config $HOME/.ssh/config
  cp $CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc

  vim +PluginInstall +qa!

  # Git
  cp $CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash
  cp $CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
}

install_packages() {
  unamestr=`uname`
  if [[ "$unamestr" == 'Linux' ]]; then
    $S apt-get update
    $S apt-get install git vim
    for p in $(cat $CONFIG_FILES_DIR/PackagesList);
    do
      $S apt-get install -y $p
    done
    $S apt-get autoremove
    $S apt-get autoclean
    $S locale-gen "en_US.UTF-8"
  fi
}

configure() {
  S=/usr/bin/sudo
  GITHUB_ME=$HOME/src/github.com/scanf
  CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  echo "configure() {"
  echo "    CONFIG_FILES_DIR=$CONFIG_FILES_DIR"
  echo "    GITHUB_ME=$GITHUB_ME"
  echo "    S=$S"
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

install_X_desktop_essentials() {
  $CONFIG_FILES_DIR/install-extra.bash
}
main() {
  configure
  install_packages
  create_directories
  clone_or_update
  copy_files
  if [ ! -d "$HOME/.ssh" ]; then
    ssh-keygen -t rsa -C alexander@alemayhu.com
  fi
  if ! xset q &>/dev/null; then
    exit
  fi
  echo "X server detected at \$DISPLAY [$DISPLAY]" >&2
  install_X_desktop_essentials
}

main
