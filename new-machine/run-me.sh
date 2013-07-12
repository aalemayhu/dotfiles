#!/bin/bash
sudo ./install-default-tools.sh && ./mk-default-directory.sh && ./place-config-files.sh && ssh-keygen -t rsa
