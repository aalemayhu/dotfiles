#!/bin/bash
./install-default-tools.sh 
./install-extra-tools
./mk-default-directory.sh 
./place-config-files.sh 
ssh-keygen -t rsa
