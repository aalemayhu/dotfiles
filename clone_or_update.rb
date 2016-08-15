#!/usr/bin/ruby

home = "#{ENV['HOME']}"
github = "#{home}/src/github.com"
repositories = {
    "#{github}/VundleVim/Vundle.vim.gi" => "https://github.com/VundleVim/Vundle.vim.git",
    "#{github}/git/git" => "https://github.com/git/git",
    "#{github}/mortehu/cantera-lock" => "https://github.com/mortehu/cantera-lock",
    "#{github}/mortehu/cantera-term" => "https://github.com/mortehu/cantera-term",
    "#{github}/mortehu/cantera-wm" => "https://github.com/mortehu/cantera-wm",
    "#{github}/scanf/config-files" => "https://github.com/scanf/config-files",
    "#{github}/scanf/xcd.rb" => "https://github.com/scanf/xcd.rb",
    "#{home}/Scripts" => "https://github.com/scanf/Scripts",
}

repositories.each_pair do |path, url|
  if !File.exist?(path)
    `git clone #{url} #{path}`
  else
    `git -C #{path} pull`
  end
end
