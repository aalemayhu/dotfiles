#!/bin/sh

echo "Creating default directories."

mkdir -p "$HOME"src
mkdir -p "$HOME"Documents
mkdir -p "$HOME"Downloads
mkdir -p "$HOME"Pictures
mkdir -p "$HOME"Music
mkdir -p "$HOME"Movies 
mkdir -p "$HOME"libs
mkdir -p "$HOME".cantera
mkdir -p "$HOME".gnupg

echo "Placing configuration files."

cp "$HOME"src/config-files/git/gitconfig "$HOME".gitconfig 
cp "$HOME"src/config-files/term/bashrc "$HOME".bashrc 

cp "$HOME"src/config-files/vim/vimrc "$HOME".vimrc 
mkdir -p "$HOME".vim
cp -r "$HOME"src/config-files/vim/syntax "$HOME".vim/syntax 

cp "$HOME".gnupg/gpg.conf ~/.gnupg/
