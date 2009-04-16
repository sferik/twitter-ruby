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
      should "require a client" do
        @twitter.client.should respond_to(:get)
        @twitter.client.should respond_to(:post)
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
        stub_get('/statuses/friends_timeline.json', 'friends_timeline.json')
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
        stub_get('/statuses/user_timeline.json', 'user_timeline.json')
        timeline = @twitter.user_timeline
        timeline.size.should == 20
        first = timeline.first
        first.text.should == 'Colder out today than expected. Headed to the Beanery for some morning wakeup drink. Latte or coffee...hmmm...'
        first.user.name.should == 'John Nunemaker'
      end
      
      should "be able to get a status" do
        stub_get('/statuses/show/1441588944.json', 'status.json')
        status = @twitter.status(1441588944)
        status.user.name.should == 'John Nunemaker'
        status.id.should == 1441588944
      end
      
      should "be able to update status" do
        stub_post('/statuses/update.json', 'status.json')
        status = @twitter.update('Rob Dyrdek is the funniest man alive. That is all.')
        status.user.name.should == 'John Nunemaker'
        status.text.should == 'Rob Dyrdek is the funniest man alive. That is all.'
      end
      
      should "be able to get replies" do
        stub_get('/statuses/replies.json', 'replies.json')
        replies = @twitter.replies
        replies.size.should == 19
        first = replies.first
        first.user.name.should == '-oAk-'
        first.text.should == '@jnunemaker cold out today. cold yesterday. even colder today.'
      end
      
      should "be able to get follower ids" do
        stub_get('/followers/ids.json', 'follower_ids.json')
        follower_ids = @twitter.follower_ids
        follower_ids.size.should == 1252
        follower_ids.first.should == 613
      end
      
      should "be able to get friend ids" do
        stub_get('/friends/ids.json', 'friend_ids.json')
        friend_ids = @twitter.friend_ids
        friend_ids.size.should == 161
        friend_ids.first.should == 15323
      end
      
      should "correctly hash statuses" do
        stub_get('/statuses/friends_timeline.json', 'friends_timeline.json')
        hashes = @twitter.friends_timeline.map{ |s| s.hash }
        hashes.should == @twitter.friends_timeline.map{ |s| s.hash }
      end
    end
  end
end