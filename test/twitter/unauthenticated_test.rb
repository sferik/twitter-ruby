require 'test_helper'

class UnauthenticatedTest < Test::Unit::TestCase
  include Twitter

  should "get the firehose" do
    stub_get('/1/statuses/public_timeline.json', 'array.json')
    assert Twitter.firehose
  end

  should "get a user by user id" do
    stub_get('/1/users/show/7505382.json', 'user.json')
    assert Twitter.user(7505382)
  end

  should "get a user by screen_name" do
    stub_get('/1/users/show/sferik.json', 'user.json')
    assert Twitter.user('sferik')
  end

  should "get suggestions" do
    stub_get('/1/suggestions.json', 'array.json')
    assert Twitter.suggestions
  end

  should "get suggestions by category_slug" do
    stub_get('/1/users/suggestions/technology/members.json', 'array.json')
    assert Twitter.suggestions('technology')
  end

  should "get suggestions with a cursor" do
    stub_get('/1/suggestions.json?cursor=-1', 'array.json')
    assert Twitter.suggestions(:cursor => -1)
  end

  should "get suggestions by category_slug with a cursor" do
    stub_get('/1/users/suggestions/technology/members.json?cursor=-1', 'array.json')
    assert Twitter.suggestions('technology', :cursor => -1)
  end

  should "get retweeted-to-user timeline by screen_name" do
    stub_get('/1/statuses/retweeted_to_user.json?screen_name=sferik', 'array.json')
    assert Twitter.retweeted_to_user('sferik')
  end

  should "get retweeted-to-user timeline by user_id" do
    stub_get('/1/statuses/retweeted_to_user.json?user_id=7505382', 'array.json')
    assert Twitter.retweeted_to_user(7505382)
  end

  should "get retweeted-by-user timeline by screen_name" do
    stub_get('/1/statuses/retweeted_by_user.json?screen_name=sferik', 'array.json')
    assert Twitter.retweeted_by_user('sferik')
  end

  should "get retweeted-by-user timeline by user_id" do
    stub_get('/1/statuses/retweeted_by_user.json?user_id=7505382', 'array.json')
    assert Twitter.retweeted_by_user(7505382)
  end

  should "get a status" do
    stub_get('/1/statuses/show/1533815199.json', 'status_show.json')
    assert Twitter.status(1533815199)
  end

  should "raise NotFound for a request to a deleted or nonexistent status" do
    stub_get('/1/statuses/show/1.json', 'not_found.json', 404)
    assert_raise Twitter::NotFound do
      Twitter.status(1)
    end
  end

  should "get a user timeline" do
    stub_get('/1/statuses/user_timeline.json?screen_name=sferik', 'array.json')
    assert Twitter.timeline('sferik')
  end

  should "raise Unauthorized for a request to a protected user's timeline" do
    stub_get('/1/statuses/user_timeline.json?screen_name=protected', 'unauthorized.json', 401)
    assert_raise Twitter::Unauthorized do
      Twitter.timeline('protected')
    end
  end

  should "get friend ids" do
    stub_get('/1/friends/ids.json?screen_name=sferik', 'array.json')
    assert Twitter.friend_ids('sferik')
  end

  should "raise Unauthorized for a request to a protected user's friend ids" do
    stub_get('/1/friends/ids.json?screen_name=protected', 'unauthorized.json', 401)
    assert_raise Twitter::Unauthorized do
      Twitter.friend_ids('protected')
    end
  end

  should "get follower ids" do
    stub_get('/1/followers/ids.json?screen_name=sferik', 'array.json')
    assert Twitter.follower_ids('sferik')
  end

  should "raise Unauthorized for a request to a protected user's follower ids" do
    stub_get('/1/followers/ids.json?screen_name=protected', 'unauthorized.json', 401)
    assert_raise Twitter::Unauthorized do
      Twitter.follower_ids('protected')
    end
  end

  context "when using lists" do
    should "get all lists with screen_name" do
      stub_get('/1/lists/all.json?screen_name=pengwynn', 'lists.json')
      assert Twitter.lists_subscribed('pengwynn').lists
    end

    should "get all lists with user_id" do
      stub_get('/1/lists/all.json?user_id=14100886', 'lists.json')
      assert Twitter.lists_subscribed(14100886).lists
    end

    should "get list timeline" do
      stub_get('/1/pengwynn/lists/rubyists/statuses.json', 'array.json')
      assert Twitter.list_timeline('pengwynn', 'rubyists')
    end

    should "get list timeline with limit" do
      stub_get('/1/pengwynn/lists/rubyists/statuses.json?per_page=1', 'array.json')
      assert Twitter.list_timeline('pengwynn', 'rubyists', :per_page => 1)
    end

    should "get list timeline with pagination" do
      stub_get('/1/pengwynn/lists/rubyists/statuses.json?page=1&per_page=1', 'array.json')
      stub_get('/1/pengwynn/lists/rubyists/statuses.json?page=2&per_page=1', 'array.json')
      assert Twitter.list_timeline('pengwynn', 'rubyists', {:page => 1, :per_page => 1})
      assert Twitter.list_timeline('pengwynn', 'rubyists', {:page => 2, :per_page => 1})
    end
  end

end
