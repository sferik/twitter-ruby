require 'test_helper'

class TrendsTest < Test::Unit::TestCase
  include Twitter

  context "Getting current trends" do
    should "work" do
      stub_get 'http://api.twitter.com/1/trends/current.json', 'trends_current.json'
      trends = Twitter::Trends.new.current
      assert_equal 10, trends.size
      assert_equal '#musicmonday', trends[0].name
      assert_equal '#musicmonday', trends[0].query
      assert_equal '#newdivide', trends[1].name
      assert_equal '#newdivide', trends[1].query
    end

    should "be able to exclude hashtags" do
      stub_get 'http://api.twitter.com/1/trends/current.json?exclude=hashtags', 'trends_current_exclude.json'
      trends = Twitter::Trends.new.current(:exclude => 'hashtags')
      assert_equal 10, trends.size
      assert_equal 'New Divide', trends[0].name
      assert_equal %Q(\"New Divide\"), trends[0].query
      assert_equal 'Star Trek', trends[1].name
      assert_equal %Q(\"Star Trek\"), trends[1].query
    end
  end

  context "Getting daily trends" do
    should "work" do
      stub_get 'http://api.twitter.com/1/trends/daily.json?', 'trends_daily.json'
      trends = Twitter::Trends.new.daily
      assert_equal 480, trends.size
      assert_equal '#3turnoffwords', trends[0].name
      assert_equal '#3turnoffwords', trends[0].query
    end

    should "be able to exclude hastags" do
      stub_get 'http://api.twitter.com/1/trends/daily.json?exclude=hashtags', 'trends_daily_exclude.json'
      trends = Twitter::Trends.new.daily(:exclude => 'hashtags')
      assert_equal 480, trends.size
      assert trends.map{|trend| trend.name}.include? 'Kobe'
      assert trends.map{|trend| trend.query}.include? %Q(Kobe)
    end

    should "be able to get for specific date (with date string)" do
      stub_get 'http://api.twitter.com/1/trends/daily.json?date=2009-05-01', 'trends_daily_date.json'
      trends = Twitter::Trends.new.daily(:date => '2009-05-01')
      assert_equal 440, trends.size
      assert trends.map{|trend| trend.name}.include? 'Swine Flu'
      assert trends.map{|trend| trend.query}.include? %Q(\"Swine Flu\" OR Flu)
    end

    should "be able to get for specific date (with date object)" do
      stub_get 'http://api.twitter.com/1/trends/daily.json?date=2009-05-01', 'trends_daily_date.json'
      trends = Twitter::Trends.new.daily(:date => Date.new(2009, 5, 1))
      assert_equal 440, trends.size
      assert trends.map{|trend| trend.name}.include? 'Swine Flu'
      assert trends.map{|trend| trend.query}.include? %Q(\"Swine Flu\" OR Flu)
    end
  end

  context "Getting weekly trends" do
    should "work" do
      stub_get 'http://api.twitter.com/1/trends/weekly.json?', 'trends_weekly.json'
      trends = Twitter::Trends.new.weekly
      assert_equal 210, trends.size
      assert trends.map{|trend| trend.name}.include? "Grey's Anatomy"
      assert trends.map{|trend| trend.query}.include? %Q(\"Grey's Anatomy\")
    end

    should "be able to exclude hastags" do
      stub_get 'http://api.twitter.com/1/trends/weekly.json?exclude=hashtags', 'trends_weekly_exclude.json'
      trends = Twitter::Trends.new.weekly(:exclude => 'hashtags')
      assert_equal 210, trends.size
      assert trends.map{|trend| trend.name}.include? "Grey's Anatomy"
      assert trends.map{|trend| trend.query}.include? %Q(\"Grey's Anatomy\")
    end

    should "be able to get for specific date (with date string)" do
      stub_get 'http://api.twitter.com/1/trends/weekly.json?date=2009-05-01', 'trends_weekly_date.json'
      trends = Twitter::Trends.new.weekly(:date => '2009-05-01')
      assert_equal 210, trends.size
      assert trends.map{|trend| trend.name}.include? 'Swine Flu'
      assert trends.map{|trend| trend.query}.include? %Q(\"Swine Flu\")
    end

    should "be able to get for specific date (with date object)" do
      stub_get 'http://api.twitter.com/1/trends/weekly.json?date=2009-05-01', 'trends_weekly_date.json'
      trends = Twitter::Trends.new.weekly(:date => Date.new(2009, 5, 1))
      assert_equal 210, trends.size
      assert trends.map{|trend| trend.name}.include? 'Swine Flu'
      assert trends.map{|trend| trend.query}.include? %Q(\"Swine Flu\")
    end
  end

  context "Getting local trends" do

    should "return a list of available locations" do
      stub_get 'http://api.twitter.com/1/trends/available.json?lat=33.237593417&lng=-96.960559033', 'trends_available.json'
      locations = Twitter::Trends.new.available(:lat => 33.237593417, :lng => -96.960559033)
      assert_equal 'Ireland', locations.first.country
      assert_equal 12, locations.first.placeType.code
    end

    should "return a list of trends for a given location" do
      stub_get 'http://api.twitter.com/1/trends/2487956.json', 'trends_location.json'
      trends = Twitter::Trends.new.for_location(2487956).first.trends
      assert_equal 'Gmail', trends.last.name
    end
  end

end
