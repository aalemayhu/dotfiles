# frozen_string_literal: true

def fedora?
  File.exist?('/usr/bin/dnf')
end

def debian?
  File.exist?('/usr/bin/apt-get')
end

def darwin?
  `uname`.include?('Darwin')
end

def windows?
  RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
end

def wsl?
  return false unless File.exist?('/proc/version')
  File.read('/proc/version').include?('Microsoft') || File.read('/proc/version').include?('WSL')
end
