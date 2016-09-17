#!/usr/bin/ruby

CONFIG_FILES_DIR="#{File.dirname(__FILE__)}/.."
HOME=ENV['HOME']

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
`chmod 600 #{HOME}/.ssh/config`

# Git
`cp #{CONFIG_FILES_DIR}/git/git-completion.bash #{HOME}/.git-completion.bash`
`cp #{CONFIG_FILES_DIR}/git/gitconfig #{HOME}/.gitconfig`
