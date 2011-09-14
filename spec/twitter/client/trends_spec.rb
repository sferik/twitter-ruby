require 'helper'

describe Twitter::Client do
  before do
    @client = Twitter::Client.new
  end

  describe ".trends" do

    before do
      stub_get("1/trends/1.json").
        to_return(:body => fixture("matching_trends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.trends
      a_get("1/trends/1.json").
        should have_been_made
    end

    it "should return the top ten topics that are currently trending on Twitter" do
      trends = @client.trends
      trends.should be_an Array
      trends.first.should == "#sevenwordsaftersex"
    end

  end

  describe ".trends_current" do

    before do
      stub_get("1/trends/1.json").
        to_return(:body => fixture("matching_trends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.trends_current
      a_get("1/trends/1.json").
        should have_been_made
    end

    it "should return the current top 10 trending topics on Twitter" do
      trends_current = @client.trends_current
      trends_current.should be_an Array
      trends_current.first.should == "#sevenwordsaftersex"
    end

  end

  describe ".trends_daily" do

    before do
      stub_get("1/trends/daily.json").
        with(:query => {:date => "2010-10-24"}).
        to_return(:body => fixture("trends_daily.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.trends_daily(Date.parse("2010-10-24"))
      a_get("1/trends/daily.json").
        with(:query => {:date => "2010-10-24"}).
        should have_been_made
    end

    it "should return the top 20 trending topics for each hour in a given day" do
      trends = @client.trends_daily(Date.parse("2010-10-24"))
      trends["2010-10-24 17:00"].first.name.should == "#bigbangcomeback"
    end

  end

  describe ".trends_weekly" do

    before do
      stub_get("1/trends/weekly.json").
        with(:query => {:date => "2010-10-24"}).
        to_return(:body => fixture("trends_weekly.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      @client.trends_weekly(Date.parse("2010-10-24"))
      a_get("1/trends/weekly.json").
        with(:query => {:date => "2010-10-24"}).
        should have_been_made
    end

    it "should return the top 30 trending topics for each day in a given week" do
      trends = @client.trends_weekly(Date.parse("2010-10-24"))
      trends["2010-10-23"].first.name.should == "#unfollowmeif"
    end
  end
end
