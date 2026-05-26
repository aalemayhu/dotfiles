# frozen_string_literal: true

require 'fileutils'
require_relative './distro'

def link_file(source, target)
  if File.exist?(target) || File.symlink?(target)
    if File.symlink?(target) && File.readlink(target) == source
      puts "Link already exists: #{target} -> #{source}"
      return
    end
    
    puts "Backing up existing #{target} to #{target}.bak"
    FileUtils.rm_rf("#{target}.bak")
    FileUtils.mv(target, "#{target}.bak")
  end

  puts "Linking #{source} to #{target}"
  FileUtils.mkdir_p(File.dirname(target))
  File.symlink(source, target)
end

def sync_shell_files(config_dir, home)
  puts 'Syncing shell files'
  link_file "#{config_dir}/shell/aliases", "#{home}/.shell/.aliases"
  link_file "#{config_dir}/shell/env", "#{home}/.shell/.env"
  link_file "#{config_dir}/shell/funcs", "#{home}/.shell/.funcs"
  link_file "#{config_dir}/shell/tmux.conf", "#{home}/.tmux.conf"
  
  link_file "#{config_dir}/shell/bashrc", "#{home}/.bashrc"
  link_file "#{config_dir}/shell/zshrc", "#{home}/.zshrc" unless windows?
  link_file "#{config_dir}/shell/config.fish", "#{home}/.config/fish/config.fish" unless windows?
  link_file "#{config_dir}/term/bash_profile", "#{home}/.bash_profile" if darwin? || windows?
end

def sync_files
  dirname = File.dirname(__FILE__)
  config_dir = File.expand_path("#{dirname}/..")
  home = Dir.home

  sync_shell_files(config_dir, home)

  # Neovim
  link_file "#{config_dir}/nvim", "#{home}/.config/nvim"

  # Git
  link_file "#{config_dir}/git/git-completion.bash", "#{home}/.git-completion.bash"
  link_file "#{config_dir}/git/gitconfig", "#{home}/.gitconfig"

  # SSH & GPG (Non-Windows or specific handling)
  unless windows?
    link_file "#{config_dir}/gnupg/gpg.conf", "#{home}/.gnupg/gpg.conf"
    link_file "#{config_dir}/ssh/config", "#{home}/.ssh/config"
    File.chmod(0o600, "#{home}/.ssh/config") rescue nil
  else
    ssh_config_path = "#{home}/.ssh/config"
    if File.exist?("#{config_dir}/ssh/config")
      link_file "#{config_dir}/ssh/config", ssh_config_path
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  sync_files
end
