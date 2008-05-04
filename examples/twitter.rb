require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

puts "Public Timeline", "=" * 50
Twitter::Base.new(config['email'], config['password']).timeline(:public).each do |s|
  puts s.text, s.user.name
  puts
end

puts '', "Friends Timeline", "=" * 50
Twitter::Base.new(config['email'], config['password']).timeline.each do |s|
  puts s.text, s.user.name
  puts
end

puts '', "Friends", "=" * 50
Twitter::Base.new(config['email'], config['password']).friends.each do |u|
  puts u.name, u.status.text
  puts
end

puts '', "Followers", "=" * 50
Twitter::Base.new(config['email'], config['password']).followers.each do |u|
  puts u.name, u.status.text
  puts
end