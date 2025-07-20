# frozen_string_literal: true

require 'fileutils'

require_relative './distro'

def copy_shell_files(config_dir, home)
  puts 'Copying shell files'
  FileUtils.cp "#{config_dir}/shell/aliases", "#{home}/.shell/.aliases"
  FileUtils.cp "#{config_dir}/shell/bashrc", "#{home}/.bashrc"
  FileUtils.cp "#{config_dir}/shell/env", "#{home}/.shell/.env"
  FileUtils.cp "#{config_dir}/shell/funcs", "#{home}/.shell/.funcs"
  FileUtils.cp "#{config_dir}/shell/tmux.conf", "#{home}/.tmux.conf"
  FileUtils.cp "#{config_dir}/shell/zshrc", "#{home}/.zshrc"
  FileUtils.cp "#{config_dir}/shell/config.fish", "#{home}/.config/fish/config.fish"

  FileUtils.cp "#{config_dir}/term/bash_profile", "#{home}/.bash_profile" if darwin?
end

def copy_files
  dirname = File.dirname(__FILE__)
  config_dir = "#{dirname}/.."
  home = Dir.home

  copy_shell_files(config_dir, home)

  # Misc
  FileUtils.cp "#{config_dir}/gnupg/gpg.conf", "#{home}/.gnupg/gpg.conf"
  FileUtils.cp "#{config_dir}/ssh/config", "#{home}/.ssh/config"
  File.chmod(0o600, "#{home}/.ssh/config")

  # Git
  FileUtils.cp "#{config_dir}/git/git-completion.bash", "#{home}/.git-completion.bash"
  FileUtils.cp "#{config_dir}/git/gitconfig", "#{home}/.gitconfig"
end

copy_files if __FILE__ == $PROGRAM_NAME
