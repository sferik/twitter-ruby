require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#trends_daily" do
    before do
      stub_get("/1/trends/daily.json").
        with(:query => {:date => "2010-10-24"}).
        to_return(:body => fixture("trends_daily.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.trends_daily(Date.parse("2010-10-24"))
      a_get("/1/trends/daily.json").
        with(:query => {:date => "2010-10-24"}).
        should have_been_made
    end
    it "returns the top 20 trending topics for each hour in a given day" do
      trends = @client.trends_daily(Date.parse("2010-10-24"))
      trends.should be_a Hash
      trends["2010-10-24 17:00".to_sym].should be_an Array
      trends["2010-10-24 17:00".to_sym].first.should be_a Twitter::Trend
      trends["2010-10-24 17:00".to_sym].first.name.should eq "#bigbangcomeback"
    end
  end

  describe "#trends_weekly" do
    before do
      stub_get("/1/trends/weekly.json").
        with(:query => {:date => "2010-10-24"}).
        to_return(:body => fixture("trends_weekly.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.trends_weekly(Date.parse("2010-10-24"))
      a_get("/1/trends/weekly.json").
        with(:query => {:date => "2010-10-24"}).
        should have_been_made
    end
    it "returns the top 30 trending topics for each day in a given week" do
      trends = @client.trends_weekly(Date.parse("2010-10-24"))
      trends.should be_a Hash
      trends["2010-10-24".to_sym].should be_an Array
      trends["2010-10-24".to_sym].first.should be_a Twitter::Trend
      trends["2010-10-24".to_sym].first.name.should eq "#youcantbeuglyand"
    end
  end

end
