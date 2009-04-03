require File.dirname(__FILE__) + '/../test_helper'

class BaseTest < Test::Unit::TestCase
  context "base" do
    setup do
      oauth = Twitter::OAuth.new('token', 'secret')
      @access_token = OAuth::AccessToken.new(oauth.consumer, 'atoken', 'asecret')
      oauth.stubs(:access_token).returns(@access_token)
      @twitter = Twitter::Base.new(oauth)
    end
    
    context "initialize" do
      should "require an oauth object" do
        @twitter.instance_variable_get('@client').should == @access_token
      end
    end
    
    should "delegate get to the client" do
      @access_token.expects(:get).with('/foo').returns(nil)
      @twitter.get('/foo')
    end
    
    should "delegate post to the client" do
      @access_token.expects(:post).with('/foo', {:bar => 'baz'}).returns(nil)
      @twitter.post('/foo', {:bar => 'baz'})
    end
    
    context "hitting the api" do
      should "be able to get friends timeline" do
        stub_get('http://twitter.com:80/statuses/friends_timeline.json', 'friends_timeline.json')
        timeline = @twitter.friends_timeline
        timeline.size.should == 20
        first = timeline.first
        first.source.should == '<a href="http://www.atebits.com/software/tweetie/">Tweetie</a>'
        first.user.name.should == 'John Nunemaker'
        first.user.url.should == 'http://railstips.org/about'
        first.id.should == 1441588944
        first.favorited.should be(false)
      end
      
      should "be able to get user timeline" do
        stub_get('http://twitter.com:80/statuses/user_timeline.json', 'user_timeline.json')
        timeline = @twitter.user_timeline
        timeline.size.should == 20
        first = timeline.first
        first.text.should == 'Colder out today than expected. Headed to the Beanery for some morning wakeup drink. Latte or coffee...hmmm...'
        first.user.name.should == 'John Nunemaker'
      end
    end
    
  end
end