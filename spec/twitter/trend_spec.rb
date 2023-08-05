require "helper"

describe Twitter::Trend do
  describe "#==" do
    it "returns true for empty objects" do
      trend = described_class.new
      other = described_class.new
      expect(trend == other).to be true
    end

    it "returns true when objects names are the same" do
      trend = described_class.new(name: "#sevenwordsaftersex", query: "foo")
      other = described_class.new(name: "#sevenwordsaftersex", query: "bar")
      expect(trend == other).to be true
    end

    it "returns false when objects names are different" do
      trend = described_class.new(name: "#sevenwordsaftersex")
      other = described_class.new(name: "#sixwordsaftersex")
      expect(trend == other).to be false
    end

    it "returns false when classes are different" do
      trend = described_class.new(name: "#sevenwordsaftersex")
      other = Twitter::Base.new(name: "#sevenwordsaftersex")
      expect(trend == other).to be false
    end
  end

  describe "#uri" do
    it "returns a URI when the url is set" do
      trend = described_class.new(url: "http://twitter.com/search/?q=%23sevenwordsaftersex")
      expect(trend.uri).to be_an Addressable::URI
      expect(trend.uri.to_s).to eq("http://twitter.com/search/?q=%23sevenwordsaftersex")
    end

    it "returns nil when the url is not set" do
      trend = described_class.new
      expect(trend.uri).to be_nil
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      trend = described_class.new(url: "https://api.twitter.com/2/geo/id/247f43d441defc03.json")
      expect(trend.uri?).to be true
    end

    it "returns false when the url is not set" do
      trend = described_class.new
      expect(trend.uri?).to be false
    end
  end
end
