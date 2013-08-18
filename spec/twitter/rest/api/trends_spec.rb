require 'helper'

describe Twitter::REST::API::Trends do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe "#trends" do
    context "with woeid passed" do
      before do
        stub_get("/1.1/trends/place.json").with(:query => {:id => "2487956"}).to_return(:body => fixture("matching_trends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.trends(2487956)
        expect(a_get("/1.1/trends/place.json").with(:query => {:id => "2487956"})).to have_been_made
      end
      it "returns the top 10 trending topics for a specific WOEID" do
        matching_trends = @client.trends(2487956)
        expect(matching_trends).to be_a Twitter::TrendResults
        expect(matching_trends.first).to be_a Twitter::Trend
        expect(matching_trends.first.name).to eq("#sevenwordsaftersex")
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/trends/place.json").with(:query => {:id => "1"}).to_return(:body => fixture("matching_trends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.trends
        expect(a_get("/1.1/trends/place.json").with(:query => {:id => "1"})).to have_been_made
      end
    end
  end

  describe "#trends_available" do
    before do
      stub_get("/1.1/trends/available.json").to_return(:body => fixture("locations.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.trends_available
      expect(a_get("/1.1/trends/available.json")).to have_been_made
    end
    it "returns the locations that Twitter has trending topic information for" do
      locations = @client.trends_available
      expect(locations).to be_an Array
      expect(locations.first).to be_a Twitter::Place
      expect(locations.first.name).to eq("Ireland")
    end
  end

  describe "#trends_closest" do
    before do
      stub_get("/1.1/trends/closest.json").to_return(:body => fixture("locations.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.trends_closest
      expect(a_get("/1.1/trends/closest.json")).to have_been_made
    end
    it "returns the locations that Twitter has trending topic information for" do
      locations = @client.trends_closest
      expect(locations).to be_an Array
      expect(locations.first).to be_a Twitter::Place
      expect(locations.first.name).to eq("Ireland")
    end
  end

end
