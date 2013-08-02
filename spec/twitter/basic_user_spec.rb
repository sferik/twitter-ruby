require 'helper'

describe Twitter::BasicUser do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      saved_search = Twitter::BasicUser.new(:id => 1, :name => "foo")
      other = Twitter::BasicUser.new(:id => 1, :name => "bar")
      expect(saved_search == other).to be_true
    end

end
