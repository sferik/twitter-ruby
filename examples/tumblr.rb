require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
require 'pp'


httpauth = Twitter::HTTPAuth.new('email', 'password', :api_endpoint => 'tumblr.com')
base = Twitter::Base.new(httpauth)

pp base.user_timeline
pp base.verify_credentials