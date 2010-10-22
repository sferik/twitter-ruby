require 'test_helper'

class TwitterTest < Test::Unit::TestCase
  should "configure consumer and access keys for easy access" do
    Twitter.configure do |config|
      config.consumer_key = 'OU812'
      config.consumer_secret = 'vh5150'
      config.oauth_token = '8675309'
      config.oauth_token_secret = '8008135'
    end

    assert_equal 'OU812', Twitter.consumer_key
    assert_equal 'vh5150', Twitter.consumer_secret
    assert_equal '8675309', Twitter.oauth_token
    assert_equal '8008135', Twitter.oauth_token_secret

    client = Twitter::Client.new

    assert_equal 'OU812', client.consumer_key
    assert_equal 'vh5150', client.consumer_secret
    assert_equal '8675309', client.oauth_token
    assert_equal '8008135', client.oauth_token_secret

    Twitter.reset
  end

  should "default adapter to Faraday.default_adapter" do
    assert_equal Faraday.default_adapter, Twitter.adapter
  end

  context "when overriding adapter" do
    should "be able to specify adapter" do
      Twitter.adapter = :typhoeus
      assert_equal :typhoeus, Twitter.adapter
      Twitter.reset
    end
  end

  should "default user_agent to 'Twitter Ruby Gem \#{version}'" do
    assert_equal "Twitter Ruby Gem #{Twitter::VERSION}", Twitter.user_agent
  end

  context "when overriding user_agent" do
    should "be able to specify user_agent" do
      Twitter.user_agent = 'My Twitter Gem'
      assert_equal 'My Twitter Gem', Twitter.user_agent
      Twitter.reset
    end
  end

  should "default endpoint to 'https://api.twitter.com/1/'" do
    assert_equal "https://api.twitter.com/1/", Twitter.endpoint
  end

  context "when overriding endpoint" do
    should "be able to specify endpoint" do
      Twitter.endpoint = 'http://tumblr.com/'
      assert_equal 'http://tumblr.com/', Twitter.endpoint
      Twitter.reset
    end
  end

  should "default format to json" do
    assert_equal 'json', Twitter.format
  end

  context "when overriding format" do
    should "be able to specify format" do
      Twitter.format = 'xml'
      assert_equal 'xml', Twitter.format
      Twitter.reset
    end
  end
end
