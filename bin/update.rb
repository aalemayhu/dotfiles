#!/usr/bin/env ruby -w
# frozen_string_literal: true

require_relative './distro'

if debian?
  p 'Debian'
  p `sudo apt-get update`
  p `sudo apt-get upgrade -y`
  p `sudo apt-get autoclean`
  p `sudo apt-get autoremove`
  exit 0
elsif fedora?
  %w[update upgrade autoremove clean].each do |command|
    p `dnf #{command} -y`
  end
  p `dnf -y clean packages`
elsif darwin?
  p 'Darwin'
  p `brew update`
  p `brew outdated`
  p `brew upgrade`
  p `brew cleanup`
else
  puts 'fatal: unsupported system'
  exit 1
end
