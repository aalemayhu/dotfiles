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

pm = "apt-get" # assuming Debian
packages = "packages/Debian"
if File.exist?("/etc/fedora-release")
  pm = "dnf"
  packages = "packages/Fedora"
end

if `uname`.strip.start_with?('Darwin')
  pm = "brew"
  packages = "packages/macOS"
  packages = File.readlines(packages).join(" ").delete!("\n")
  `#{pm} install #{packages}`
else
  packages = File.readlines(packages).join(" ").delete!("\n")
  run_as_priviliged_user("#{pm} update")
  run_as_priviliged_user("#{pm} install git vim")
  run_as_priviliged_user("#{pm} install -y #{packages}")
  run_as_priviliged_user("#{pm} autoremove")

  if pm == "apt-get"
    run_as_priviliged_user("#{pm} autoclean")
  end
  run_as_priviliged_user("locale-gen \"en_US.UTF-8\"")
end
system("cd #{ENV['HOME']}/src/github.com/scanf/xcd.rb && #{sudo_path} make install")
