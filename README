= addicted to twitter

... a sweet little diddy that helps you twitter your life away

== Install

sudo gem install twitter will work just fine. For command line use, you'll need a few other gems: sudo gem install main highline activerecord sqlite3-ruby

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
	
== Search Examples

	Twitter::Search.new('httparty').each { |r| puts r.inspect }
	Twitter::Search.new('httparty').from('jnunemaker').each { |r| puts r.inspect }
	Twitter::Search.new.from('jnunemaker').to('oaknd1').each { |r| puts r.inspect }
	

== Command Line Use

Note: If you want to use twitter from the command line be sure that sqlite3 and the sqlite3-ruby gem are installed. I removed the sqlite3-ruby gem as a dependency because you shouldn't need that to just use the API wrapper. Eventually I'll move the CLI interface into another gem.
	
	$ twitter

Will give you a list of all the commands. You can get the help for each command by running twitter [command] -h. 

The first thing you'll want to do is install the database so your account(s) can be stored. 

	$ twitter install
	
You can always uninstall twitter like this:

	$ twitter uninstall
	
Once the twitter database is installed and migrated, you can add accounts like this:

	$ twitter add
	Add New Account:
	Username: jnunemaker
	Password (won't be displayed): 
	Account added.

You can also list all the accounts you've added.

	$ twitter list
	Account List
	* jnunemaker
	  snitch_test

The * means denotes the account that will be used when posting, befriending, defriending, following, leaving or viewing a timeline.

To post using the account marked with the *, simply type the following:

	$ twitter post "releasing my new twitter gem"

That is about it. You can do pretty much anything that you can do with twitter from the command line interface.