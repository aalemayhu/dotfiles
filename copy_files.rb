#!/usr/bin/ruby

CONFIG_FILES_DIR=File.dirname(__FILE__)
HOME=ENV['HOME']

# mutt
`cp #{CONFIG_FILES_DIR}/mutt/colors #{HOME}/.mutt/colors`
`cp #{CONFIG_FILES_DIR}/mutt/muttrc #{HOME}/.muttrc`
`cp #{CONFIG_FILES_DIR}/mutt/signature #{HOME}/.signature`
`cp -r #{CONFIG_FILES_DIR}/mutt/mutt/* #{HOME}/.mutt/`
`cp -r #{CONFIG_FILES_DIR}/mutt/mutt_files/* #{HOME}/.mutt_files/`
`cp -r #{CONFIG_FILES_DIR}/vim/syntax #{HOME}/.vim/syntax`

# X11

`cp #{CONFIG_FILES_DIR}/X/xbindkeysrc #{HOME}/.xbindkeysrc`
`cp #{CONFIG_FILES_DIR}/X/xsession #{HOME}/.xsession`
`cp #{CONFIG_FILES_DIR}/X/Xdefaults #{HOME}/.Xdefaults`
`cp #{CONFIG_FILES_DIR}/X/Xmodmap #{HOME}/.Xmodmap`
`cp #{CONFIG_FILES_DIR}/X/Xresources #{HOME}/.Xresources`

# Shell
`cp #{CONFIG_FILES_DIR}/shell/aliases #{HOME}/.shell/.aliases`
`cp #{CONFIG_FILES_DIR}/shell/bashrc #{HOME}/.bashrc`
`cp #{CONFIG_FILES_DIR}/shell/env #{HOME}/.shell/.env`
`cp #{CONFIG_FILES_DIR}/shell/funcs #{HOME}/.shell/.funcs`
`cp #{CONFIG_FILES_DIR}/shell/tmux.conf #{HOME}/.tmux.conf`

# Misc
`cp #{CONFIG_FILES_DIR}/cantera/config #{HOME}/.cantera/`
`cp #{CONFIG_FILES_DIR}/gnupg/gpg.conf #{HOME}/.gnupg/`
`cp #{CONFIG_FILES_DIR}/ssh/config #{HOME}/.ssh/config`
`cp #{CONFIG_FILES_DIR}/vim/vimrc #{HOME}/.vimrc`

# Git
`cp #{CONFIG_FILES_DIR}/git/git-completion.bash #{HOME}/.git-completion.bash`
`cp #{CONFIG_FILES_DIR}/git/gitconfig #{HOME}/.gitconfig`