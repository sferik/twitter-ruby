require "test/unit"
require "pathname"
require "shoulda"
require "mocha"
require "fakeweb"

FakeWeb.allow_net_connect = false

dir = (Pathname(__FILE__).dirname + "../lib").expand_path
require dir + "twitter"

def sample_image(filename)
  File.expand_path(File.dirname(__FILE__) + "/fixtures/" + filename)
end

def fixture_file(filename)
  return "" if filename == ""
  file_path = File.expand_path(File.dirname(__FILE__) + "/fixtures/" + filename)
  File.read(file_path)
end

def api_endpoint
  "https://api.twitter.com/1/"
end

def stub_get(path, filename, status=nil, location=nil, content_as_full_response=false)
  response_content = content_as_full_response ? 'response' : 'body'
  options = {response_content.to_sym => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  options.merge!({:location => location}) unless location.nil?
  FakeWeb.register_uri(:get, api_endpoint + path, options)
end

def stub_post(path, filename, status=nil, location=nil, content_as_full_response=false)
  response_content = content_as_full_response ? 'response' : 'body'
  options = {response_content.to_sym => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  options.merge!({:location => location}) unless location.nil?
  FakeWeb.register_uri(:post, api_endpoint + path, options)
end

def stub_put(path, filename, status=nil, location=nil, content_as_full_response=false)
  response_content = content_as_full_response ? 'response' : 'body'
  options = {response_content.to_sym => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  options.merge!({:location => location}) unless location.nil?
  FakeWeb.register_uri(:put, api_endpoint + path, options)
end

def stub_delete(path, filename, status=nil, location=nil, content_as_full_response=false)
  response_content = content_as_full_response ? 'response' : 'body'
  options = {response_content.to_sym => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  options.merge!({:location => location}) unless location.nil?
  FakeWeb.register_uri(:delete, api_endpoint + path, options)
end
