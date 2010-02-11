require 'test_helper'

class TrendsTest < Test::Unit::TestCase
  include Twitter
  
  context "Getting current trends" do
    should "work" do
      stub_get 'http://search.twitter.com:80/trends/current.json', 'trends_current.json'
      trends = Trends.current
      trends.size.should == 10
      trends[0].name.should == '#musicmonday'
      trends[0].query.should == '#musicmonday'
      trends[1].name.should == '#newdivide'
      trends[1].query.should == '#newdivide'
    end
    
    should "be able to exclude hashtags" do
      stub_get 'http://search.twitter.com:80/trends/current.json?exclude=hashtags', 'trends_current_exclude.json'
      trends = Trends.current(:exclude => 'hashtags')
      trends.size.should == 10
      trends[0].name.should == 'New Divide'
      trends[0].query.should == %Q(\"New Divide\")
      trends[1].name.should == 'Star Trek'
      trends[1].query.should == %Q(\"Star Trek\")
    end
  end
  
  context "Getting daily trends" do
    should "work" do
      stub_get 'http://search.twitter.com:80/trends/daily.json?', 'trends_daily.json'
      trends = Trends.daily
      trends.size.should == 480
      trends[0].name.should == '#3turnoffwords'
      trends[0].query.should == '#3turnoffwords'
    end
    
    should "be able to exclude hastags" do
      stub_get 'http://search.twitter.com:80/trends/daily.json?exclude=hashtags', 'trends_daily_exclude.json'
      trends = Trends.daily(:exclude => 'hashtags')
      trends.size.should == 480
      trends[0].name.should == 'Kobe'
      trends[0].query.should == %Q(Kobe)
    end
    
    should "be able to get for specific date (with date string)" do
      stub_get 'http://search.twitter.com:80/trends/daily.json?date=2009-05-01', 'trends_daily_date.json'
      trends = Trends.daily(:date => '2009-05-01')
      trends.size.should == 440
      trends[0].name.should == 'Swine Flu'
      trends[0].query.should == %Q(\"Swine Flu\" OR Flu)
    end
    
    should "be able to get for specific date (with date object)" do
      stub_get 'http://search.twitter.com:80/trends/daily.json?date=2009-05-01', 'trends_daily_date.json'
      trends = Trends.daily(:date => Date.new(2009, 5, 1))
      trends.size.should == 440
      trends[0].name.should == 'Swine Flu'
      trends[0].query.should == %Q(\"Swine Flu\" OR Flu)
    end
  end
  
  context "Getting weekly trends" do
    should "work" do
      stub_get 'http://search.twitter.com:80/trends/weekly.json?', 'trends_weekly.json'
      trends = Trends.weekly
      trends.size.should == 210
      trends[0].name.should == 'Happy Mothers Day'
      trends[0].query.should == %Q(\"Happy Mothers Day\" OR \"Mothers Day\")
    end
    
    should "be able to exclude hastags" do
      stub_get 'http://search.twitter.com:80/trends/weekly.json?exclude=hashtags', 'trends_weekly_exclude.json'
      trends = Trends.weekly(:exclude => 'hashtags')
      trends.size.should == 210
      trends[0].name.should == 'Happy Mothers Day'
      trends[0].query.should == %Q(\"Happy Mothers Day\" OR \"Mothers Day\")
    end
    
    should "be able to get for specific date (with date string)" do
      stub_get 'http://search.twitter.com:80/trends/weekly.json?date=2009-05-01', 'trends_weekly_date.json'
      trends = Trends.weekly(:date => '2009-05-01')
      trends.size.should == 210
      trends[0].name.should == 'TGIF'
      trends[0].query.should == 'TGIF'
    end
    
    should "be able to get for specific date (with date object)" do
      stub_get 'http://search.twitter.com:80/trends/weekly.json?date=2009-05-01', 'trends_weekly_date.json'
      trends = Trends.weekly(:date => Date.new(2009, 5, 1))
      trends.size.should == 210
      trends[0].name.should == 'TGIF'
      trends[0].query.should == 'TGIF'
    end
  end
  
  context "Getting local trends" do

    should "return a list of available locations" do
      stub_get 'http://api.twitter.com/1/trends/available.json?lat=33.237593417&lng=-96.960559033', 'trends_available.json'
      locations = Trends.available(:lat => 33.237593417, :lng => -96.960559033)
      locations.first.country.should == 'Ireland'
      locations.first.placeType.code.should == 12
    end
    
    should "return a list of trends for a given location" do
      stub_get 'http://api.twitter.com/1/trends/2487956.json', 'trends_location.json'
      trends = Trends.for_location(2487956).first.trends
      trends.last.name.should == 'Gmail'
    end
  end
  
end