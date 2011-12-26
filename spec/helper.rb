require 'simplecov'
# HACK - couldn't get tests to run without this, simple cov barfed with the following error:
# .../simplecov-0.5.4/lib/simplecov/source_file.rb:157:in `block in process_skipped_lines!': invalid byte sequence in US-ASCII #(ArgumentError)
# I intend to find a better solution before making the pull request 
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
SimpleCov.start

require 'twitter'
require 'rspec'
require 'webmock/rspec'

def a_delete(path, endpoint=Twitter.endpoint)
  a_request(:delete, endpoint + path)
end

def a_get(path, endpoint=Twitter.endpoint)
  a_request(:get, endpoint + path)
end

def a_post(path, endpoint=Twitter.endpoint)
  a_request(:post, endpoint + path)
end

def a_put(path, endpoint=Twitter.endpoint)
  a_request(:put, endpoint + path)
end

def stub_delete(path, endpoint=Twitter.endpoint)
  stub_request(:delete, endpoint + path)
end

def stub_get(path, endpoint=Twitter.endpoint)
  stub_request(:get, endpoint + path)
end

def stub_post(path, endpoint=Twitter.endpoint)
  stub_request(:post, endpoint + path)
end

def stub_put(path, endpoint=Twitter.endpoint)
  stub_request(:put, endpoint + path)
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
