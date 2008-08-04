require 'rubygems'
require File.join(File.dirname(__FILE__), '..', 'lib', 'twitter')

Twitter::Search.new('httparty').each { |r| puts r.inspect,'' }

# search = Twitter::Search.new
# search.from('jnunemaker').to('oaknd1').each { |r| puts r.inspect, '' }
# pp search.result
# search.clear

# search.from('jnunemaker').to('oaknd1').since(814529437).containing('milk').each { |r| puts r.inspect, '' }
# search.clear
# 
# search.geocode('40.757929', '-73.985506', '50mi').containing('holland').each { |r| puts r.inspect, '' }
# search.clear

# pp search.from('jnunemaker').fetch()