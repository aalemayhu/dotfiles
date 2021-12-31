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
