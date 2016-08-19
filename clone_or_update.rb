#!/usr/bin/ruby

home = "#{ENV['HOME']}"
github = "#{home}/src/github.com"
repositories = {
    "#{github}/VundleVim/Vundle.vim" => "https://github.com/VundleVim/Vundle.vim.git",
    "#{github}/git/git" => "https://github.com/git/git",
    "#{github}/mortehu/cantera-lock" => "https://github.com/mortehu/cantera-lock",
    "#{github}/mortehu/cantera-term" => "https://github.com/mortehu/cantera-term",
    "#{github}/mortehu/cantera-wm" => "https://github.com/mortehu/cantera-wm",
    "#{github}/scanf/config-files" => "https://github.com/scanf/config-files",
    "#{github}/scanf/xcd.rb" => "https://github.com/scanf/xcd.rb",
    "#{home}/Scripts" => "https://github.com/scanf/Scripts",
    "#{home}/.vim" => "https://github.com/scanf/.vim",
}

repositories.each_pair do |path, url|
  if !File.exist?(path)
    `git clone #{url} #{path} --recurse-submodules`
  elsif File.exist?("#{path}/.git")
    STDERR.puts "error: directory exists at #{path} but is not a git directory"
    exit
  else
    `git -C #{path} pull --recurse-submodules`
  end
end
