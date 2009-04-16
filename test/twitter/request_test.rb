require File.dirname(__FILE__) + '/../test_helper'

class RequestTest < Test::Unit::TestCase
  context "new get request" do
    setup do
      @client = mock('twitter client')
      @request = Twitter::Request.new(@client, :get, '/statuses/user_timeline.json', {:query => {:since_id => 1234}})
    end
    
    should "have client" do
      @request.client.should == @client
    end
    
    should "have method" do
      @request.method.should == :get
    end
    
    should "have path" do
      @request.path.should == '/statuses/user_timeline.json'
    end
    
    should "have options" do
      @request.options[:query].should == {:since_id => 1234}
    end
    
    should "have uri" do
      @request.uri.should == '/statuses/user_timeline.json?since_id=1234'
    end
    
    context "performing request for collection" do
      setup do
        response = mock('response') do
          stubs(:body).returns(fixture_file('user_timeline.json'))
          stubs(:code).returns('200')
        end
        
        @client.expects(:get).returns(response)
        @object = @request.perform
      end

      should "return array of mashes" do
        @object.size.should == 20
        @object.each { |obj| obj.class.should be(Mash) }
        @object.first.text.should == 'Colder out today than expected. Headed to the Beanery for some morning wakeup drink. Latte or coffee...hmmm...'
      end
    end
    
    context "performing a request for a single object" do
      setup do
        response = mock('response') do
          stubs(:body).returns(fixture_file('status.json'))
          stubs(:code).returns('200')
        end
        
        @client.expects(:get).returns(response)
        @object = @request.perform
      end

      should "return a single mash" do
        @object.class.should be(Mash)
        @object.text.should == 'Rob Dyrdek is the funniest man alive. That is all.'
      end
    end
    
    context "with no query string" do
      should "not have any query string" do
        request = Twitter::Request.new(@client, :get, '/statuses/user_timeline.json')
        request.uri.should == '/statuses/user_timeline.json'
      end
    end
    
    context "with blank query string" do
      should "not have any query string" do
        request = Twitter::Request.new(@client, :get, '/statuses/user_timeline.json', :query => {})
        request.uri.should == '/statuses/user_timeline.json'
      end
    end
    
    should "have get shortcut to initialize and perform all in one" do
      Twitter::Request.any_instance.expects(:perform).returns(nil)
      Twitter::Request.get(@client, '/foo')
    end
    
    should "allow setting query string and headers" do
      response = mock('response') do
        stubs(:body).returns('')
        stubs(:code).returns('200')
      end
      
      @client.expects(:get).with('/statuses/friends_timeline.json?since_id=1234', {'Foo' => 'Bar'}).returns(response)
      Twitter::Request.get(@client, '/statuses/friends_timeline.json?since_id=1234', :headers => {'Foo' => 'Bar'})
    end
  end
  
  context "new post request" do
    setup do
      @client = mock('twitter client')
      @request = Twitter::Request.new(@client, :post, '/statuses/update.json', {:body => {:status => 'Woohoo!'}})
    end
    
    should "allow setting body and headers" do
      response = mock('response') do
        stubs(:body).returns('')
        stubs(:code).returns('200')
      end
      
      @client.expects(:post).with('/statuses/update.json', {:status => 'Woohoo!'}, {'Foo' => 'Bar'}).returns(response)
      Twitter::Request.post(@client, '/statuses/update.json', :body => {:status => 'Woohoo!'}, :headers => {'Foo' => 'Bar'})
    end
    
    context "performing request" do
      setup do
        response = mock('response') do
          stubs(:body).returns(fixture_file('status.json'))
          stubs(:code).returns('200')
        end
        
        @client.expects(:post).returns(response)
        @object = @request.perform
      end

      should "return a mash of the object" do
        @object.text.should == 'Rob Dyrdek is the funniest man alive. That is all.'
      end
    end
    
    should "have post shortcut to initialize and perform all in one" do
      Twitter::Request.any_instance.expects(:perform).returns(nil)
      Twitter::Request.post(@client, '/foo')
    end
  end
  
  context "error raising" do
    setup do
      oauth = Twitter::OAuth.new('token', 'secret')
      oauth.authorize_from_access('atoken', 'asecret')
      @client = Twitter::Base.new(oauth)
    end
    
    should "not raise error for 200" do
      stub_get('http://twitter.com:80/foo', '', ['200'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should_not raise_error
    end
    
    should "not raise error for 304" do
      stub_get('http://twitter.com:80/foo', '', ['304'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should_not raise_error
    end
    
    should "raise RateLimitExceeded for 400" do
      stub_get('http://twitter.com:80/foo', 'rate_limit_exceeded.json', ['400'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should raise_error(Twitter::RateLimitExceeded)
    end
    
    should "raise Unauthorized for 401" do
      stub_get('http://twitter.com:80/foo', '', ['401'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should raise_error(Twitter::Unauthorized)
    end
    
    should "raise General for 403" do
      stub_get('http://twitter.com:80/foo', '', ['403'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should raise_error(Twitter::General)
    end

    should "raise NotFound for 404" do
      stub_get('http://twitter.com:80/foo', '', ['404'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should raise_error(Twitter::NotFound)
    end

    should "raise InformTwitter for 500" do
      stub_get('http://twitter.com:80/foo', '', ['500'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should raise_error(Twitter::InformTwitter)
    end

    should "raise Unavailable for 502" do
      stub_get('http://twitter.com:80/foo', '', ['502'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should raise_error(Twitter::Unavailable)
    end

    should "raise Unavailable for 503" do
      stub_get('http://twitter.com:80/foo', '', ['503'])
      lambda {
        Twitter::Request.get(@client, '/foo')
      }.should raise_error(Twitter::Unavailable)
    end
  end
  
  context "Making request with mash option set to false" do
    setup do
      oauth = Twitter::OAuth.new('token', 'secret')
      oauth.authorize_from_access('atoken', 'asecret')
      @client = Twitter::Base.new(oauth)
    end
    
    should "not attempt to create mash of return object" do
      stub_get('http://twitter.com:80/foo', 'friend_ids.json')
      object = Twitter::Request.get(@client, '/foo', :mash => false)
      object.class.should_not be(Mash)
    end
  end
end