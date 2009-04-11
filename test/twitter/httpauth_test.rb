require File.dirname(__FILE__) + '/../test_helper'

class HTTPAuthTest < Test::Unit::TestCase
  context "Creating new instance" do
    should "should take user and password" do
      twitter = Twitter::HTTPAuth.new('username', 'password')
      twitter.username.should == 'username'
      twitter.password.should == 'password'
    end
  end
  
  context "Client methods" do
    setup do
      @twitter = Twitter::HTTPAuth.new('username', 'password')
    end

    should "be able to get" do
      stub_get('http://twitter.com:80/statuses/user_timeline.json', 'user_timeline.json')
      response = @twitter.get('/statuses/user_timeline.json')
      response.should == fixture_file('user_timeline.json')
    end
    
    should "be able to get with headers" do
      @twitter.class.expects(:get).with(
        '/statuses/user_timeline.json', {
          :basic_auth => {:username => 'username', :password => 'password'}, 
          :headers => {'Foo' => 'Bar'}
        }
      ).returns(fixture_file('user_timeline.json'))
      @twitter.get('/statuses/user_timeline.json', {'Foo' => 'Bar'})
    end
    
    should "be able to post" do
      stub_post('http://twitter.com:80/statuses/update.json', 'status.json')
      response = @twitter.post('/statuses/update.json', :text => 'My update.')
      response.should == fixture_file('status.json')
    end
    
    should "be able to post with headers" do
      @twitter.class.expects(:post).with(
        '/statuses/update.json', {
          :headers => {'Foo' => 'Bar'}, 
          :body => {:text => 'My update.'}, 
          :basic_auth => {:username => 'username', :password => 'password'}
        }
      ).returns(fixture_file('status.json'))
      @twitter.post('/statuses/update.json', {:text => 'My update.'}, {'Foo' => 'Bar'})
    end
  end
end