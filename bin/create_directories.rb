#!/usr/bin/ruby

home=ENV['HOME']
`mkdir -p #{home}/src/github.com/scanf`

file='DirectoriesList'
File.readlines(file).each do |directory|
  `mkdir -p #{home}/#{directory}`
end

