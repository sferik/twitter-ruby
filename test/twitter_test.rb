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
end
