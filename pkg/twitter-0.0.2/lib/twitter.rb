# = addicted to twitter
# 
# ... a sweet little diddy that helps you twitter your life away
# 
# 
# == Install
# 
# $ sudo gem install twitter
# 
# == Examples
#  
# 	Twitter::Base.new('your email', 'your password').update('watching veronica mars')
# 
# 	# or you can use post
# 	Twitter::Base.new('your email', 'your password').post('post works too')
# 
# 	puts "Public Timeline", "=" * 50
# 	Twitter::Base.new('your email', 'your password').timeline(:public).each do |s|
# 	  puts s.text, s.user.name
# 	  puts
# 	end
# 
# 	puts '', "Friends Timeline", "=" * 50
# 	Twitter::Base.new('your email', 'your password').timeline.each do |s|
# 	  puts s.text, s.user.name
# 	  puts
# 	end
# 
# 	puts '', "Friends", "=" * 50
# 	Twitter::Base.new('your email', 'your password').friends.each do |u|
# 	  puts u.name, u.status.text
# 	  puts
# 	end
# 
# 	puts '', "Followers", "=" * 50
# 	Twitter::Base.new('your email', 'your password').followers.each do |u|
# 	  puts u.name, u.status.text
# 	  puts
# 	end

require 'twitter/version'
require 'twitter/easy_class_maker'
require 'twitter/base'
require 'twitter/user'
require 'twitter/status'