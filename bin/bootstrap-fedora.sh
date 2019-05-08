#!/bin/sh

src=https://github.com/scanf/dotfiles/
dst=/tmp/dotfiles

sudo dnf install -y git ruby make
sudo dnf group install "C Development Tools and Libraries"

git clone $src $dst
cd $dst
make
