require 'helper'

describe Twitter::Identifiable do

  describe "#==" do
    it "returns false for empty objects" do
      one = Twitter::Identifiable.new
      two = Twitter::Identifiable.new
      (one == two).should be_false
    end
    it "returns true when objects IDs are the same" do
      one = Twitter::Identifiable.new(:id => 1, :screen_name => "sferik")
      two = Twitter::Identifiable.new(:id => 1, :screen_name => "garybernhardt")
      (one == two).should be_true
    end
    it "returns false when objects IDs are different" do
      one = Twitter::Identifiable.new(:id => 1)
      two = Twitter::Identifiable.new(:id => 2)
      (one == two).should be_false
    end
    it "returns false when classes are different" do
      one = Twitter::Identifiable.new(:id => 1)
      two = Twitter::Base.new(:id => 1)
      (one == two).should be_false
    end
    it "returns true when objects non-ID attributes are the same" do
      one = Twitter::Identifiable.new(:screen_name => "sferik")
      two = Twitter::Identifiable.new(:screen_name => "sferik")
      (one == two).should be_true
    end
    it "returns false when objects non-ID attributes are different" do
      one = Twitter::Identifiable.new(:screen_name => "sferik")
      two = Twitter::Identifiable.new(:screen_name => "garybernhardt")
      (one == two).should be_false
    end
  end

end
