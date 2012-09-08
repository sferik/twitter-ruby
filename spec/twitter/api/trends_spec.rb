require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#trends" do
    context "with woeid passed" do
      before do
        stub_get("/1.1/trends/place.json").
          with(:query => {:id => "2487956"}).
          to_return(:body => fixture("matching_trends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.trends(2487956)
        a_get("/1.1/trends/place.json").
          with(:query => {:id => "2487956"}).
          should have_been_made
      end
      it "returns the top 10 trending topics for a specific WOEID" do
        matching_trends = @client.trends(2487956)
        matching_trends.should be_an Array
        matching_trends.first.should be_a Twitter::Trend
        matching_trends.first.name.should eq "#sevenwordsaftersex"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/trends/place.json").
          with(:query => {:id => "1"}).
          to_return(:body => fixture("matching_trends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.trends
        a_get("/1.1/trends/place.json").
          with(:query => {:id => "1"}).
          should have_been_made
      end
    end
  end

  describe "#trends_available" do
    before do
      stub_get("/1.1/trends/available.json").
        to_return(:body => fixture("locations.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.trends_available
      a_get("/1.1/trends/available.json").
        should have_been_made
    end
    it "returns the locations that Twitter has trending topic information for" do
      locations = @client.trends_available
      locations.should be_an Array
      locations.first.should be_a Twitter::Place
      locations.first.name.should eq "Ireland"
    end
  end

  describe "#trends_closest" do
    before do
      stub_get("/1.1/trends/closest.json").
        to_return(:body => fixture("locations.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.trends_closest
      a_get("/1.1/trends/closest.json").
        should have_been_made
    end
    it "returns the locations that Twitter has trending topic information for" do
      locations = @client.trends_closest
      locations.should be_an Array
      locations.first.should be_a Twitter::Place
      locations.first.name.should eq "Ireland"
    end
  end

end
