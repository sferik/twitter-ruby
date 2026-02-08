require "test_helper"

describe Twitter::Settings do
  describe "#trend_location" do
    it "returns a Twitter::Place when trend_location is set" do
      settings = Twitter::Settings.new(trend_location: {countryCode: "US", name: "San Francisco", country: "United States", placeType: {name: "Town", code: 7}, woeid: 2_487_956, parentid: 23_424_977, url: "http://where.yahooapis.com/v1/place/2487956"})

      assert_kind_of(Twitter::Place, settings.trend_location)
    end

    it "returns nil when trend_location is not set" do
      settings = Twitter::Settings.new

      assert_nil(settings.trend_location)
    end
  end

  describe "#trend_location?" do
    it "returns true when trend_location is set" do
      settings = Twitter::Settings.new(trend_location: {countryCode: "US", name: "San Francisco", country: "United States", placeType: {name: "Town", code: 7}, woeid: 2_487_956, parentid: 23_424_977, url: "http://where.yahooapis.com/v1/place/2487956"})

      assert_predicate(settings, :trend_location?)
    end

    it "returns false when trend_location is not set" do
      settings = Twitter::Settings.new

      refute_predicate(settings, :trend_location?)
    end
  end
end
