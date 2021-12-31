#!/usr/bin/env ruby -w

# frozen_string_literal: true

require_relative './distro'

remote_repository = 'https://github.com/scanf/dotfiles/'
local_repository = "#{Dir.home}/src/github.com/scanf/dotfiles"

if File.exist?(local_repository)
  puts "Already checked out #{local_repository}. Updating!"
  system("git -C #{local_repository} pull origin")
else
  puts "Checking out #{local_repository}"
  system("git clone #{remote_repository} #{local_repository}")
end

if debian?
  system('sudo apt-get install -y git ruby make locales')
elsif fedora?
  system('dnf install -y git ruby make ')
  system('sudo dnf C Development Tools and Libraries')
elsif darwin?
  system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
else
  puts 'fatal: unsupported system'
  exit 1
end

system("make -C #{local_repository}")
