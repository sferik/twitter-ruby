require 'helper'

describe Twitter::BasicUser do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      saved_search = Twitter::BasicUser.new(:id => 1, :name => "foo")
      other = Twitter::BasicUser.new(:id => 1, :name => "bar")
      (saved_search == other).should be_true
    end
    it "returns false when objects IDs are different" do
      saved_search = Twitter::BasicUser.new(:id => 1)
      other = Twitter::BasicUser.new(:id => 2)
      (saved_search == other).should be_false
    end
    it "returns false when classes are different" do
      saved_search = Twitter::BasicUser.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      (saved_search == other).should be_false
    end
  end

end
