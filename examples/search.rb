require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')
require 'pp'

search = Twitter::Search.new.from('jnunemaker')

puts '*'*50, 'First Run', '*'*50
search.each { |result| pp result }

puts '*'*50, 'Second Run', '*'*50
search.each { |result| pp result }