#!/bin/bash

CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
GITHUB_ME=$HOME/src/github.com/scanf
S=/usr/bin/sudo

$S $CONFIG_FILES_DIR/install_packages.rb
$CONFIG_FILES_DIR/create_directories.rb
$CONFIG_FILES_DIR/clone_or_update.rb
$CONFIG_FILES_DIR/copy_files.rb

ln -sf $HOME/.vim/vimrc $HOME/.vimrc
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
$CONFIG_FILES_DIR/install-extra.bash
