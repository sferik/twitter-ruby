require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

twitter = Twitter::Base.new(config['email'], config['password'])

puts "FRIENDS"
twitter.friends.each { |f| puts f.name }
puts
puts

puts "FRIENDS FOR"
twitter.friends_for('orderedlist', :lite => true).each { |f| puts f.name }
puts
puts

puts "FOLLOWERS"
twitter.followers(:lite => true).each { |f| puts f.name }
puts
puts

puts "FOLLOWERS FOR"
twitter.followers_for('orderedlist', :lite => true).each { |f| puts f.name }
puts
puts