#!/bin/bash

gicp() {
  GITHUB_USER=$(basename `pwd`)
  GITHUB_PROJECT=$1
  if [ ! -d "$GITHUB_PROJECT" ]; then
    echo Cloning $GITHUB_PROJECT
    git clone https://github.com/$GITHUB_USER/$GITHUB_PROJECT
  else
    echo There seems to already be directory named $GITHUB_PROJECT
    echo Updating instead.
    cd $GITHUB_PROJECT
    git pull
    cd ..
  fi
}

install_program() {
  echo Will be installing $1
  cd $GITHUB_ME
  gicp $1
  cd $GITHUB_ME/$1
  autoreconf -i
  ./configure
  $S make install
}

install_go() {
  cd $GITHUB_ME && gicp go
  cd go/src/ && git ch go1.4
  ./all.bash
}

create_directories() {
  mkdir -p $GITHUB_ME
  for d in `cat directories`; do
    mkdir -p $HOME/$d
  done
}

copy_config_files() {
  cp $CONFIG_FILES_DIR/ssh/config $HOME/.ssh/config
  cp $CONFIG_FILES_DIR/cantera/config $HOME/.cantera/

  cp $CONFIG_FILES_DIR/mutt/muttrc $HOME/.muttrc
  cp -r $CONFIG_FILES_DIR/mutt/mutt/* $HOME/.mutt/
  cp -r $CONFIG_FILES_DIR/mutt/mutt_files/* $HOME/.mutt_files/

  cp $CONFIG_FILES_DIR/db/psqlrc $HOME/.psqlrc

  cp $CONFIG_FILES_DIR/term/aliases $HOME/.term/.aliases
  cp $CONFIG_FILES_DIR/term/funcs $HOME/.term/.funcs
  cp $CONFIG_FILES_DIR/term/env $HOME/.term/.env

  cp $CONFIG_FILES_DIR/git/gitconfig $HOME/.gitconfig
  cp $CONFIG_FILES_DIR/git/git-completion.bash $HOME/.git-completion.bash

  cp $CONFIG_FILES_DIR/term/bashrc $HOME/.bashrc
  cp $CONFIG_FILES_DIR/term/lintianrc $HOME/.lintianrc

  cp $CONFIG_FILES_DIR/vim/vimrc $HOME/.vimrc

  cp $CONFIG_FILES_DIR/X/xbindkeysrc $HOME/.xbindkeysrc
  cp $CONFIG_FILES_DIR/X/xsession $HOME/.xsession
  cp $CONFIG_FILES_DIR/X/Xdefaults $HOME/.Xdefaults
  cp $CONFIG_FILES_DIR/X/Xmodmap $HOME/.Xmodmap
  cp $CONFIG_FILES_DIR/X/Xresources $HOME/.Xresources

  cd $GITHUB_ME
  gicp Vundle.vim
  cd $GITHUB_ME
  gicp liquidprompt

  cp $CONFIG_FILES_DIR/gnupg/gpg.conf $HOME/.gnupg/
}

install_stuff() {
  $S apt-get update
  $S apt-get upgrade -y

  $S apt-get install $(cat packages |tr '\n' ' ') -y
  install_program cantera-wm
  install_program cantera-term
  install_program cantera-lock

  install_go

  ANDROID_HOME=$LIBS/android-sdk-linux
  if [ ! -d "$ANDROID_HOME" ]; then
    curl -L http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz | tar xz -C $LIBS/
    echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter build-tools-19.1.0 && \
      echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter platform-tools && \
      echo y | $ANDROID_HOME/tools/android update sdk --no-ui --all --filter android-19
  fi

  # Install Android NDK.
  NDK_ROOT=$LIBS/android-ndk-r9d
  if [ ! -d "$NDK_ROOT" ]; then
    curl -L http://dl.google.com/android/ndk/android-ndk-r9d-linux-x86_64.tar.bz2 | tar xj -C $LIBS/
    $NDK_ROOT/build/tools/make-standalone-toolchain.sh --platform=android-9 --install-dir=$NDK_ROOT --system=linux-x86_64
  fi

  GRADLE=$LIBS/gradle-2.1
  if [ ! -d "$GRADLE" ]; then
    curl -L http://services.gradle.org/distributions/gradle-2.1-all.zip -o /tmp/gradle-2.1-all.zip && unzip /tmp/gradle-2.1-all.zip -d $LIBS && rm /tmp/gradle-2.1-all.zip
  fi

  $S apt-get dist-upgrade -y
  $S apt-get autoclean -y
  $S apt-get autoremove -y
}

init() {
  S=/usr/bin/sudo
  GITHUB_ME=$HOME/src/github.com/scanf
  CONFIG_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  LIBS=$HOME/libs
  if [ ! -d "$GITHUB_ME/config-files" ]; then
    cd $GITHUB_ME
    git clone https://github.com/scanf/config-files
    cd config-files
  fi
}

setup_ssh() {
  if [[ $1 == *setup* ]]; then
    install_stuff $1
    echo ssh-keygen -t rsa -C alexander@alemayhu.com
  fi
}

main() {
  init
  create_directories
  copy_config_files
  setup_ssh
}

main $1
