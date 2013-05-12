require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'twitter'
require 'twitter/identity_map'
require 'rspec'
require 'stringio'
require 'tempfile'
require 'timecop'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    stub_post("/oauth2/token").with(:body => "grant_type=client_credentials").to_return(:body => fixture("bearer_token.json"), :headers => {:content_type => "application/json; charset=utf-8"})
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
