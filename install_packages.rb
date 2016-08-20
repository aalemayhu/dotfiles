#!/usr/bin/ruby

unamestr = `uname`.strip
if unamestr.start_with?('Linux')
  system('sudo apt-get update')
  system('sudo apt-get install git vim')
  file='PackagesList'
  File.readlines(file).each do |package|
    system("sudo apt-get install -y #{package}")
  end
  system('sudo apt-get autoremove')
  system('sudo apt-get autoclean')
  system('locale-gen "en_US.UTF-8"')
  system("cd #{ENV['Home']}/src/github.com/scanf/xcd.rb && /usr/bin/sudo make install")
end
