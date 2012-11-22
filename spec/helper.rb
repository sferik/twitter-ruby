unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'twitter'
require 'twitter/identity_map'
require 'rspec'
require 'stringio'
require 'tempfile'
require 'timecop'
require 'webmock/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def a_delete(path)
  a_request(:delete, Twitter::Default::ENDPOINT + path)
end

def a_get(path)
  a_request(:get, Twitter::Default::ENDPOINT + path)
end

def a_post(path)
  a_request(:post, Twitter::Default::ENDPOINT + path)
end

def a_put(path)
  a_request(:put, Twitter::Default::ENDPOINT + path)
end

def stub_delete(path)
  stub_request(:delete, Twitter::Default::ENDPOINT + path)
end

def stub_get(path)
  stub_request(:get, Twitter::Default::ENDPOINT + path)
end

def stub_post(path)
  stub_request(:post, Twitter::Default::ENDPOINT + path)
end

def stub_put(path)
  stub_request(:put, Twitter::Default::ENDPOINT + path)
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
