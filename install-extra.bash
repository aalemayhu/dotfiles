#!/bin/bash

clone_or_update() {
  GITHUB_USER=$1
  GITHUB_PROJECT=$2
  EXPECTED_PATH=$GITHUB_ROOT/$GITHUB_USER/$GITHUB_PROJECT
  if [ ! -d "$EXPECTED_PATH" ]; then
    echo Cloning $GITHUB_PROJECT
    git clone https://github.com/$GITHUB_USER/$GITHUB_PROJECT $EXPECTED_PATH
  else
    echo There seems to already be directory named $GITHUB_PROJECT
    echo Updating instead.
    cd $EXPECTED_PATH
    git pull
    cd ..
  fi
}

install_program() {
  GITHUB_USER=$1
  GITHUB_PROJECT=$2
  EXPECTED_PATH=$GITHUB_ROOT/$GITHUB_USER/$GITHUB_PROJECT
  echo Will be installing $GITHUB_PROJECT
  cd $EXPECTED_PATH
  autoreconf -i
  ./configure
  $S make -j install
  cd -
}

main() {
  S=/usr/bin/sudo
  GITHUB_ROOT=$HOME/src/github.com
  clone_or_update mortehu cantera-wm
  clone_or_update mortehu cantera-term
  clone_or_update mortehu cantera-lock
  clone_or_update git git

  install_program mortehu cantera-wm
  install_program mortehu cantera-term
  install_program mortehu cantera-lock
  install_program git git

  $S apt-get install unclutter
}

main $1
