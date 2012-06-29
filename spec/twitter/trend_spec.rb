require 'helper'

describe Twitter::Trend do

  describe "#==" do
    it "returns false for empty objects" do
      trend = Twitter::Trend.new
      other = Twitter::Trend.new
      (trend == other).should be_false
    end
    it "returns true when objects names are the same" do
      trend = Twitter::Trend.new(:name => "#sevenwordsaftersex", :query => "foo")
      other = Twitter::Trend.new(:name => "#sevenwordsaftersex", :query => "bar")
      (trend == other).should be_true
    end
    it "returns false when objects names are different" do
      trend = Twitter::Trend.new(:name => "#sevenwordsaftersex")
      other = Twitter::Trend.new(:name => "#sixwordsaftersex")
      (trend == other).should be_false
    end
    it "returns false when classes are different" do
      trend = Twitter::Trend.new(:name => "#sevenwordsaftersex")
      other = Twitter::Base.new(:name => "#sevenwordsaftersex")
      (trend == other).should be_false
    end
    it "returns true when objects non-name attributes are the same" do
      trend = Twitter::Trend.new(:query => "foo")
      other = Twitter::Trend.new(:query => "foo")
      (trend == other).should be_true
    end
    it "returns false when objects non-name attributes are different" do
      trend = Twitter::Trend.new(:query => "foo")
      other = Twitter::Trend.new(:query => "bar")
      (trend == other).should be_false
    end
  end

end
