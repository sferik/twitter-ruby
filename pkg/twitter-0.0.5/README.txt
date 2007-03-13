= addicted to twitter

... a sweet little diddy that helps you twitter your life away

== Command Line Use

	$ twitter

That will show the commands and each command will either run or show you the options it needs to run

	$ twitter post "releasing my new twitter gem"

That will post a status update to your twitter

== Examples

	Twitter::Base.new('your email', 'your password').update('watching veronica mars')

	# or you can use post
	Twitter::Base.new('your email', 'your password').post('post works too')

	puts "Public Timeline", "=" * 50
	Twitter::Base.new('your email', 'your password').timeline(:public).each do |s|
	  puts s.text, s.user.name
	  puts
	end

	puts '', "Friends Timeline", "=" * 50
	Twitter::Base.new('your email', 'your password').timeline.each do |s|
	  puts s.text, s.user.name
	  puts
	end

	puts '', "Friends", "=" * 50
	Twitter::Base.new('your email', 'your password').friends.each do |u|
	  puts u.name, u.status.text
	  puts
	end

	puts '', "Followers", "=" * 50
	Twitter::Base.new('your email', 'your password').followers.each do |u|
	  puts u.name, u.status.text
	  puts
	end