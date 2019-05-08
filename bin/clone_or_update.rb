#!/usr/bin/ruby

home = "#{ENV['HOME']}"
github = "#{home}/src/github.com"

def clone_or_update(repo)
  repo.each_pair do |path, url|
    if !File.exist?(path)
      `git clone #{url} #{path} --recurse-submodules &`
    elsif !File.exist?("#{path}/.git")
      STDERR.puts "error: directory exists at #{path} but is not a git directory"
      exit
    else
      `git -C #{path} pull --recurse-submodules &`
    end
  end
end

clone_or_update({
  "#{github}/VundleVim/Vundle.vim" => "https://github.com/VundleVim/Vundle.vim.git",
  "#{github}/scanf/dotfiles" => "https://github.com/scanf/dotfiles",
  "#{github}/scanf/xcd.rb" => "https://github.com/scanf/xcd.rb",
  "#{home}/.vim" => "https://github.com/scanf/.vim",
  "#{github}/ggreer/the_silver_searcher" => "https://github.com/ggreer/the_silver_searcher",
})

if not ARGV[0]
  exit 0
end