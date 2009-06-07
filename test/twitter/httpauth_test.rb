require File.dirname(__FILE__) + '/../test_helper'

class HTTPAuthTest < Test::Unit::TestCase
  context "Creating new instance" do
    should "should take user and password" do
      twitter = Twitter::HTTPAuth.new('username', 'password')
      twitter.username.should == 'username'
      twitter.password.should == 'password'
    end
    
    should "accept options" do
      twitter = Twitter::HTTPAuth.new('username', 'password', :ssl => true)
      twitter.options.should == {:ssl => true}
    end
    
    should "default ssl to false" do
      twitter = Twitter::HTTPAuth.new('username', 'password')
      twitter.options[:ssl].should be(false)
    end
    
    should "use https if ssl is true" do
      Twitter::HTTPAuth.expects(:base_uri).with('https://twitter.com')
      twitter = Twitter::HTTPAuth.new('username', 'password', :ssl => true)
    end
    
    should "use http if ssl is false" do
      Twitter::HTTPAuth.expects(:base_uri).with('http://twitter.com')
      twitter = Twitter::HTTPAuth.new('username', 'password', :ssl => false)
    end
  end
  
  context "Client methods" do
    setup do
      @twitter = Twitter::HTTPAuth.new('username', 'password')
    end
    
    should "not throw error when accessing response message" do
      stub_get('http://twitter.com:80/statuses/user_timeline.json', 'user_timeline.json')
      response = @twitter.get('/statuses/user_timeline.json')
      response.message.should == 'OK'
    end
    
    should "be able to get" do
      stub_get('http://username:password@twitter.com:80/statuses/user_timeline.json', 'user_timeline.json')
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
      stub_post('http://username:password@twitter.com:80/statuses/update.json', 'status.json')
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