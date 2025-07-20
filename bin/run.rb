#!/usr/bin/env ruby -w
# frozen_string_literal: true

require_relative './create_directories'
require_relative './copy_files'
require_relative './clone_or_update'
require_relative './install_packages'

home = Dir.home
remote_repository = 'https://github.com/scanf/dotfiles/'
local_repository = "#{home}/src/github.com/scanf/dotfiles"
if File.exist?(local_repository)
  puts "Already checked out #{local_repository}. Updating!"
  system("git -C #{local_repository} pull origin")
else
  puts "Checking out #{local_repository}"
  system("git clone #{remote_repository} #{local_repository}")
end

install_packages
create_directories(home, "#{File.dirname(__FILE__)}/../DirectoriesList")
synchronize_repositories
copy_files

vimrc = "#{home}/.vimrc"
File.symlink("#{home}/.vim/.vimrc", vimrc) unless File.exist?(vimrc)

system('vim', '+PluginInstall', '+qa!')
system('ssh-keygen', '-t', 'ed25519', '-C', 'a@alemayhu.com') unless File.exist?("#{home}/.ssh/id_ed25519")
