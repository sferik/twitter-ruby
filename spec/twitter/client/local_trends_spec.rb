require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#local_trends" do
    context "with woeid passed" do
      before do
        stub_get("/1/trends/2487956.json").
          to_return(:body => fixture("matching_trends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.local_trends(2487956)
        a_get("/1/trends/2487956.json").
          should have_been_made
      end
      it "returns the top 10 trending topics for a specific WOEID" do
        matching_trends = @client.local_trends(2487956)
        matching_trends.should be_an Array
        matching_trends.first.should be_a Twitter::Trend
        matching_trends.first.name.should eq "#sevenwordsaftersex"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/trends/1.json").
          to_return(:body => fixture("matching_trends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.local_trends
        a_get("/1/trends/1.json").
          should have_been_made
      end
    end
  end

  describe "#trend_locations" do
    before do
      stub_get("/1/trends/available.json").
        to_return(:body => fixture("locations.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.trend_locations
      a_get("/1/trends/available.json").
        should have_been_made
    end
    it "returns the locations that Twitter has trending topic information for" do
      locations = @client.trend_locations
      locations.should be_an Array
      locations.first.should be_a Twitter::Place
      locations.first.name.should eq "Ireland"
    end
  end

end
