require 'test_helper'

class BaseTest < Test::Unit::TestCase
  context "base" do
    setup do
      oauth = Twitter::OAuth.new('token', 'secret')
      @access_token = OAuth::AccessToken.new(oauth.consumer, 'atoken', 'asecret')
      oauth.stubs(:access_token).returns(@access_token)
      @client = Twitter::Base.new(oauth)
    end

    context "initialize" do
      should "require a client" do
        assert_respond_to @client.client, :get
        assert_respond_to @client.client, :post
      end
    end

    should "delegate get to the client" do
      @access_token.expects(:get).with('/foo').returns(nil)
      @client.get('/foo')
    end

    should "delegate post to the client" do
      @access_token.expects(:post).with('/foo', {:bar => 'baz'}).returns(nil)
      @client.post('/foo', {:bar => 'baz'})
    end

    context "hitting the API" do
      should "get home timeline" do
        stub_get('/1/statuses/home_timeline.json', 'array.json')
        assert @client.home_timeline
      end

      should "get friends timeline" do
        stub_get('/1/statuses/friends_timeline.json', 'array.json')
        assert @client.friends_timeline
      end

      should "get user timeline" do
        stub_get('/1/statuses/user_timeline.json', 'array.json')
        assert @client.user_timeline
      end

      should "get retweeted-to-user timeline by screen_name" do
        stub_get('/1/statuses/retweeted_to_user.json?screen_name=sferik', 'array.json')
        assert @client.retweeted_to_user('sferik')
      end

      should "get retweeted-to-user timeline by user_id" do
        stub_get('/1/statuses/retweeted_to_user.json?user_id=7505382', 'array.json')
        assert @client.retweeted_to_user(7505382)
      end

      should "get retweeted-by-user timeline by screen_name" do
        stub_get('/1/statuses/retweeted_by_user.json?screen_name=sferik', 'array.json')
        assert @client.retweeted_by_user('sferik')
      end

      should "get retweeted-by-user timeline by user id" do
        stub_get('/1/statuses/retweeted_by_user.json?user_id=7505382', 'array.json')
        assert @client.retweeted_by_user(7505382)
      end

      should "get a status" do
        stub_get('/1/statuses/show/25938088801.json', 'hash.json')
        assert @client.status(25938088801)
      end

      should "update a status" do
        stub_post('/1/statuses/update.json', 'hash.json')
        assert @client.update('@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!')
      end

      should "delete a status" do
        stub_delete('/1/statuses/destroy/25938088801.json', 'hash.json')
        assert @client.status_destroy(25938088801)
      end

      should "retweet a status" do
        stub_post('/1/statuses/retweet/6235127466.json', 'hash.json')
        assert @client.retweet(6235127466)
      end

      should "get retweets of a status" do
        stub_get('/1/statuses/retweets/6192831130.json', 'array.json')
        assert @client.retweets(6192831130)
      end

      should "get mentions" do
        stub_get('/1/statuses/mentions.json', 'array.json')
        assert @client.mentions
      end

      should "get retweets by me" do
        stub_get('/1/statuses/retweeted_by_me.json', 'array.json')
        assert @client.retweeted_by_me
      end

      should "get retweets to me" do
        stub_get('/1/statuses/retweeted_to_me.json', 'array.json')
        assert @client.retweeted_to_me
      end

      should "get retweets of me" do
        stub_get('/1/statuses/retweets_of_me.json', 'array.json')
        assert @client.retweets_of_me
      end

      should "get users who retweeted a tweet" do
        stub_get('/1/statuses/24519048728/retweeted_by.json', 'array.json')
        assert @client.retweeters_of(24519048728)
      end

      should "get ids of users who retweeted a tweet" do
        stub_get('/1/statuses/24519048728/retweeted_by/ids.json', 'array.json')
        assert @client.retweeters_of(24519048728, :ids_only => true)
      end

      should "get follower ids" do
        stub_get('/1/followers/ids.json', 'array.json')
        assert @client.follower_ids
      end

      should "get friend ids" do
        stub_get('/1/friends/ids.json', 'array.json')
        assert @client.friend_ids
      end

      should "get a user by user id" do
        stub_get('/1/users/show.json?user_id=7505382', 'hash.json')
        assert @client.user(7505382)
      end

      should "get a user by screen_name" do
        stub_get('/1/users/show.json?screen_name=sferik', 'hash.json')
        assert @client.user('sferik')
      end

      should "get single user with the users method" do
        stub_get('/1/users/lookup.json?screen_name=sferik', 'array.json')
        assert @client.users('sferik')
      end

      should "get users in bulk" do
        stub_get('/1/users/lookup.json?user_id=59593%2C774010&screen_name=sferik', 'array.json')
        assert @client.users(['sferik', 59593, 774010])
      end

      should "search people" do
        stub_get('/1/users/search.json?q=Erik%20Michaels-Ober', 'array.json')
        assert @client.user_search('Erik Michaels-Ober')
      end

      should "get a direct message" do
        stub_get('/1/direct_messages/show/1694868698.json', 'array.json')
        assert @client.direct_message(1694868698)
      end

      should "get direct messages" do
        stub_get('/1/direct_messages.json', 'array.json')
        assert @client.direct_messages
      end

      should "get direct messages sent" do
        stub_get('/1/direct_messages/sent.json', 'array.json')
        assert @client.direct_messages_sent
      end

      should "create a direct message" do
        stub_post('/1/direct_messages/new.json', 'array.json')
        assert @client.direct_message_create('hurrycane', "Erik, Could you please ask Yehuda for the date when he will make the payment? I still haven't received the stipend. Thanks!")
      end

      should "delete a direct message" do
        stub_delete('/1/direct_messages/destroy/1694868698.json', 'array.json')
        assert @client.direct_message_destroy(1694868698)
      end

      should "get a friendship" do
        stub_get('/1/friendships/show.json?source_screen_name=dcrec1&target_screen_name=pengwynn', 'hash.json')
        assert @client.friendship(:source_screen_name => 'dcrec1', :target_screen_name => 'pengwynn')
      end

      should "get single friendship with the friendships method" do
        stub_get('/1/friendships/lookup.json?screen_name=SarahPalinUSA', 'array.json')
        assert @client.friendships('SarahPalinUSA')
      end

      should "get friendships" do
        stub_get('/1/friendships/lookup.json?user_id=33423%2C813286&screen_name=SarahPalinUSA', 'array.json')
        assert @client.friendships(['SarahPalinUSA', 33423, 813286])
      end

      should "create a friendship" do
        stub_post('/1/friendships/create.json', 'hash.json')
        assert @client.friendship_create('sferik')
      end

      should "update a friendship" do
        stub_post('/1/friendships/update.json', 'hash.json')
        assert @client.friendship_update('twitterapi', :device => true, :retweets => false)
      end

      should "delete a friendship" do
        stub_delete('/1/friendships/destroy.json?screen_name=sferik', 'hash.json')
        assert @client.friendship_destroy('sferik')
      end

      should "test whether a friendship exists" do
        stub_get('/1/friendships/exists.json?user_a=pengwynn&user_b=sferik', 'true.json')
        assert @client.friendship_exists?('pengwynn', 'sferik')
      end

      should "get followers' stauses" do
        stub_get('/1/statuses/followers.json', 'array.json')
        assert @client.followers
      end

      should "get blocked users' IDs" do
        stub_get('/1/blocks/blocking/ids.json', 'array.json')
        assert @client.blocked_ids
      end

      should "get an array of blocked users" do
        stub_get('/1/blocks/blocking.json', 'array.json')
        assert @client.blocking
      end

      should "update profile colors" do
        stub_post('/1/account/update_profile_colors.json', 'hash.json')
        assert @client.update_profile_colors(:profile_background_color => 'C0DEED')
      end

      should "update profile image" do
        stub_post('/1/account/update_profile_image.json', 'hash.json')
        assert @client.update_profile_image(File.new(sample_image('me.jpeg')))
      end

      should "update background image" do
        stub_post('/1/account/update_profile_background_image.json', 'hash.json')
        assert @client.update_profile_background(File.new(sample_image('nature02922-f1.2.jpeg')))
      end

      should "update profile" do
        stub_post('/1/account/update_profile.json', 'hash.json')
        assert @client.update_profile(:location => 'San Francisco')
      end

      should "get related results" do
        stub_get('/1/related_results/show/25938088801.json', 'array.json')
        assert @client.related_results(25938088801)
      end

      should "get rate limit status" do
        stub_get('/1/account/rate_limit_status.json', 'hash.json')
        assert @client.rate_limit_status
      end

      should "get totals" do
        stub_get('/1/account/totals.json', 'hash.json')
        assert @client.totals
      end

      should "get settings" do
        stub_get('/1/account/settings.json', 'hash.json')
        assert @client.settings
      end

      should "get favorites" do
        stub_get('/1/favorites.json', 'array.json')
        assert @client.favorites
      end

      should "create favorites" do
        stub_post('/1/favorites/create/25938088801.json', 'hash.json')
        assert @client.favorite_create(25938088801)
      end

      should "delete favorites" do
        stub_delete('/1/favorites/destroy/25938088801.json', 'hash.json')
        assert @client.favorite_destroy(25938088801)
      end

      should "enabled notifications" do
        stub_post('/1/notifications/follow.json', 'hash.json')
        assert @client.enable_notifications('sferik')
      end

      should "disable notifications" do
        stub_post('/1/notifications/leave.json', 'hash.json')
        assert @client.disable_notifications('sferik')
      end

      should "block a user" do
        stub_post('/1/blocks/create.json', 'hash.json')
        assert @client.block('sferik')
      end

      should "unblock a user" do
        stub_delete('/1/blocks/destroy.json', 'hash.json')
        assert @client.unblock('sferik')
      end

      should "report a spammer" do
        stub_post('/1/report_spam.json', 'hash.json')
        assert @client.report_spam(:screen_name => 'lucaasvaz00')
      end
    end

    context "when using lists" do
      should "create a new list" do
        stub_post('/1/pengwynn/lists.json', 'hash.json')
        assert @client.list_create('pengwynn', {:name => 'Rubyists'})
      end

      should "update a list" do
        stub_put('/1/pengwynn/lists/rubyists.json', 'hash.json')
        assert @client.list_update('pengwynn', 'rubyists', {:name => 'Rubyists'})
      end

      should "delete a list" do
        stub_delete('/1/pengwynn/lists/rubyists.json', 'hash.json')
        assert @client.list_delete('pengwynn', 'rubyists')
      end

      should "get lists to which a user belongs" do
        stub_get('/1/pengwynn/lists/memberships.json', 'hash.json')
        assert @client.memberships('pengwynn')
      end

      should "get all lists" do
        stub_get('/1/lists/all.json', 'hash.json')
        assert @client.lists_subscribed
      end

      should "get list" do
        stub_get('/1/lists.json', 'hash.json')
        assert @client.lists
      end

      should "get lists by screen_name" do
        stub_get('/1/pengwynn/lists.json', 'hash.json')
        assert @client.lists('pengwynn')
      end

      should "get lists with a cursor" do
        stub_get('/1/lists.json?cursor=-1', 'hash.json')
        assert @client.lists(:cursor => -1)
      end

      should "get lists by screen_name with a cursor" do
        stub_get('/1/pengwynn/lists.json?cursor=-1', 'hash.json')
        assert @client.lists('pengwynn', :cursor => -1)
      end

      should "get suggestions" do
        stub_get('/1/suggestions.json', 'array.json')
        assert @client.suggestions
      end

      should "get suggestions by category_slug" do
        stub_get('/1/users/suggestions/technology/members.json', 'array.json')
        assert @client.suggestions('technology')
      end

      should "get suggestions with a cursor" do
        stub_get('/1/suggestions.json?cursor=-1', 'array.json')
        assert @client.suggestions(:cursor => -1)
      end

      should "get suggestions by category_slug with a cursor" do
        stub_get('/1/users/suggestions/technology/members.json?cursor=-1', 'array.json')
        assert @client.suggestions('technology', :cursor => -1)
      end

      should "get list details" do
        stub_get('/1/pengwynn/lists/rubyists.json', 'hash.json')
        assert @client.list('pengwynn', 'rubyists')
      end

      should "get list timeline" do
        stub_get('/1/pengwynn/lists/rubyists/statuses.json', 'array.json')
        assert @client.list_timeline('pengwynn', 'rubyists')
      end

      should "limit number of tweets in list timeline" do
        stub_get('/1/pengwynn/lists/rubyists/statuses.json?per_page=1', 'array.json')
        assert @client.list_timeline('pengwynn', 'rubyists', :per_page => 1)
      end

      should "paginate through the timeline" do
        stub_get('/1/pengwynn/lists/rubyists/statuses.json?page=1&per_page=1', 'array.json')
        stub_get('/1/pengwynn/lists/rubyists/statuses.json?page=2&per_page=1', 'array.json')
        assert @client.list_timeline('pengwynn', 'rubyists', {:page => 1, :per_page => 1})
        assert @client.list_timeline('pengwynn', 'rubyists', {:page => 2, :per_page => 1})
      end

      should "get list members" do
        stub_get('/1/pengwynn/rubyists/members.json', 'hash.json')
        assert @client.list_members('pengwynn', 'rubyists')
      end

      should "add a member to a list" do
        stub_post('/1/pengwynn/rubyists/members.json', 'hash.json')
        assert @client.list_add_member('pengwynn', 'rubyists', 4243)
      end

      should "remove a member from a list" do
        stub_delete('/1/pengwynn/rubyists/members.json?id=4243', 'hash.json')
        assert @client.list_remove_member('pengwynn', 'rubyists', 4243)
      end

      should "check if a user is member of a list" do
        stub_get('/1/pengwynn/rubyists/members/4243.json', 'hash.json')
        assert @client.is_list_member?('pengwynn', 'rubyists', 4243)
      end

      should "get list subscribers" do
        stub_get('/1/pengwynn/rubyists/subscribers.json', 'hash.json')
        assert @client.list_subscribers('pengwynn', 'rubyists')
      end

      should "subscribe to a list" do
        stub_post('/1/pengwynn/rubyists/subscribers.json', 'hash.json')
        assert @client.list_subscribe('pengwynn', 'rubyists')
      end

      should "unsubscribe from a list" do
        stub_delete('/1/pengwynn/rubyists/subscribers.json', 'hash.json')
        assert @client.list_unsubscribe('pengwynn', 'rubyists')
      end

      should "get a members list subscriptions" do
        stub_get('/1/pengwynn/lists/subscriptions.json', 'hash.json')
        assert @client.subscriptions('pengwynn')
      end
    end

    context "when using saved searches" do
      should "retrieve my saved searches" do
        stub_get('/1/saved_searches.json', 'array.json')
        assert @client.saved_searches
      end

      should "retrieve a saved search by id" do
        stub_get('/1/saved_searches/show/7095598.json', 'hash.json')
        assert @client.saved_search(7095598)
      end

      should "create a saved search" do
        stub_post('/1/saved_searches/create.json', 'hash.json')
        assert @client.saved_search_create('great danes')
      end

      should "delete a saved search" do
        stub_delete('/1/saved_searches/destroy/7095598.json', 'hash.json')
        assert @client.saved_search_destroy(7095598)
      end
    end

  end
end
