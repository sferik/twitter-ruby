require "test_helper"

describe Twitter::Trend do
  describe "#==" do
    it "returns true for empty objects" do
      trend = Twitter::Trend.new
      other = Twitter::Trend.new

      assert_equal(trend, other)
    end

    it "returns true when objects names are the same" do
      trend = Twitter::Trend.new(name: "#sevenwordsaftersex", query: "foo")
      other = Twitter::Trend.new(name: "#sevenwordsaftersex", query: "bar")

      assert_equal(trend, other)
    end

    it "returns false when objects names are different" do
      trend = Twitter::Trend.new(name: "#sevenwordsaftersex")
      other = Twitter::Trend.new(name: "#sixwordsaftersex")

      refute_equal(trend, other)
    end

    it "returns false when classes are different" do
      trend = Twitter::Trend.new(name: "#sevenwordsaftersex")
      other = Twitter::Base.new(name: "#sevenwordsaftersex")

      refute_equal(trend, other)
    end
  end

  describe "#uri" do
    it "returns a URI when the url is set" do
      trend = Twitter::Trend.new(url: "http://twitter.com/search/?q=%23sevenwordsaftersex")

      assert_kind_of(Addressable::URI, trend.uri)
      assert_equal("http://twitter.com/search/?q=%23sevenwordsaftersex", trend.uri.to_s)
    end

    it "returns nil when the url is not set" do
      trend = Twitter::Trend.new

      assert_nil(trend.uri)
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      trend = Twitter::Trend.new(url: "https://api.twitter.com/1.1/geo/id/247f43d441defc03.json")

      assert_predicate(trend, :uri?)
    end

    it "returns false when the url is not set" do
      trend = Twitter::Trend.new

      refute_predicate(trend, :uri?)
    end
  end
end
