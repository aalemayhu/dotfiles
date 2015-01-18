#!/bin/bash

sudo apt-get install git-core
repo_user_dir="$HOME/src/github.com/$(whoami)"
mkdir -p $repo_user_dir
cd $repo_user_dir
git clone https://github.com/scanf/config-files 
cd config-files
./setup.bash setup
