require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
config = YAML::load(open(ENV['HOME'] + '/.twitter'))

identica = Twitter::Base.new(config['email'], config['password'], :api_host => 'identi.ca/api')

identica.timeline(:public).each { |s| puts s.text, s.user.name, '' }
