#!/usr/bin/ruby

unamestr = `uname`.strip
if unamestr.start_with?('Linux')
  `apt-get update`
  `apt-get install git vim`
  file='PackagesList'
  File.readlines(file).each do |package|
    "apt-get instal -y #{package}"
  end
  `apt-get autoremove`
  `apt-get autoclean`
  `locale-gen "en_US.UTF-8"`
  `cd #{ENV['Home']}/src/github.com/scanf/xcd.rb && /usr/bin/sudo make install`
end
