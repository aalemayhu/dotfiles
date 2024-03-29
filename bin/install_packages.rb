# frozen_string_literal: true

require_relative './distro'

def ensure_sudo
  sudo_path = '/usr/bin/sudo'
  return if File.exist?(sudo_path)

  p 'error expected ${sudoPath} to exist. unsupported system'
  exit 1
end

def install_macos_packages(config_dir)
  system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
  packages_file = File.readlines("#{config_dir}/packages/macos.txt")
  packages_file.each do |package|
    check = system("brew ls --versions #{package}")
    system("brew #{check ? 'upgrade' : 'install'} #{package}")
  end
end

def install_debian_packages(config_dir)
  system('sudo apt-get update')
  system('sudo apt-get install -y git ruby make locales')
  packages_file = File.readlines("#{config_dir}/packages/debian.txt")
  packages_file.each do |package|
    system("sudo apt-get install -y #{package}")
  end
  system('sudo apt-get autoremove')
  system('sudo apt-get autoclean')
  system('sudo locale-gen en_US.UTF-8')
end

def install_fedora_packages(config_dir)
  system('dnf install -y git ruby make ')
  system('sudo dnf group install "C Development Tools and Libraries"')
  packages_file = File.readlines("#{config_dir}/packages/fedora.txt")
  packages_file.each do |package|
    system("sudo dnf install -y #{package}")
  end
end

def install_packages
  ensure_sudo
  config_dir = "#{File.dirname(__FILE__)}/.."

  return install_macos_packages(config_dir) if darwin?
  return install_debian_packages(config_dir) if debian?
  return install_fedora_packages(config_dir) if fedora?

  puts 'fatal: unsupported system'
  exit 1
end

install_packages if __FILE__ == $PROGRAM_NAME
