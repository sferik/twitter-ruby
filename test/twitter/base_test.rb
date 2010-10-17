require 'test_helper'

class AuthenticatedTest < Test::Unit::TestCase

  context "base" do
    setup do
      @client = Twitter::Authenticated.new
    end

    context "initialize" do
      should "accept oauth params" do
        Twitter.configure do |config|
          config.consumer_key = 'ctoken'
          config.consumer_secret = 'csecret'
          config.access_key = 'atoken'
          config.access_secret = 'asecret'
        end
        client = Twitter::Authenticated.new
        assert_equal client.consumer_key, 'ctoken'
      end

      should "override oauth params" do
        oauth = {
          :access_key      => "atoken",
          :access_secret   => "s3cr3t"
        }
        client = Twitter::Authenticated.new(oauth)
        assert_equal 's3cr3t', client.access_secret
      end
    end

    %w(json xml).each do |format|
      context "with request format #{format}" do
        setup do
          Twitter.format = format
        end

        context "hitting the API" do
          should "get home timeline" do
            stub_get("/1/statuses/home_timeline.#{format}", "array.#{format}")
            assert @client.home_timeline
          end

          should "get friends timeline" do
            stub_get("/1/statuses/friends_timeline.#{format}", "array.#{format}")
            assert @client.friends_timeline
          end

          should "get user timeline" do
            stub_get("/1/statuses/user_timeline.#{format}", "array.#{format}")
            assert @client.user_timeline
          end

          should "get retweeted-to-user timeline by screen_name" do
            stub_get("/1/statuses/retweeted_to_user.#{format}?screen_name=sferik", "array.#{format}")
            assert @client.retweeted_to_user('sferik')
          end

          should "get retweeted-to-user timeline by user_id" do
            stub_get("/1/statuses/retweeted_to_user.#{format}?user_id=7505382", "array.#{format}")
            assert @client.retweeted_to_user(7505382)
          end

          should "get retweeted-by-user timeline by screen_name" do
            stub_get("/1/statuses/retweeted_by_user.#{format}?screen_name=sferik", "array.#{format}")
            assert @client.retweeted_by_user('sferik')
          end

          should "get retweeted-by-user timeline by user id" do
            stub_get("/1/statuses/retweeted_by_user.#{format}?user_id=7505382", "array.#{format}")
            assert @client.retweeted_by_user(7505382)
          end

          should "get a status" do
            stub_get("/1/statuses/show/25938088801.#{format}", "hash.#{format}")
            assert @client.status(25938088801)
          end

          should "update a status" do
            stub_post("/1/statuses/update.#{format}", "hash.#{format}")
            assert @client.update('@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!')
          end

          should "delete a status" do
            stub_delete("/1/statuses/destroy/25938088801.#{format}", "hash.#{format}")
            assert @client.status_destroy(25938088801)
          end

          should "retweet a status" do
            stub_post("/1/statuses/retweet/6235127466.#{format}", "hash.#{format}")
            assert @client.retweet(6235127466)
          end

          should "get retweets of a status" do
            stub_get("/1/statuses/retweets/6192831130.#{format}", "array.#{format}")
            assert @client.retweets(6192831130)
          end

          should "get mentions" do
            stub_get("/1/statuses/mentions.#{format}", "array.#{format}")
            assert @client.mentions
          end

          should "get retweets by me" do
            stub_get("/1/statuses/retweeted_by_me.#{format}", "array.#{format}")
            assert @client.retweeted_by_me
          end

          should "get retweets to me" do
            stub_get("/1/statuses/retweeted_to_me.#{format}", "array.#{format}")
            assert @client.retweeted_to_me
          end

          should "get retweets of me" do
            stub_get("/1/statuses/retweets_of_me.#{format}", "array.#{format}")
            assert @client.retweets_of_me
          end

          should "get users who retweeted a tweet" do
            stub_get("/1/statuses/24519048728/retweeted_by.#{format}", "array.#{format}")
            assert @client.retweeters_of(24519048728)
          end

          should "get ids of users who retweeted a tweet" do
            stub_get("/1/statuses/24519048728/retweeted_by/ids.#{format}", "array.#{format}")
            assert @client.retweeters_of(24519048728, :ids_only => true)
          end

          should "get follower ids" do
            stub_get("/1/followers/ids.#{format}", "array.#{format}")
            assert @client.follower_ids
          end

          should "get friend ids" do
            stub_get("/1/friends/ids.#{format}", "array.#{format}")
            assert @client.friend_ids
          end

          should "get a user by user id" do
            stub_get("/1/users/show.#{format}?user_id=7505382", "hash.#{format}")
            assert @client.user(7505382)
          end

          should "get a user by screen_name" do
            stub_get("/1/users/show.#{format}?screen_name=sferik", "hash.#{format}")
            assert @client.user('sferik')
          end

          should "get a user's profile image" do
            stub_get("/1/users/profile_image/ratherchad.#{format}", "n605431196_2079896_558_normal.jpg", 302, "http://a3.twimg.com/profile_images/1107413683/n605431196_2079896_558_normal.jpg")
            assert @client.profile_image('ratherchad')
          end

          should "get single user with the users method" do
            stub_get("/1/users/lookup.#{format}?screen_name=sferik", "array.#{format}")
            assert @client.users('sferik')
          end

          should "get users in bulk" do
            stub_get("/1/users/lookup.#{format}?user_id=59593%2C774010&screen_name=sferik", "array.#{format}")
            assert @client.users(['sferik', 59593, 774010])
          end

          should "search people" do
            stub_get("/1/users/search.#{format}?q=Erik%20Michaels-Ober", "array.#{format}")
            assert @client.user_search('Erik Michaels-Ober')
          end

          should "get a direct message" do
            stub_get("/1/direct_messages/show/1694868698.#{format}", "array.#{format}")
            assert @client.direct_message(1694868698)
          end

          should "get direct messages" do
            stub_get("/1/direct_messages.#{format}", "array.#{format}")
            assert @client.direct_messages
          end

          should "get direct messages sent" do
            stub_get("/1/direct_messages/sent.#{format}", "array.#{format}")
            assert @client.direct_messages_sent
          end

          should "create a direct message" do
            stub_post("/1/direct_messages/new.#{format}", "array.#{format}")
            assert @client.direct_message_create('hurrycane', "Erik, Could you please ask Yehuda for the date when he will make the payment? I still haven't received the stipend. Thanks!")
          end

          should "delete a direct message" do
            stub_delete("/1/direct_messages/destroy/1694868698.#{format}", "array.#{format}")
            assert @client.direct_message_destroy(1694868698)
          end

          should "get a friendship" do
            stub_get("/1/friendships/show.#{format}?source_screen_name=dcrec1&target_screen_name=pengwynn", "hash.#{format}")
            assert @client.friendship(:source_screen_name => 'dcrec1', :target_screen_name => 'pengwynn')
          end

          should "get single friendship with the friendships method" do
            stub_get("/1/friendships/lookup.#{format}?screen_name=SarahPalinUSA", "array.#{format}")
            assert @client.friendships('SarahPalinUSA')
          end

          should "get friendships" do
            stub_get("/1/friendships/lookup.#{format}?user_id=33423%2C813286&screen_name=SarahPalinUSA", "array.#{format}")
            assert @client.friendships(['SarahPalinUSA', 33423, 813286])
          end

          should "create a friendship" do
            stub_post("/1/friendships/create.#{format}", "hash.#{format}")
            assert @client.friendship_create('sferik')
          end

          should "update a friendship" do
            stub_post("/1/friendships/update.#{format}", "hash.#{format}")
            assert @client.friendship_update('twitterapi', :device => true, :retweets => false)
          end

          should "delete a friendship" do
            stub_delete("/1/friendships/destroy.#{format}?screen_name=sferik", "hash.#{format}")
            assert @client.friendship_destroy('sferik')
          end

          should "test whether a friendship exists" do
            stub_get("/1/friendships/exists.#{format}?user_a=pengwynn&user_b=sferik", "true.#{format}")
            assert @client.friendship_exists?('pengwynn', 'sferik')
          end

          should "get followers' stauses" do
            stub_get("/1/statuses/followers.#{format}", "array.#{format}")
            assert @client.followers
          end

          should "get blocked users' IDs" do
            stub_get("/1/blocks/blocking/ids.#{format}", "array.#{format}")
            assert @client.blocked_ids
          end

          should "get an array of blocked users" do
            stub_get("/1/blocks/blocking.#{format}", "array.#{format}")
            assert @client.blocking
          end

          should "update profile colors" do
            stub_post("/1/account/update_profile_colors.#{format}", "hash.#{format}")
            assert @client.update_profile_colors(:profile_background_color => 'C0DEED')
          end

          should "update profile image" do
            stub_post("/1/account/update_profile_image.#{format}", "hash.#{format}")
            assert @client.update_profile_image(File.new(sample_image('me.jpeg')))
          end

          should "update background image" do
            stub_post("/1/account/update_profile_background_image.#{format}", "hash.#{format}")
            assert @client.update_profile_background(File.new(sample_image('nature02922-f1.2.jpeg')))
          end

          should "update profile" do
            stub_post("/1/account/update_profile.#{format}", "hash.#{format}")
            assert @client.update_profile(:location => 'San Francisco')
          end

          should "get related results" do
            stub_get("/1/related_results/show/25938088801.#{format}", "array.#{format}")
            assert @client.related_results(25938088801)
          end

          should "get rate limit status" do
            stub_get("/1/account/rate_limit_status.#{format}", "hash.#{format}")
            assert @client.rate_limit_status
          end

          should "get totals" do
            stub_get("/1/account/totals.#{format}", "hash.#{format}")
            assert @client.totals
          end

          should "get settings" do
            stub_get("/1/account/settings.#{format}", "hash.#{format}")
            assert @client.settings
          end

          should "get favorites" do
            stub_get("/1/favorites.#{format}", "array.#{format}")
            assert @client.favorites
          end

          should "create favorites" do
            stub_post("/1/favorites/create/25938088801.#{format}", "hash.#{format}")
            assert @client.favorite_create(25938088801)
          end

          should "delete favorites" do
            stub_delete("/1/favorites/destroy/25938088801.#{format}", "hash.#{format}")
            assert @client.favorite_destroy(25938088801)
          end

          should "enabled notifications" do
            stub_post("/1/notifications/follow.#{format}", "hash.#{format}")
            assert @client.enable_notifications('sferik')
          end

          should "disable notifications" do
            stub_post("/1/notifications/leave.#{format}", "hash.#{format}")
            assert @client.disable_notifications('sferik')
          end

          should "block a user" do
            stub_post("/1/blocks/create.#{format}", "hash.#{format}")
            assert @client.block('sferik')
          end

          should "unblock a user" do
            stub_delete("/1/blocks/destroy.#{format}", "hash.#{format}")
            assert @client.unblock('sferik')
          end

          should "report a spammer" do
            stub_post("/1/report_spam.#{format}", "hash.#{format}")
            assert @client.report_spam(:screen_name => 'lucaasvaz00')
          end
        end

        context "when using lists" do
          should "create a new list" do
            stub_post("/1/pengwynn/lists.#{format}", "hash.#{format}")
            assert @client.list_create('pengwynn', {:name => 'Rubyists'})
          end

          should "update a list" do
            stub_put("/1/pengwynn/lists/rubyists.#{format}", "hash.#{format}")
            assert @client.list_update('pengwynn', 'rubyists', {:name => 'Rubyists'})
          end

          should "delete a list" do
            stub_delete("/1/pengwynn/lists/rubyists.#{format}", "hash.#{format}")
            assert @client.list_delete('pengwynn', 'rubyists')
          end

          should "get lists to which a user belongs" do
            stub_get("/1/pengwynn/lists/memberships.#{format}", "hash.#{format}")
            assert @client.memberships('pengwynn')
          end

          should "get all lists" do
            stub_get("/1/lists/all.#{format}", "hash.#{format}")
            assert @client.lists_subscribed
          end

          should "get list" do
            stub_get("/1/lists.#{format}", "hash.#{format}")
            assert @client.lists
          end

          should "get lists by screen_name" do
            stub_get("/1/pengwynn/lists.#{format}", "hash.#{format}")
            assert @client.lists('pengwynn')
          end

          should "get lists with a cursor" do
            stub_get("/1/lists.#{format}?cursor=-1", "hash.#{format}")
            assert @client.lists(:cursor => -1)
          end

          should "get lists by screen_name with a cursor" do
            stub_get("/1/pengwynn/lists.#{format}?cursor=-1", "hash.#{format}")
            assert @client.lists('pengwynn', :cursor => -1)
          end

          should "get suggestions" do
            stub_get("/1/suggestions.#{format}", "array.#{format}")
            assert @client.suggestions
          end

          should "get suggestions by category_slug" do
            stub_get("/1/users/suggestions/technology/members.#{format}", "array.#{format}")
            assert @client.suggestions('technology')
          end

          should "get suggestions with a cursor" do
            stub_get("/1/suggestions.#{format}?cursor=-1", "array.#{format}")
            assert @client.suggestions(:cursor => -1)
          end

          should "get suggestions by category_slug with a cursor" do
            stub_get("/1/users/suggestions/technology/members.#{format}?cursor=-1", "array.#{format}")
            assert @client.suggestions('technology', :cursor => -1)
          end

          should "get list details" do
            stub_get("/1/pengwynn/lists/rubyists.#{format}", "hash.#{format}")
            assert @client.list('pengwynn', 'rubyists')
          end

          should "get list timeline" do
            stub_get("/1/pengwynn/lists/rubyists/statuses.#{format}", "array.#{format}")
            assert @client.list_timeline('pengwynn', 'rubyists')
          end

          should "limit number of tweets in list timeline" do
            stub_get("/1/pengwynn/lists/rubyists/statuses.#{format}?per_page=1", "array.#{format}")
            assert @client.list_timeline('pengwynn', 'rubyists', :per_page => 1)
          end

          should "paginate through the timeline" do
            stub_get("/1/pengwynn/lists/rubyists/statuses.#{format}?page=1&per_page=1", "array.#{format}")
            stub_get("/1/pengwynn/lists/rubyists/statuses.#{format}?page=2&per_page=1", "array.#{format}")
            assert @client.list_timeline('pengwynn', 'rubyists', {:page => 1, :per_page => 1})
            assert @client.list_timeline('pengwynn', 'rubyists', {:page => 2, :per_page => 1})
          end

          should "get list members" do
            stub_get("/1/pengwynn/rubyists/members.#{format}", "hash.#{format}")
            assert @client.list_members('pengwynn', 'rubyists')
          end

          should "add a member to a list" do
            stub_post("/1/pengwynn/rubyists/members.#{format}", "hash.#{format}")
            assert @client.list_add_member('pengwynn', 'rubyists', 4243)
          end

          should "remove a member from a list" do
            stub_delete("/1/pengwynn/rubyists/members.#{format}?id=4243", "hash.#{format}")
            assert @client.list_remove_member('pengwynn', 'rubyists', 4243)
          end

          should "check if a user is member of a list" do
            stub_get("/1/pengwynn/rubyists/members/4243.#{format}", "hash.#{format}")
            assert @client.is_list_member?('pengwynn', 'rubyists', 4243)
          end

          should "get list subscribers" do
            stub_get("/1/pengwynn/rubyists/subscribers.#{format}", "hash.#{format}")
            assert @client.list_subscribers('pengwynn', 'rubyists')
          end

          should "subscribe to a list" do
            stub_post("/1/pengwynn/rubyists/subscribers.#{format}", "hash.#{format}")
            assert @client.list_subscribe('pengwynn', 'rubyists')
          end

          should "unsubscribe from a list" do
            stub_delete("/1/pengwynn/rubyists/subscribers.#{format}", "hash.#{format}")
            assert @client.list_unsubscribe('pengwynn', 'rubyists')
          end

          should "get a members list subscriptions" do
            stub_get("/1/pengwynn/lists/subscriptions.#{format}", "hash.#{format}")
            assert @client.subscriptions('pengwynn')
          end
        end

        context "when using saved searches" do
          should "retrieve my saved searches" do
            stub_get("/1/saved_searches.#{format}", "array.#{format}")
            assert @client.saved_searches
          end

          should "retrieve a saved search by id" do
            stub_get("/1/saved_searches/show/7095598.#{format}", "hash.#{format}")
            assert @client.saved_search(7095598)
          end

          should "create a saved search" do
            stub_post("/1/saved_searches/create.#{format}", "hash.#{format}")
            assert @client.saved_search_create('great danes')
          end

          should "delete a saved search" do
            stub_delete("/1/saved_searches/destroy/7095598.#{format}", "hash.#{format}")
            assert @client.saved_search_destroy(7095598)
          end
        end
      end
    end
  end
end
