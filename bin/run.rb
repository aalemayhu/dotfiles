#!/usr/bin/env ruby -w
# frozen_string_literal: true

require_relative './create_directories'
require_relative './copy_files'
require_relative './clone_or_update'
require_relative './install_packages'

install_packages
create_directories(home, "#{File.dirname(__FILE__)}/../DirectoriesList")
synchronize_repositories
copy_files

vimrc = "#{home}/.vimrc"
File.symlink("#{home}/.vim/.vimrc", vimrc) unless File.exist?(vimrc)

system('vim', '+PluginInstall', '+qa!')
system('ssh-keygen', '-t', 'ed25519', '-C', 'a@alemayhu.com') unless File.exist?("#{home}/.ssh/id_ed25519")
