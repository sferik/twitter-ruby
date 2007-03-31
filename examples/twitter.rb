require 'rubygems'
require 'twitter'

puts "Public Timeline", "=" * 50
Twitter::Base.new('emailaddress', 'password').timeline(:public).each do |s|
  puts s.text, s.user.name
  puts
end

puts '', "Friends Timeline", "=" * 50
Twitter::Base.new('emailaddress', 'password').timeline.each do |s|
  puts s.text, s.user.name
  puts
end

puts '', "Friends", "=" * 50
Twitter::Base.new('emailaddress', 'password').friends.each do |u|
  puts u.name, u.status.text
  puts
end

puts '', "Followers", "=" * 50
Twitter::Base.new('emailaddress', 'password').followers.each do |u|
  puts u.name, u.status.text
  puts
end