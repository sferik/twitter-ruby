require 'test_helper'

class TwitterTest < Test::Unit::TestCase

  should "default adapter to Faraday.default_adapter" do
    assert_equal Faraday.default_adapter, Twitter.adapter
  end

  context 'when overriding the adapter' do
    should "be able to specify the adapter" do
      Twitter.adapter = :typhoeus
      assert_equal :typhoeus, Twitter.adapter
      Twitter.adapter = Faraday.default_adapter
    end
  end

  should "default user_agent to 'Ruby Twitter Gem'" do
    assert_equal 'Ruby Twitter Gem', Twitter.user_agent
  end

  context 'when overriding the user_agent' do
    should "be able to specify the user_agent" do
      Twitter.user_agent = 'My Twitter Gem'
      assert_equal 'My Twitter Gem', Twitter.user_agent
      Twitter.user_agent = 'Ruby Twitter Gem'
    end
  end

  should "default api_endpoint to 'api.twitter.com'" do
    assert_equal "http://api.twitter.com/#{Twitter.api_version}", Twitter.api_endpoint
  end

  context 'when overriding the api_endpoint' do
    should "be able to specify the api_endpoint" do
      Twitter.api_endpoint = 'tumblr.com'
      assert_equal 'http://tumblr.com', Twitter.api_endpoint
      Twitter.api_endpoint = "api.twitter.com/#{Twitter.api_version}"
    end
  end

  should "default api_version to '1'" do
    assert_equal 1, Twitter.api_version
  end

  context 'when overriding the api_version' do
    should "be able to specify the api_version" do
      Twitter.api_version = 2
      assert_equal 2, Twitter.api_version
      Twitter.api_version = 1
    end
  end

end
