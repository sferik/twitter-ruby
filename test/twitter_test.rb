require 'test_helper'

class TwitterTest < Test::Unit::TestCase

  should "configure consumer and access keys for easy access" do
    Twitter.configure do |config|
      config.consumer_key = 'OU812'
      config.consumer_secret = 'vh5150'
      config.access_key = '8675309'
      config.access_secret = '8008135'
    end

    client = Twitter::Authenticated.new

    assert_equal 'OU812', client.consumer_key
    assert_equal 'vh5150', client.consumer_secret
    assert_equal '8675309', client.access_key
    assert_equal '8008135', client.access_secret
  end

  should "default adapter to Faraday.default_adapter" do
    assert_equal Faraday.default_adapter, Twitter.adapter
  end

  context "when overriding adapter" do
    should "be able to specify adapter" do
      Twitter.adapter = :typhoeus
      assert_equal :typhoeus, Twitter.adapter
      # Reset
      Twitter.adapter = Faraday.default_adapter
    end
  end

  should "default user_agent to 'Ruby Twitter Gem'" do
    assert_equal 'Ruby Twitter Gem', Twitter.user_agent
  end

  context "when overriding user_agent" do
    should "be able to specify user_agent" do
      Twitter.user_agent = 'My Twitter Gem'
      assert_equal 'My Twitter Gem', Twitter.user_agent
      # Reset
      Twitter.user_agent = 'Ruby Twitter Gem'
    end
  end

  should "default api_endpoint to 'api.twitter.com'" do
    assert_equal "http://api.twitter.com/#{Twitter.api_version}", Twitter.api_endpoint
  end

  context "when overriding api_endpoint" do
    should "be able to specify api_endpoint" do
      Twitter.api_endpoint = 'tumblr.com'
      assert_equal 'http://tumblr.com', Twitter.api_endpoint
      # Reset
      Twitter.api_endpoint = "api.twitter.com/#{Twitter.api_version}"
    end
  end

  should "default api_version to 1" do
    assert_equal 1, Twitter.api_version
  end

  context "when overriding api_version" do
    should "be able to specify api_version" do
      Twitter.api_version = 2
      assert_equal 2, Twitter.api_version
      # Reset
      Twitter.api_version = 1
    end
  end

  should "default format to json" do
    assert_equal "json", Twitter.format
  end

  context "when overriding format" do
    should "be able to specify format" do
      Twitter.format = "xml"
      assert_equal "xml", Twitter.format
      # Reset
      Twitter.format = "json"
    end
  end

  should "default protocol to https" do
    assert_equal "https", Twitter.protocol
  end

  context "when overriding protocol" do
    should "be able to specify protocol" do
      Twitter.protocol = "http"
      assert_equal "http", Twitter.protocol
      # Reset
      Twitter.protocol = "https"
    end
  end

end
