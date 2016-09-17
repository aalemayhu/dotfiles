#!/bin/bash

VERSION=0
BIN_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
GITHUB_ME=$HOME/src/github.com/scanf

/usr/bin/sudo $BIN_DIRECTORY/install_packages.rb
$BIN_DIRECTORY/create_directories.rb
$BIN_DIRECTORY/clone_or_update.rb
$BIN_DIRECTORY/copy_files.rb

ln -sf $HOME/.vim/.vimrc $HOME/.vimrc
ln -sf $HOME/.mutt/.muttrc $HOME/.muttrc
vim +PluginInstall +qa!

if [ ! -d "$HOME/.ssh" ]; then
  ssh-keygen -t rsa -C alexander@alemayhu.com
fi
