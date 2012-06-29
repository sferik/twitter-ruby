require 'helper'

describe Twitter::Size do

  describe "#==" do
    it "returns false for empty objects" do
      size = Twitter::Size.new
      other = Twitter::Size.new
      (size == other).should be_false
    end
    it "returns true when objects height and width are the same" do
      size = Twitter::Size.new(:h => 1, :w => 1, :resize => true)
      other = Twitter::Size.new(:h => 1, :w => 1, :resize => false)
      (size == other).should be_true
    end
    it "returns false when objects height or width are different" do
      size = Twitter::Size.new(:h => 1, :w => 1)
      other = Twitter::Size.new(:h => 1, :w => 2)
      (size == other).should be_false
    end
    it "returns false when classes are different" do
      size = Twitter::Size.new(:h => 1, :w => 1)
      other = Twitter::Base.new(:h => 1, :w => 1)
      (size == other).should be_false
    end
    it "returns true when objects non-height and width attributes are the same" do
      size = Twitter::Size.new(:resize => true)
      other = Twitter::Size.new(:resize => true)
      (size == other).should be_true
    end
    it "returns false when objects non-height and width attributes are different" do
      size = Twitter::Size.new(:resize => true)
      other = Twitter::Size.new(:resize => false)
      (size == other).should be_false
    end
  end

end
