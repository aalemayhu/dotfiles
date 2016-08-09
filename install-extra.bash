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
  echo Will be installing $1
  cd $GITHUB_ROOT
  gicp $1
  cd $GITHUB_ROOT/$1
  autoreconf -i
  ./configure
  $S make install
}

main() {
  GITHUB_ROOT=$HOME/src/github.com
  clone_or_update mortehu cantera-wm
  clone_or_update mortehu cantera-term
  clone_or_update mortehu cantera-lock
  clone_or_update git git

  install_program cantera-wm
  install_program cantera-term
  install_program cantera-lock
  install_program git git
}

main $1
