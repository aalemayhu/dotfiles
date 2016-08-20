#!/usr/bin/ruby

unamestr = `uname`.strip
if unamestr.start_with?('Linux')
  system('apt-get update')
  system('apt-get install git vim')
  file='PackagesList'
  File.readlines(file).each do |package|
    system("apt-get instal -y #{package}")
  end
  system('apt-get autoremove')
  system('apt-get autoclean')
  system('locale-gen "en_US.UTF-8"')
  system("cd #{ENV['Home']}/src/github.com/scanf/xcd.rb && /usr/bin/sudo make install")
end
