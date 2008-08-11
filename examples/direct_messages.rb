require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

twitter = Twitter::Base.new(config['email'], config['password'])

puts 'SINCE'
twitter.direct_messages(:since => Time.now - 5.day).each do |s|
  puts "- #{s.id} #{s.text}"
end
puts
puts

# puts 'SINCE_ID'
# twitter.direct_messages(:since_id => 33505386).each do |s|
#   puts "- #{s.text}"
# end
# puts
# puts
# 
# puts 'PAGE'
# twitter.direct_messages(:page => 1).each do |s|
#   puts "- #{s.text}"
# end
# puts
# puts

# puts twitter.destroy_direct_message(34489057).inspect