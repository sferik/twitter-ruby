require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

twitter = Twitter::Base.new(config['email'], config['password'])

puts 'BLOCK CREATE'
puts twitter.block('project_rockne').name
puts
puts

puts 'BLOCK DESTROY'
puts twitter.block('project_rockne').name
puts
puts
