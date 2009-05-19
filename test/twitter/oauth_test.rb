require File.dirname(__FILE__) + '/../test_helper'

class OAuthTest < Test::Unit::TestCase
  should "initialize with consumer token and secret" do
    twitter = Twitter::OAuth.new('token', 'secret')
    
    twitter.ctoken.should == 'token'
    twitter.csecret.should == 'secret'
  end
  
  should "set autorization path to '/oauth/authorize' by default" do
    twitter = Twitter::OAuth.new('token', 'secret')
    twitter.consumer.options[:authorize_path].should == '/oauth/authorize'
  end

  should "set autorization path to '/oauth/authenticate' if sign_in_with_twitter" do
    twitter = Twitter::OAuth.new('token', 'secret', :sign_in => true)
    twitter.consumer.options[:authorize_path].should == '/oauth/authenticate'
  end
  
  should "have a consumer" do
    consumer = mock('oauth consumer')
    OAuth::Consumer.expects(:new).with('token', 'secret', {:site => 'http://twitter.com'}).returns(consumer)
    twitter = Twitter::OAuth.new('token', 'secret')
    
    twitter.consumer.should == consumer
  end
  
  should "have a request token from the consumer" do
    consumer = mock('oauth consumer')
    request_token = mock('request token')
    consumer.expects(:get_request_token).returns(request_token)
    OAuth::Consumer.expects(:new).with('token', 'secret', {:site => 'http://twitter.com'}).returns(consumer)
    twitter = Twitter::OAuth.new('token', 'secret')
    
    twitter.request_token.should == request_token
  end
  
  should "be able to create access token from request token and secret" do
    twitter = Twitter::OAuth.new('token', 'secret')
    consumer = OAuth::Consumer.new('token', 'secret', {:site => 'http://twitter.com'})
    twitter.stubs(:consumer).returns(consumer)
    
    access_token = mock('access token', :token => 'atoken', :secret => 'asecret')
    request_token = mock('request token')
    request_token.expects(:get_access_token).returns(access_token)
    OAuth::RequestToken.expects(:new).with(consumer, 'rtoken', 'rsecret').returns(request_token)
    
    twitter.authorize_from_request('rtoken', 'rsecret')
    twitter.access_token.class.should be(OAuth::AccessToken)
    twitter.access_token.token.should == 'atoken'
    twitter.access_token.secret.should == 'asecret'
  end
  
  should "be able to create access token from access token and secret" do
    twitter = Twitter::OAuth.new('token', 'secret')
    consumer = OAuth::Consumer.new('token', 'secret', {:site => 'http://twitter.com'})
    twitter.stubs(:consumer).returns(consumer)
    
    twitter.authorize_from_access('atoken', 'asecret')
    twitter.access_token.class.should be(OAuth::AccessToken)
    twitter.access_token.token.should == 'atoken'
    twitter.access_token.secret.should == 'asecret'
  end
  
  should "delegate get to access token" do
    access_token = mock('access token')
    twitter = Twitter::OAuth.new('token', 'secret')
    twitter.stubs(:access_token).returns(access_token)
    access_token.expects(:get).returns(nil)
    twitter.get('/foo')
  end
  
  should "delegate post to access token" do
    access_token = mock('access token')
    twitter = Twitter::OAuth.new('token', 'secret')
    twitter.stubs(:access_token).returns(access_token)
    access_token.expects(:post).returns(nil)
    twitter.post('/foo')
  end
end
