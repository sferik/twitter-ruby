require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

twitter = Twitter::Base.new(config['email'], config['password'])

puts twitter.create_friendship('orderedlist').name
puts twitter.follow('orderedlist').name
puts twitter.leave('orderedlist').name
puts twitter.destroy_friendship('orderedlist').name

puts twitter.friendship_exists?('jnunemaker', 'orderedlist').inspect
puts twitter.friendship_exists?('jnunemaker', 'ze').inspect