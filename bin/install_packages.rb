#!/usr/bin/ruby

def sudo_path
  "/usr/bin/sudo"
end

def run_as_priviliged_user(cmd)
  system("#{sudo_path} #{cmd}")
end

if !File.exist?(sudo_path)
  puts "error: expected #{sudo_path} to exist. unsupported system"
  exit
end

if `uname`.strip.start_with?('Linux')
  pm = "apt-get" # assuming Debian
  packages = "Debian.packages"
  if File.exist?("/etc/fedora-release")
   pm = "dnf"
   packages = "Fedora.packages"
  end

  run_as_priviliged_user("#{pm} update")
  run_as_priviliged_user("#{pm} install git vim")
  packages = File.readlines(packages).join(" ").delete!("\n")
  run_as_priviliged_user("#{pm} install -y #{packages}")
  run_as_priviliged_user("#{pm} autoremove")

  if pm == "apt-get"
   run_as_priviliged_user("#{pm} autoclean")
  end
  run_as_priviliged_user("locale-gen \"en_US.UTF-8\"")
  system("cd #{ENV['HOME']}/src/github.com/scanf/xcd.rb && #{sudo_path} make install")
end
