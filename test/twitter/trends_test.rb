require 'test_helper'

class TrendsTest < Test::Unit::TestCase
  context "Getting current trends" do
    setup do
      Twitter.format = 'json'
      @client = Twitter::Trends.new
    end

    should "work" do
      stub_get("trends/current.json", "hash.json")
      assert @client.current
    end

    should "exclude hashtags" do
      stub_get("trends/current.json?exclude=hashtags", "hash.json")
      assert @client.current(:exclude => 'hashtags')
    end
  end

  context "Getting daily trends" do
    setup do
      Twitter.format = 'json'
      @client = Twitter::Trends.new
    end

    should "work" do
      stub_get("trends/daily.json", "hash.json")
      assert @client.daily
    end

    should "exclude hastags" do
      stub_get("trends/daily.json?exclude=hashtags", "hash.json")
      assert @client.daily(:exclude => 'hashtags')
    end

    should "get for specific date (with date string)" do
      stub_get("trends/daily.json?date=2009-05-01", "hash.json")
      assert @client.daily(:date => '2009-05-01')
    end

    should "get for specific date (with date object)" do
      stub_get("trends/daily.json?date=2009-05-01", "hash.json")
      assert @client.daily(:date => Date.new(2009, 5, 1))
    end
  end

  context "Getting weekly trends" do
    setup do
      Twitter.format = 'json'
      @client = Twitter::Trends.new
    end

    should "work" do
      stub_get("trends/weekly.json?", "hash.json")
      assert @client.weekly
    end

    should "exclude hastags" do
      stub_get("trends/weekly.json?exclude=hashtags", "hash.json")
      assert @client.weekly(:exclude => 'hashtags')
    end

    should "get for specific date (with date string)" do
      stub_get("trends/weekly.json?date=2009-05-01", "hash.json")
      assert @client.weekly(:date => '2009-05-01')
    end

    should "get for specific date (with date object)" do
      stub_get("trends/weekly.json?date=2009-05-01", "hash.json")
      assert @client.weekly(:date => Date.new(2009, 5, 1))
    end
  end

  context "Getting local trends" do
    setup do
      Twitter.format = 'json'
      @client = Twitter::Trends.new
    end

    should "return a list of available locations" do
      stub_get("trends/available.json?lat=33.237593417&lng=-96.960559033", "array.json")
      assert @client.available(:lat => 33.237593417, :lng => -96.960559033)
    end

    should "return a list of trends for a given location" do
      stub_get("trends/2487956.json", "array.json")
      assert @client.for_location(2487956)
    end
  end

end
