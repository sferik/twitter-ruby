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
      should "be able to get home timeline" do
        stub_get('/statuses/home_timeline.json', 'home_timeline.json')
        timeline = @twitter.home_timeline
        timeline.size.should == 20
        first = timeline.first
        first.source.should == '<a href="http://www.atebits.com/software/tweetie/">Tweetie</a>'
        first.user.name.should == 'John Nunemaker'
        first.user.url.should == 'http://railstips.org/about'
        first.id.should == 1441588944
        first.favorited.should be(false)
      end

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

      should "be able to retweet a status" do
        stub_post('/statuses/retweet/6235127466.json', 'retweet.json')
        status = @twitter.retweet(6235127466)
        status.user.name.should == 'Michael D. Ivey'
        status.text.should == "RT @jstetser: I'm not actually awake. My mind's on autopilot for food and I managed to take a detour along the way."
        status.retweeted_status.user.screen_name.should == 'jstetser'
        status.retweeted_status.text.should == "I'm not actually awake. My mind's on autopilot for food and I managed to take a detour along the way."
      end

      should "be able to get retweets of a status" do
        stub_get('/statuses/retweets/6192831130.json', 'retweets.json')
        retweets = @twitter.retweets(6192831130)
        retweets.size.should == 6
        first = retweets.first
        first.user.name.should == 'josephholsten'
        first.text.should == "RT @Moltz: Personally, I won't be satisfied until a Buddhist monk lights himself on fire for web standards."
      end
      
      should "be able to get mentions" do
        stub_get('/statuses/mentions.json', 'mentions.json')
        mentions = @twitter.mentions
        mentions.size.should == 19
        first = mentions.first
        first.user.name.should == '-oAk-'
        first.text.should == '@jnunemaker cold out today. cold yesterday. even colder today.'
      end

      should "be able to get retweets by me" do
        stub_get('/statuses/retweeted_by_me.json', 'retweeted_by_me.json')
        retweeted_by_me = @twitter.retweeted_by_me
        retweeted_by_me.size.should == 20
        first = retweeted_by_me.first.retweeted_status
        first.user.name.should == 'Troy Davis'
        first.text.should == "I'm the mayor of win a free MacBook Pro with promo code Cyber Monday RT for a good time"
      end

      should "be able to get retweets to me" do
        stub_get('/statuses/retweeted_to_me.json', 'retweeted_to_me.json')
        retweeted_to_me = @twitter.retweeted_to_me
        retweeted_to_me.size.should == 20
        first = retweeted_to_me.first.retweeted_status
        first.user.name.should == 'Cloudvox'
        first.text.should == "Testing counts with voice apps too:\n\"the voice told residents to dial 'nine hundred eleven' rather than '9-1-1'\" \342\200\224 http://j.mp/7mqe2B"
      end

      should "be able to get retweets of me" do
        stub_get('/statuses/retweets_of_me.json', 'retweets_of_me.json')
        retweets_of_me = @twitter.retweets_of_me
        retweets_of_me.size.should == 11
        first = retweets_of_me.first
        first.user.name.should == 'Michael D. Ivey'
        first.text.should == "Trying out geotweets in Birdfeed. No \"new RT\" support, though. Any iPhone client with RTs yet?"
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

      should "be able to get a friendship" do
        stub_get("/friendships/show.json?source_screen_name=dcrec1&target_screen_name=pengwynn", 'friendship.json')
        @twitter.friendship_show(:source_screen_name => 'dcrec1', :target_screen_name => 'pengwynn').relationship.target.followed_by == false
      end

      should "be able to search people" do
        stub_get("/users/search.json?q=Wynn%20Netherland", 'people_search.json')
        people = @twitter.user_search('Wynn Netherland')
        people.first.screen_name.should == 'pengwynn'
      end
      
      should "be able to get followers' stauses" do
        stub_get('/statuses/followers.json', 'followers.json')
        followers = @twitter.followers
        followers.should == @twitter.followers
      end
      
      should "be able to get blocked users' IDs" do
        stub_get('/blocks/blocking/ids.json', 'ids.json')
        blocked = @twitter.blocked_ids
        blocked.should == @twitter.blocked_ids      
      end
      
      should "be able to get an array of blocked users" do
        stub_get('/blocks/blocking.json', 'blocking.json')
        blocked = @twitter.blocking
        blocked.last.screen_name.should == "euciavkvyplx"
      end

      should "upload a profile image" do
        stub_post('/account/update_profile_image.json', 'update_profile_image.json')
        user = @twitter.update_profile_image(File.new(sample_image('sample-image.png')))
        user.name.should == 'John Nunemaker' # update_profile_image responds with the user
      end

      should "upload a background image" do
        stub_post('/account/update_profile_background_image.json', 'update_profile_background_image.json')
        user = @twitter.update_profile_background(File.new(sample_image('sample-image.png')))
        user.name.should == 'John Nunemaker' # update_profile_background responds with the user
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
        stub_get('/pengwynn/lists.json', 'lists.json')
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
      
      should "be able to limit number of tweets in list timeline" do
        stub_get('/pengwynn/lists/rubyists/statuses.json?per_page=1', 'list_statuses_1_1.json')
        tweets = @twitter.list_timeline('pengwynn', 'rubyists', :per_page => 1)
        tweets.size.should == 1
        tweets.first.id.should == 5272535583
        tweets.first.user.name.should == 'John Nunemaker'
      end
      
      should "be able to paginate through the timeline" do
        stub_get('/pengwynn/lists/rubyists/statuses.json?page=1&per_page=1', 'list_statuses_1_1.json')
        stub_get('/pengwynn/lists/rubyists/statuses.json?page=2&per_page=1', 'list_statuses_2_1.json')
        tweets = @twitter.list_timeline('pengwynn', 'rubyists', { :page => 1, :per_page => 1 })
        tweets.size.should == 1
        tweets.first.id.should == 5272535583
        tweets.first.user.name.should == 'John Nunemaker'
        tweets = @twitter.list_timeline('pengwynn', 'rubyists', { :page => 2, :per_page => 1 })
        tweets.size.should == 1
        tweets.first.id.should == 5264324712
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
        stub_delete('/pengwynn/rubyists/members.json?id=4243', 'user.json')
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

      should "be able to view a members list subscriptions" do
        stub_get('/pengwynn/lists/subscriptions.json', 'list_subscriptions.json')
        subscriptions = @twitter.list_subscriptions('pengwynn').lists
        subscriptions.size.should == 1
        subscriptions.first.full_name.should == '@chriseppstein/sass-users'
        subscriptions.first.slug.should == 'sass-users'
      end

    end
  end
  
  context "when using a non-twitter service" do
    setup do
      @twitter = Twitter::Base.new(Twitter::HTTPAuth.new('wynn@example.com', 'mypass', :api_endpoint => 'tumblr.com'))
    end

    should "get the home timeline" do
      stub_get('http://wynn%40example.com:mypass@tumblr.com/statuses/home_timeline.json', 'home_timeline.json')
      timeline = @twitter.home_timeline
      timeline.size.should == 20
    end
  end
end
