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
end
