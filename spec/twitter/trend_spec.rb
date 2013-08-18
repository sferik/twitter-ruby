require 'helper'

describe Twitter::Trend do

  describe "#==" do
    it "returns false for empty objects" do
      trend = Twitter::Trend.new
      other = Twitter::Trend.new
      expect(trend == other).to be_false
    end
    it "returns true when objects names are the same" do
      trend = Twitter::Trend.new(:name => "#sevenwordsaftersex", :query => "foo")
      other = Twitter::Trend.new(:name => "#sevenwordsaftersex", :query => "bar")
      expect(trend == other).to be_true
    end
    it "returns false when objects names are different" do
      trend = Twitter::Trend.new(:name => "#sevenwordsaftersex")
      other = Twitter::Trend.new(:name => "#sixwordsaftersex")
      expect(trend == other).to be_false
    end
    it "returns false when classes are different" do
      trend = Twitter::Trend.new(:name => "#sevenwordsaftersex")
      other = Twitter::Base.new(:name => "#sevenwordsaftersex")
      expect(trend == other).to be_false
    end
    it "returns true when objects non-name attributes are the same" do
      trend = Twitter::Trend.new(:query => "foo")
      other = Twitter::Trend.new(:query => "foo")
      expect(trend == other).to be_true
    end
    it "returns false when objects non-name attributes are different" do
      trend = Twitter::Trend.new(:query => "foo")
      other = Twitter::Trend.new(:query => "bar")
      expect(trend == other).to be_false
    end
  end

  describe "#uri" do
    it "returns a URI when the url is set" do
      trend = Twitter::Trend.new(:url => "http://twitter.com/search/?q=%23sevenwordsaftersex")
      expect(trend.uri).to be_a URI
      expect(trend.uri.to_s).to eq("http://twitter.com/search/?q=%23sevenwordsaftersex")
    end
    it "returns nil when the url is not set" do
      trend = Twitter::Trend.new
      expect(trend.uri).to be_nil
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      trend = Twitter::Trend.new(:url => "https://api.twitter.com/1.1/geo/id/247f43d441defc03.json")
      expect(trend.uri?).to be_true
    end
    it "returns false when the url is not set" do
      trend = Twitter::Trend.new
      expect(trend.uri?).to be_false
    end
  end

end
