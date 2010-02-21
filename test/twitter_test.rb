require 'test_helper'

class TwitterTest < Test::Unit::TestCase
  should "have firehose method for public timeline" do
    stub_get('http://twitter.com:80/statuses/public_timeline.json', 'firehose.json')
    hose = Twitter.firehose
    hose.size.should == 20
    first = hose.first
    first.text.should == '#torrents Ultimativer Flirt Guide - In 10 Minuten jede Frau erobern: Ultimativer Flirt Guide - In 10 Mi.. http://tinyurl.com/d3okh4'
    first.user.name.should == 'P2P Torrents'
  end
  
  should "have user method for unauthenticated calls to get a user's information" do
    stub_get('http://twitter.com:80/users/show/jnunemaker.json', 'user.json')
    user = Twitter.user('jnunemaker')
    user.name.should == 'John Nunemaker'
    user.description.should == 'Loves his wife, ruby, notre dame football and iu basketball'
  end
  
  should "have status method for unauthenticated calls to get a status" do
    stub_get('http://twitter.com:80/statuses/show/1533815199.json', 'status_show.json')
    status = Twitter.status(1533815199)
    status.id.should == 1533815199
    status.text.should == 'Eating some oatmeal and butterscotch cookies with a cold glass of milk for breakfast. Tasty!'
  end
  
  should "have a timeline method for unauthenticated calls to get a user's timeline" do
    stub_get('http://twitter.com:80/statuses/user_timeline/jnunemaker.json', 'user_timeline.json')
    statuses = Twitter.timeline('jnunemaker')
    statuses.first.id.should == 1445986256
    statuses.first.user.screen_name.should == 'jnunemaker'
    
  end
  
  should "have friend_ids method" do
    stub_get('http://twitter.com:80/friends/ids/jnunemaker.json', 'friend_ids.json')
    ids = Twitter.friend_ids('jnunemaker')
    ids.size.should == 161
  end
  
  should "have follower_ids method" do
    stub_get('http://twitter.com:80/followers/ids/jnunemaker.json', 'follower_ids.json')
    ids = Twitter.follower_ids('jnunemaker')
    ids.size.should == 1252
  end
  
  context "when using lists" do
    
    should "be able to view list timeline" do
      stub_get('http://api.twitter.com:80/1/pengwynn/lists/rubyists/statuses.json', 'list_statuses.json')
      tweets = Twitter.list_timeline('pengwynn', 'rubyists')
      tweets.size.should == 20
      tweets.first.id.should == 5272535583
      tweets.first.user.name.should == 'John Nunemaker'
    end
    
    should "be able to limit number of tweets in list timeline" do
      stub_get('http://api.twitter.com:80/1/pengwynn/lists/rubyists/statuses.json?per_page=1', 'list_statuses_1_1.json')
      tweets = Twitter.list_timeline('pengwynn', 'rubyists', :per_page => 1)
      tweets.size.should == 1
      tweets.first.id.should == 5272535583
      tweets.first.user.name.should == 'John Nunemaker'
    end
    
    should "be able to paginate through the timeline" do
      stub_get('http://api.twitter.com:80/1/pengwynn/lists/rubyists/statuses.json?page=1&per_page=1', 'list_statuses_1_1.json')
      stub_get('http://api.twitter.com:80/1/pengwynn/lists/rubyists/statuses.json?page=2&per_page=1', 'list_statuses_2_1.json')
      tweets = Twitter.list_timeline('pengwynn', 'rubyists', { :page => 1, :per_page => 1 })
      tweets.size.should == 1
      tweets.first.id.should == 5272535583
      tweets.first.user.name.should == 'John Nunemaker'
      tweets = Twitter.list_timeline('pengwynn', 'rubyists', { :page => 2, :per_page => 1 })
      tweets.size.should == 1
      tweets.first.id.should == 5264324712
      tweets.first.user.name.should == 'John Nunemaker'
    end
    
  end
end
