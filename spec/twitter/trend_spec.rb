require 'helper'

describe Twitter::Trend do

  before do
    @trend = Twitter::Trend.new('name' => '#sevenwordsaftersex')
  end

  describe "#==" do
    it "returns true when names are equal" do
      other = Twitter::Trend.new('name' => '#sevenwordsaftersex')
      (@trend == other).should be_true
    end
    it "returns false when coordinates are not equal" do
      other = Twitter::Trend.new('name' => '#sixwordsaftersex')
      (@trend == other).should be_false
    end
  end

end
