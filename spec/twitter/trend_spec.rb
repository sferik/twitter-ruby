require 'helper'

describe Twitter::Trend do

  before do
    @trend = Twitter::Trend.new('name' => '#sevenwordsaftersex')
  end

  describe "#==" do
    it "should return true when names are equal" do
      other = Twitter::Trend.new('name' => '#sevenwordsaftersex')
      (@trend == other).should be_true
    end
    it "should return false when coordinates are not equal" do
      other = Twitter::Trend.new('name' => '#sixwordsaftersex')
      (@trend == other).should be_false
    end
  end

end
