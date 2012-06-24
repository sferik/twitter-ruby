require 'helper'

describe Twitter::Size do

  describe "#==" do
    it "returns true when height and width are equal" do
      size = Twitter::Size.new(:h => 1, :w => 1)
      other = Twitter::Size.new(:h => 1, :w => 1)
      (size == other).should be_true
    end
    it "returns false when height and width are not equal" do
      size = Twitter::Size.new(:h => 1, :w => 1)
      other = Twitter::Size.new(:h => 1, :w => 2)
      (size == other).should be_false
    end
  end

end
