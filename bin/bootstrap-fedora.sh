#!/bin/sh

src=https://github.com/scanf/dotfiles/
dst=/tmp/dotfiles

dnf install -y git ruby make
dnf group install "C Development Tools and Libraries"

git clone $src $dst
cd $dst
make
