#!/usr/bin/ruby

home = "#{ENV['HOME']}"
github = "#{home}/src/github.com"
repositories = {
    "#{github}/scanf/config-files" => "https://github.com/scanf/config-files",
    "#{github}/VundleVim/Vundle.vim.gi" => "https://github.com/VundleVim/Vundle.vim.git",
    "#{github}/scanf/xcd.rb" => "https://github.com/scanf/xcd.rb",
    "#{github}/mortehu/cantera-wm" => "https://github.com/mortehu/cantera-wm",
    "#{github}/mortehu/cantera-term" => "https://github.com/mortehu/cantera-term",
    "#{github}/mortehu/cantera-lock" => "https://github.com/mortehu/cantera-lock",
    "#{github}/git/git" => "https://github.com/git/git",
    "#{home}/Scripts" => "https://github.com/scanf/Scripts",
}

repositories.each_pair do |path, url|
  if !File.exist?(path)
    `git clone #{url} #{path}`
  else
    `git -C #{path} pull`
  end
end