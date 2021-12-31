# frozen_string_literal: true

def create_directories(prefix, listFile)
  list = File.readlines(listFile)
  list.each do |dir|
    dir = dir.chomp
    p "ensuring #{prefix}/#{dir} exists"
    system("mkdir -p #{prefix}/#{dir}")
  end
end

create_directories("#{Dir.home}/src/github.com/scanf", './DirectoriesList') if __FILE__ == $PROGRAM_NAME
