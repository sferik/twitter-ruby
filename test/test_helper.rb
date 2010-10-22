require 'test/unit'
require 'pathname'
require 'shoulda'
require 'mocha'
require 'fakeweb'

FakeWeb.allow_net_connect = false

require 'twitter'

def fixture_path(filename)
  File.expand_path("../fixtures/#{filename}", __FILE__)
end

def sample_image(filename)
  fixture_path(filename)
end

def fixture_file(filename)
  return '' if filename == ''
  File.read(fixture_path(filename))
end

def stub_get(path, filename, options={})
  stub_request(:get, path, filename, options)
end

def stub_post(path, filename, options={})
  stub_request(:post, path, filename, options)
end

def stub_put(path, filename, options={})
  stub_request(:put, path, filename, options)
end

def stub_delete(path, filename, options={})
  stub_request(:delete, path, filename, options)
end

def stub_request(method, path, filename, options)
  options = {
    :format => :json,
    :status => 200,
    :location => nil,
    :content_as_full_response => false
  }.merge(options)

  response_content = options[:content_as_full_response] ? :response : :body
  content_type = "application/#{options[:format]}; charset=utf-8"
  response_options = {:status => options[:status], response_content => fixture_file(filename), :content_type => content_type}
  response_options.merge!(:location => options[:location]) if options[:location]
  FakeWeb.register_uri(method, Twitter::Configuration::DEFAULT_ENDPOINT + path, response_options)
end
