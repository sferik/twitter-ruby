require File.dirname(__FILE__) + '/../test_helper'

class TrendsTest < Test::Unit::TestCase
  include Twitter
  
  should "be able to get current trends" do
    stub_get('http://search.twitter.com:80/trends/current.json', 'trends_current.json')
    trends = Trends.current
    trends.size.should == 10
    trends[0].name.should == '#musicmonday'
    trends[0].query.should == '#musicmonday'
    trends[1].name.should == '#newdivide'
    trends[1].query.should == '#newdivide'
  end
  
  should "be able to exclude hashtags from current trends" do
    stub_get('http://search.twitter.com:80/trends/current.json?exclude=hashtags', 'trends_current_exclude.json')
    trends = Trends.current(:exclude => 'hashtags')
    trends.size.should == 10
    trends[0].name.should == 'New Divide'
    trends[0].query.should == %Q(\"New Divide\")
    trends[1].name.should == 'Star Trek'
    trends[1].query.should == %Q(\"Star Trek\")
  end
end