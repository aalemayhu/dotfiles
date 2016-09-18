#!/usr/bin/ruby

unamestr = `uname`.strip
sudo_path = "/usr/bin/sudo"

def run_as_priviliged_user(cmd)
  system("#{sudo_path} #{cmd}"
end

if unamestr.start_with?('Linux')
  pm = "apt-get" # assuming Debian
  if File.exist?("/etc/fedora-release")
   pm = "dnf"
  end

  run_as_priviliged_user("#{pm} update")
  run_as_priviliged_user("#{pm} install git vim")
  packages = File.readlines("PackagesList").join(" ").delete!("\n")
  run_as_priviliged_user("#{pm} install -y #{packages}")
  run_as_priviliged_user("#{pm} autoremove")

  if pm == "apt-get"
   run_as_priviliged_user("#{pm} autoclean")
  end
  run_as_priviliged_user("locale-gen \"en_US.UTF-8\"")
  system("cd #{ENV['HOME']}/src/github.com/scanf/xcd.rb && #{sudo_path} make install")
end
