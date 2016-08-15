#!/bin/bash

create_directories() {
  mkdir -p $GITHUB_ME
  for d in `cat $CONFIG_FILES_DIR/DirectoriesList`; do
    mkdir -p $HOME/$d
  done
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


install_X_desktop_essentials() {
  $CONFIG_FILES_DIR/install-extra.bash
}
main() {
  configure
  $S $CONFIG_FILES_DIR/install_packages.rb
  create_directories
  $CONFIG_FILES_DIR/clone_or_update.rb
  $CONFIG_FILES_DIR/copy_files.rb

  vim +PluginInstall +qa!

  cd $GITHUB_ME/xcd.rb
  $S make install

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
