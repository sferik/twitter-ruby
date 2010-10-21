require "test/unit"
require "pathname"
require "shoulda"
require "mocha"
require "fakeweb"

FakeWeb.allow_net_connect = false

require "twitter"

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

def stub_get(path, filename, content_type='application/json; charset=utf-8', status=200, location=nil, content_as_full_response=false)
  response_content = content_as_full_response ? 'response' : 'body'
  options = {response_content.to_sym => fixture_file(filename)}
  options.merge!({:status => status})
  options.merge!({:content_type => content_type})
  options.merge!({:location => location}) unless location.nil?
  FakeWeb.register_uri(:get, api_endpoint + path, options)
end

def stub_post(path, filename, content_type='application/json; charset=utf-8', status=200, location=nil, content_as_full_response=false)
  response_content = content_as_full_response ? 'response' : 'body'
  options = {response_content.to_sym => fixture_file(filename)}
  options.merge!({:status => status})
  options.merge!({:content_type => content_type})
  options.merge!({:location => location}) unless location.nil?
  FakeWeb.register_uri(:post, api_endpoint + path, options)
end

def stub_put(path, filename, content_type='application/json; charset=utf-8', status=200, location=nil, content_as_full_response=false)
  response_content = content_as_full_response ? 'response' : 'body'
  options = {response_content.to_sym => fixture_file(filename)}
  options.merge!({:status => status})
  options.merge!({:content_type => content_type})
  options.merge!({:location => location}) unless location.nil?
  FakeWeb.register_uri(:put, api_endpoint + path, options)
end

def stub_delete(path, filename, content_type='application/json; charset=utf-8', status=200, location=nil, content_as_full_response=false)
  response_content = content_as_full_response ? 'response' : 'body'
  options = {response_content.to_sym => fixture_file(filename)}
  options.merge!({:status => status})
  options.merge!({:content_type => content_type})
  options.merge!({:location => location}) unless location.nil?
  FakeWeb.register_uri(:delete, api_endpoint + path, options)
end
