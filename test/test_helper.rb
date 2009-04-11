require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'matchy'
require 'mocha'
require 'fakeweb'

FakeWeb.allow_net_connect = false

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'twitter'

class Test::Unit::TestCase
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def twitter_url(url)
  url =~ /^http/ ? url : "http://twitter.com:80#{url}"
end

def stub_get(url, filename, status=nil)
  options = {:string => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:get, twitter_url(url), options)
end

def stub_post(url, filename)
  FakeWeb.register_uri(:post, twitter_url(url), :string => fixture_file(filename))
end
