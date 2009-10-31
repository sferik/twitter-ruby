require 'test_helper'

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
    
    context "when using lists" do
      
      should "be able to create a new list" do
        stub_post('/pengwynn/lists.json', 'list.json')
        list = @twitter.list_create('pengwynn', {:name => 'Rubyists'})
        list.name.should == 'Rubyists'
        list.slug.should == 'rubyists'
        list.mode.should == 'public'
      end
      
      should "be able to update a list" do
        stub_put('/pengwynn/lists/rubyists.json', 'list.json')
        list = @twitter.list_update('pengwynn', 'rubyists', {:name => 'Rubyists'})
        list.name.should == 'Rubyists'
        list.slug.should == 'rubyists'
        list.mode.should == 'public'
      end
      
      should "be able to delete a list" do
        stub_delete('/pengwynn/lists/rubyists.json', 'list.json')
        list = @twitter.list_delete('pengwynn', 'rubyists')
        list.name.should == 'Rubyists'
        list.slug.should == 'rubyists'
        list.mode.should == 'public'
      end
      
      should "be able to view lists to which a user belongs" do
        stub_get('/pengwynn/lists/memberships.json', 'memberships.json')
        lists = @twitter.memberships('pengwynn').lists
        lists.size.should == 16
        lists.first.name.should == 'web-dev'
        lists.first.member_count.should == 38
      end
      
      should "be able to view lists for the authenticated user" do
        stub_get('http://api.twitter.com/1/pengwynn/lists.json', 'lists.json')
        lists = @twitter.lists('pengwynn').lists
        lists.size.should == 1
        lists.first.name.should == 'Rubyists'
        lists.first.slug.should == 'rubyists'
      end

      should "be able to view list details" do
        stub_get('/pengwynn/lists/rubyists.json', 'list.json')
        list = @twitter.list('pengwynn', 'rubyists')
        list.name.should == 'Rubyists'
        list.subscriber_count.should == 0
      end
      
      should "be able to view list timeline" do
        stub_get('/pengwynn/lists/rubyists/statuses.json', 'list_statuses.json')
        tweets = @twitter.list_timeline('pengwynn', 'rubyists')
        tweets.size.should == 20
        tweets.first.id.should == 5272535583
        tweets.first.user.name.should == 'John Nunemaker'
      end
      
      should "be able to view list members" do
        stub_get('/pengwynn/rubyists/members.json', 'list_users.json')
        members = @twitter.list_members('pengwynn', 'rubyists').users
        members.size.should == 2
        members.first.name.should == 'John Nunemaker'
        members.first.screen_name.should == 'jnunemaker'
      end
      
      should "be able to add a member to a list" do
        stub_post('/pengwynn/rubyists/members.json', 'user.json')
        user = @twitter.list_add_member('pengwynn', 'rubyists', 4243)
        user.screen_name.should == 'jnunemaker'
      end
      
      should "be able to remove a member from a list" do
        stub_delete('/pengwynn/rubyists/members.json', 'user.json')
        user = @twitter.list_remove_member('pengwynn', 'rubyists', 4243)
        user.screen_name.should == 'jnunemaker'
      end
      
      should "be able to check if a user is member of a list" do
        stub_get('/pengwynn/rubyists/members/4243.json', 'user.json')
        @twitter.is_list_member?('pengwynn', 'rubyists', 4243).should == true
      end
      
      should "be able to view list subscribers" do
        stub_get('/pengwynn/rubyists/subscribers.json', 'list_users.json')
        subscribers = @twitter.list_subscribers('pengwynn', 'rubyists').users
        subscribers.size.should == 2
        subscribers.first.name.should == 'John Nunemaker'
        subscribers.first.screen_name.should == 'jnunemaker'
      end
      
      should "be able to subscribe to a list" do
        stub_post('/pengwynn/rubyists/subscribers.json', 'user.json')
        user = @twitter.list_subscribe('pengwynn', 'rubyists')
        user.screen_name.should == 'jnunemaker'
      end
      
      should "be able to unsubscribe from a list" do
        stub_delete('/pengwynn/rubyists/subscribers.json', 'user.json')
        user = @twitter.list_unsubscribe('pengwynn', 'rubyists')
        user.screen_name.should == 'jnunemaker'
      end
      
    end
    
    
  end
end