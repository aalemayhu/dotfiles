# frozen_string_literal: true

# Abstraction for GitHub repository
class Repository
  attr_accessor :local, :remote

  def initialize(local, remote)
    @local = local
    @remote = remote
  end

  def clone
    puts "Cloning #{@remote}..."
    `git clone #{@remote} #{@local} --recurse-submodules`
  end

  def update
    puts "Updating #{@local}..."
    `git -C #{@local} pull`
  end

  def self.defaults(src, home)
    [
      Repository.new("#{src}/VundleVim/Vundle.vim", 'https://github.com/VundleVim/Vundle.vim.git'),
      Repository.new("#{src}/scanf/dotfiles", 'https://github.com/scanf/dotfiles'),
      Repository.new("#{home}/.vim", 'https://github.com/scanf/.vim'),
      Repository.new("#{src}/ggreer/the_silver_searcher", 'https://github.com/ggreer/the_silver_searcher'),
      Repository.new("#{home}/.mutt", 'https://github.com/scanf/.mutt'),
      Repository.new("#{src}/ruby/ruby", 'https://github.com/ruby/ruby'),
      Repository.new("#{src}/ankitects/anki", 'https://github.com/ankitects/anki')
    ]
  end
end

def synchronize_repositories
  home = Dir.home
  src = "#{home}/src/github.com"
  Repository.defaults(src, home).each do |repo|
    if File.exist?(repo.local)
      puts "fatal: #{repo.local} is not a git repository" unless File.exist?("#{repo.local}/.git")
      repo.update
    else
      repo.clone
    end
  end
end

synchronize_repositories if __FILE__ == $PROGRAM_NAME
