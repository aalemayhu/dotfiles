#!/usr/bin/ruby

CONFIG_FILES_DIR="#{File.dirname(__FILE__)}/.."
HOME=ENV['HOME']

# Shell
`cp #{CONFIG_FILES_DIR}/shell/aliases #{HOME}/.shell/.aliases`
`cp #{CONFIG_FILES_DIR}/shell/bashrc #{HOME}/.bashrc`
`cp #{CONFIG_FILES_DIR}/shell/env #{HOME}/.shell/.env`
`cp #{CONFIG_FILES_DIR}/shell/funcs #{HOME}/.shell/.funcs`
`cp #{CONFIG_FILES_DIR}/shell/tmux.conf #{HOME}/.tmux.conf`

if `uname`.strip.start_with?('Darwin')
`cp #{CONFIG_FILES_DIR}/term/bash_profile #{HOME}/.bash_profile`
end

# Misc
`cp #{CONFIG_FILES_DIR}/gnupg/gpg.conf #{HOME}/.gnupg/`
`cp #{CONFIG_FILES_DIR}/ssh/config #{HOME}/.ssh/config`
`chmod 600 #{HOME}/.ssh/config`

# Git
`cp #{CONFIG_FILES_DIR}/git/git-completion.bash #{HOME}/.git-completion.bash`
`cp #{CONFIG_FILES_DIR}/git/gitconfig #{HOME}/.gitconfig`