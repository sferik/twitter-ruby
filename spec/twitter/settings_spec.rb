require 'helper'

describe Twitter::Settings do

  describe "#trend_location" do
    it "returns a Twitter::Place when set" do
      place = Twitter::Settings.new(:trend_location => [{:countryCode => 'US', :name => 'San Francisco', :country => 'United States', :placeType => {:name => 'Town', :code => 7}, :woeid => 2487956, :parentid => 23424977, :url => 'http://where.yahooapis.com/v1/place/2487956'}])
      expect(place.trend_location).to be_a Twitter::Place
    end
    it "returns nil when not set" do
      place = Twitter::Settings.new
      expect(place.trend_location).to be_nil
    end
  end

end
