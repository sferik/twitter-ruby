require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
require File.join(File.dirname(__FILE__), 'helpers', 'config_store')
require 'pp'

config = ConfigStore.new("#{ENV['HOME']}/.twitter")

httpauth = Twitter::HTTPAuth.new(config['email'], config['password'])
base = Twitter::Base.new(httpauth)

puts "Friends List, sorted by followers"
base.friends.sort {|a,b| a.followers_count <=> b.followers_count}.reverse.each {|f| puts "#{f.name} (@#{f.screen_name}) - #{f.followers_count}"}

puts "\n\nFollowers List, sorted by followers"
base.followers.sort {|a,b| a.followers_count <=> b.followers_count}.reverse.each {|f| puts "#{f.name} (@#{f.screen_name}) - #{f.followers_count}"}
