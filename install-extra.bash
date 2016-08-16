#!/bin/bash

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

  install_program mortehu cantera-wm
  install_program mortehu cantera-term
  install_program mortehu cantera-lock
  install_program git git
  $S apt-get install tuxmath
}

main $1