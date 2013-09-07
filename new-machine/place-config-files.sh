#!/bin/sh

HOMEDIR=/home/ccscanf/

echo "Creating default directories."

mkdir -p ~/src &&
mkdir -p ~/Documents &&
mkdir -p ~/Downloads &&
mkdir -p ~/Pictures &&
mkdir -p ~/Music &&
mkdir -p ~/Movies 

echo "Placing configuration files."

cp $HOMEDIR/src/config-files/git/gitconfig $HOMEDIR/.gitconfig 
cp $HOMEDIR/src/config-files/term/bashrc $HOMEDIR/.bashrc 

cp $HOMEDIR/src/config-files/vim/vimrc $HOMEDIR/.vimrc 
mkdir $HOMEDIR/.vim  
cp -r $HOMEDIR/src/config-files/vim/syntax $HOMEDIR/.vim/syntax 
mkdir $HOMEDIR/.cantera
cp $HOMEDIR/src/config-files/term/config $HOMEDIR/.cantera/config

cp $HOMEDIR/src/config-files/X/xbindkeysrc $HOMEDIR/.xbindkeysrc 
cp $HOMEDIR/src/config-files/X/Xdefaults $HOMEDIR/.Xdefaults 
cp $HOMEDIR/src/config-files/X/xsession $HOMEDIR/.xsession 
