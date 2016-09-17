#!/bin/bash

VERSION=0
CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
GITHUB_ME=$HOME/src/github.com/scanf

/usr/bin/sudo $CONFIG_FILES_DIR/bin/install_packages.rb
$CONFIG_FILES_DIR/bin/create_directories.rb
$CONFIG_FILES_DIR/bin/clone_or_update.rb
$CONFIG_FILES_DIR/bin/copy_files.rb

ln -sf $HOME/.vim/.vimrc $HOME/.vimrc
ln -sf $HOME/.mutt/.muttrc $HOME/.muttrc
vim +PluginInstall +qa!

if [ ! -f $HOME/.msmtprc ]; then
  cp $CONFIG_FILES_DIR/msmtprc $HOME/.msmtprc
fi
if [ ! -f $HOME/.offlineimaprc ]; then
  cp $CONFIG_FILES_DIR/mutt/offlineimaprc $HOME/.offlineimaprc
fi

if [ ! -d "$HOME/.ssh" ]; then
  ssh-keygen -t rsa -C alexander@alemayhu.com
fi
