require 'test_helper'

class TrendsTest < Test::Unit::TestCase
  include Twitter

  context "Getting current trends" do
    should "work" do
      stub_get('/1/trends/current.json', 'trends_current.json')
      assert Twitter::Trends.current
    end

    should "exclude hashtags" do
      stub_get('/1/trends/current.json?exclude=hashtags', 'trends_current_exclude.json')
      assert Twitter::Trends.current(:exclude => 'hashtags')
    end
  end

  context "Getting daily trends" do
    should "work" do
      stub_get('/1/trends/daily.json', 'trends_daily.json')
      assert Twitter::Trends.daily
    end

    should "exclude hastags" do
      stub_get('/1/trends/daily.json?exclude=hashtags', 'trends_daily_exclude.json')
      assert Twitter::Trends.daily(:exclude => 'hashtags')
    end

    should "get for specific date (with date string)" do
      stub_get('/1/trends/daily.json?date=2009-05-01', 'trends_daily_date.json')
      assert Twitter::Trends.daily(:date => '2009-05-01')
    end

    should "get for specific date (with date object)" do
      stub_get('/1/trends/daily.json?date=2009-05-01', 'trends_daily_date.json')
      assert Twitter::Trends.daily(:date => Date.new(2009, 5, 1))
    end
  end

  context "Getting weekly trends" do
    should "work" do
      stub_get('/1/trends/weekly.json?', 'trends_weekly.json')
      assert Twitter::Trends.weekly
    end

    should "exclude hastags" do
      stub_get('/1/trends/weekly.json?exclude=hashtags', 'trends_weekly_exclude.json')
      assert Twitter::Trends.weekly(:exclude => 'hashtags')
    end

    should "get for specific date (with date string)" do
      stub_get('/1/trends/weekly.json?date=2009-05-01', 'trends_weekly_date.json')
      assert Twitter::Trends.weekly(:date => '2009-05-01')
    end

    should "get for specific date (with date object)" do
      stub_get('/1/trends/weekly.json?date=2009-05-01', 'trends_weekly_date.json')
      assert Twitter::Trends.weekly(:date => Date.new(2009, 5, 1))
    end
  end

  context "Getting local trends" do
    should "return a list of available locations" do
      stub_get('/1/trends/available.json?lat=33.237593417&lng=-96.960559033', 'array.json')
      assert Twitter::Trends.available(:lat => 33.237593417, :lng => -96.960559033)
    end

    should "return a list of trends for a given location" do
      stub_get('/1/trends/2487956.json', 'array.json')
      assert Twitter::Trends.for_location(2487956)
    end
  end

end
