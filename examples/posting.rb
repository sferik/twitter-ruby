require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

twitter = Twitter::Base.new(config['email'], config['password'])
puts twitter.post("This is a test from the example file").inspect

# sending a direct message
# puts twitter.d('jnunemaker', 'this is a test').inspect