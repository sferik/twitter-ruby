require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

twitter = Twitter::Base.new(config['email'], config['password'])

puts 'FAVORITES'
twitter.favorites.each { |f| puts f.text }
puts
puts

puts 'CREATE'
puts twitter.create_favorite(865416114).text
puts
puts

puts 'DESTROY'
puts twitter.destroy_favorite(865416114).text
puts
puts
