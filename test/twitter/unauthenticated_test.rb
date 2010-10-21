require 'test_helper'

class UnauthenticatedTest < Test::Unit::TestCase

  %w(json xml).each do |format|
    context "with request format #{format}" do
      setup do
        Twitter.format = format
      end

      should "get public timeline" do
        stub_get("statuses/public_timeline.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.public_timeline
      end

      should "get a user by user id" do
        stub_get("users/show/7505382.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.user(7505382)
      end

      should "get a user by screen_name" do
        stub_get("users/show/sferik.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.user('sferik')
      end

      should "get a user's profile image" do
        stub_get("users/profile_image/ratherchad.#{format}", "n605431196_2079896_558_normal.jpg", "image/jpeg", 302, "http://a3.twimg.com/profile_images/1107413683/n605431196_2079896_558_normal.jpg")
        assert Twitter.profile_image('ratherchad')
      end

      should "get suggestions" do
        stub_get("users/suggestions.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.suggestions
      end

      should "get suggestions by category_slug" do
        stub_get("users/suggestions/technology.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.suggestions('technology')
      end

      should "get suggestions with a cursor" do
        stub_get("users/suggestions.#{format}?cursor=-1", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.suggestions(:cursor => -1)
      end

      should "get suggestions by category_slug with a cursor" do
        stub_get("users/suggestions/technology.#{format}?cursor=-1", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.suggestions('technology', :cursor => -1)
      end

      should "get retweeted-to-user timeline by screen_name" do
        stub_get("statuses/retweeted_to_user.#{format}?screen_name=sferik", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.retweeted_to_user('sferik')
      end

      should "get retweeted-to-user timeline by user_id" do
        stub_get("statuses/retweeted_to_user.#{format}?user_id=7505382", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.retweeted_to_user(7505382)
      end

      should "get retweeted-by-user timeline by screen_name" do
        stub_get("statuses/retweeted_by_user.#{format}?screen_name=sferik", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.retweeted_by_user('sferik')
      end

      should "get retweeted-by-user timeline by user_id" do
        stub_get("statuses/retweeted_by_user.#{format}?user_id=7505382", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.retweeted_by_user(7505382)
      end

      should "get a status" do
        stub_get("statuses/show/1533815199.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.status(1533815199)
      end

      should "get a user timeline" do
        stub_get("statuses/user_timeline.#{format}?screen_name=sferik", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.timeline('sferik')
      end

      should "get friend ids" do
        stub_get("friends/ids.#{format}?screen_name=sferik", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.friend_ids('sferik')
      end

      should "get follower ids" do
        stub_get("followers/ids.#{format}?screen_name=sferik", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.follower_ids('sferik')
      end

      context "when using lists" do
        should "get all lists with screen_name" do
          stub_get("lists/all.#{format}?screen_name=pengwynn", "hash.#{format}", "application/#{format}; charset=utf-8")
          assert Twitter.lists_subscribed('pengwynn')
        end

        should "get all lists with user_id" do
          stub_get("lists/all.#{format}?user_id=14100886", "hash.#{format}", "application/#{format}; charset=utf-8")
          assert Twitter.lists_subscribed(14100886)
        end

        should "get list timeline" do
          stub_get("pengwynn/lists/rubyists/statuses.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
          assert Twitter.list_timeline('pengwynn', 'rubyists')
        end

        should "get list timeline with limit" do
          stub_get("pengwynn/lists/rubyists/statuses.#{format}?per_page=1", "hash.#{format}", "application/#{format}; charset=utf-8")
          assert Twitter.list_timeline('pengwynn', 'rubyists', :per_page => 1)
        end

        should "get list timeline with pagination" do
          stub_get("pengwynn/lists/rubyists/statuses.#{format}?page=1&per_page=1", "hash.#{format}", "application/#{format}; charset=utf-8")
          stub_get("pengwynn/lists/rubyists/statuses.#{format}?page=2&per_page=1", "hash.#{format}", "application/#{format}; charset=utf-8")
          assert Twitter.list_timeline('pengwynn', 'rubyists', {:page => 1, :per_page => 1})
          assert Twitter.list_timeline('pengwynn', 'rubyists', {:page => 2, :per_page => 1})
        end
      end

      should "get retweets" do
        stub_get("statuses/retweets/1533815199.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.retweets(1533815199)
      end

      should "get friends" do
        stub_get("statuses/friends.#{format}?screen_name=laserlemon", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.friends('laserlemon')
      end

      should "get followers" do
        stub_get("statuses/followers.#{format}?screen_name=laserlemon", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.followers('laserlemon')
      end

      should "get rate limit status" do
        stub_get("account/rate_limit_status.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.rate_limit_status
      end

      should "get terms of service" do
        stub_get("legal/tos.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.tos
      end

      should "get privacy policy" do
        stub_get("legal/privacy.#{format}", "hash.#{format}", "application/#{format}; charset=utf-8")
        assert Twitter.privacy
      end
    end
  end
end
