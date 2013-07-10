#!/bin/sh

cp ~/src/config-files/git/gitconfig ~/.gitconfig &&
cp ~/src/config-files/term/bashrc ~/.bashrc &&

cp ~/src/config-files/vim/vimrc ~/.vimrc &&
mkdir ~/.vim && cp -r ~/src/config-files/vim/syntax ~/.vim/syntax &&
cp ~/src/config-files/term/config ~/.cantera/config


cp ~/src/config-files/X/xbindkeysrc ~/.xbindkeysrc &&
cp ~/src/config-files/X/Xdefaults ~/.Xdefaults &&
cp ~/src/config-files/X/xsession ~/.xsession 
