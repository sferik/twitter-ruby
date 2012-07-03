require 'helper'

describe Twitter::Identity do

  describe "#initialize" do
    it "raises an ArgumentError when type is not specified" do
      lambda do
        Twitter::Identity.new
      end.should raise_error(ArgumentError, "argument must have an :id key")
    end
  end

  describe "#==" do
    it "returns true when objects IDs are the same" do
      one = Twitter::Identity.new(:id => 1, :screen_name => "sferik")
      two = Twitter::Identity.new(:id => 1, :screen_name => "garybernhardt")
      (one == two).should be_true
    end
    it "returns false when objects IDs are different" do
      one = Twitter::Identity.new(:id => 1)
      two = Twitter::Identity.new(:id => 2)
      (one == two).should be_false
    end
    it "returns false when classes are different" do
      one = Twitter::Identity.new(:id => 1)
      two = Twitter::Base.new(:id => 1)
      (one == two).should be_false
    end
  end

end
