#!/bin/sh

echo "Creating default directories."

mkdir -p $HOME/.cantera
mkdir -p $HOME/.gnupg
mkdir -p $HOME/.vim
mkdir -p $HOME/Documents
mkdir -p $HOME/Downloads
mkdir -p $HOME/Movies
mkdir -p $HOME/Music
mkdir -p $HOME/Pictures
mkdir -p $HOME/libs
mkdir -p $HOME/opt
mkdir -p $HOME/opt/og
mkdir -p $HOME/src

echo "Placing configuration files."

CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

cp $CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
cp $CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash

cp $CONFIG_FILES_DIR/term/bashrc $HOME/.bashrc
cp $CONFIG_FILES_DIR/term/lintianrc $HOME/.lintianrc

cp $CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc
cp -r $CONFIG_FILES_DIR/vim/syntax $HOME/.vim/syntax

git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

cp $CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/

echo "Done."
