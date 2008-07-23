require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

twitter = Twitter::Base.new(config['email'], config['password'])

puts twitter.verify_credentials

begin
  Twitter::Base.new('asdf', 'foobar').verify_credentials
rescue => error
  puts error.message
end