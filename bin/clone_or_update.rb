#!/usr/bin/ruby

home = "#{ENV['HOME']}"
github = "#{home}/src/github.com"
repositories = {
    "#{github}/VundleVim/Vundle.vim" => "https://github.com/VundleVim/Vundle.vim.git",
    "#{github}/git/git" => "https://github.com/git/git",
    "#{github}/scanf/cantera-lock" => "https://github.com/scanf/cantera-lock",
    "#{github}/scanf/cantera-term" => "https://github.com/scanf/cantera-term",
    "#{github}/scanf/cantera-wm" => "https://github.com/scanf/cantera-wm",
    "#{github}/scanf/dotfiles" => "https://github.com/scanf/dotfiles",
    "#{github}/scanf/xcd.rb" => "https://github.com/scanf/xcd.rb",
    "#{home}/Scripts" => "https://github.com/scanf/Scripts",
    "#{home}/.vim" => "https://github.com/scanf/.vim",
    "#{home}/.mutt" => "https://github.com/scanf/.mutt",
    "#{github}/ggreer/the_silver_searcher" => "https://github.com/ggreer/the_silver_searcher",
}

repositories.each_pair do |path, url|
  if !File.exist?(path)
    `git clone #{url} #{path} --recurse-submodules`
  elsif !File.exist?("#{path}/.git")
    STDERR.puts "error: directory exists at #{path} but is not a git directory"
    exit
  else
    `git -C #{path} pull --recurse-submodules`
  end
end
