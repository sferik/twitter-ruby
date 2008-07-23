require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

twitter = Twitter::Base.new(config['email'], config['password'])

puts 'SINCE'
twitter.timeline(:user, :since => Time.now - 1.day).each do |s|
  puts "- #{s.text}"
end
puts
puts

puts 'SINCE_ID'
twitter.timeline(:user, :since_id => 865547074).each do |s|
  puts "- #{s.text}"
end
puts
puts

puts 'COUNT'
twitter.timeline(:user, :count => 1).each do |s|
  puts "- #{s.text}"
end
puts
puts

puts 'PAGE'
twitter.timeline(:user, :page => 1).each do |s|
  puts "- #{s.text}"
end
puts
puts