# frozen_string_literal: true

require 'fileutils'

require_relative './distro'

def copy_shell_files(config_dir, home)
  puts 'Copying shell files'
  FileUtils.cp "#{config_dir}/shell/aliases", "#{home}/.shell/.aliases"
  FileUtils.cp "#{config_dir}/shell/env", "#{home}/.shell/.env"
  FileUtils.cp "#{config_dir}/shell/funcs", "#{home}/.shell/.funcs"
  FileUtils.cp "#{config_dir}/shell/tmux.conf", "#{home}/.tmux.conf"
  
  if windows?
    # On Windows, we'll set up bash profile for Git Bash / WSL / MSYS2
    FileUtils.cp "#{config_dir}/shell/bashrc", "#{home}/.bashrc"
    FileUtils.cp "#{config_dir}/term/bash_profile", "#{home}/.bash_profile"
  else
    FileUtils.cp "#{config_dir}/shell/bashrc", "#{home}/.bashrc"
    FileUtils.cp "#{config_dir}/shell/zshrc", "#{home}/.zshrc"
    FileUtils.cp "#{config_dir}/shell/config.fish", "#{home}/.config/fish/config.fish"
    FileUtils.cp "#{config_dir}/term/bash_profile", "#{home}/.bash_profile" if darwin?
  end
end

def copy_files
  dirname = File.dirname(__FILE__)
  config_dir = "#{dirname}/.."
  home = Dir.home

  copy_shell_files(config_dir, home)

  # Skip some Unix-specific configs on Windows
  unless windows?
    # Misc
    FileUtils.cp "#{config_dir}/gnupg/gpg.conf", "#{home}/.gnupg/gpg.conf"
    FileUtils.cp "#{config_dir}/ssh/config", "#{home}/.ssh/config"
    File.chmod(0o600, "#{home}/.ssh/config")
  else
    # Windows-specific SSH config handling
    ssh_config_path = "#{home}/.ssh/config"
    if File.exist?("#{config_dir}/ssh/config")
      FileUtils.cp "#{config_dir}/ssh/config", ssh_config_path
      # Note: chmod may not work the same way on Windows, but we'll try
      File.chmod(0o600, ssh_config_path) rescue nil
    end
  end

  # Git (works on all platforms)
  FileUtils.cp "#{config_dir}/git/git-completion.bash", "#{home}/.git-completion.bash"
  FileUtils.cp "#{config_dir}/git/gitconfig", "#{home}/.gitconfig"
end

copy_files if __FILE__ == $PROGRAM_NAME
