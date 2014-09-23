#!/bin/bash
/usr/bin/sudo ./install-default-tools.sh
./install-extra-tools
./place-config-files.sh

ssh-keygen -t rsa
