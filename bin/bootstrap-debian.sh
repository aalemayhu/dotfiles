#!/bin/sh

src=https://github.com/scanf/config-files/
dst=/tmp/config-files

apt-get install -y git ruby make
git clone $src $dst
cd $dst
make
