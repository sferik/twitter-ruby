require 'helper'

describe Twitter::Identity do

  describe "#initialize" do
    it "raises an ArgumentError when type is not specified" do
      lambda do
        Twitter::Identity.new
      end.should raise_error(ArgumentError, "argument must have an :id key")
    end
  end

  describe '.fetch' do
    it 'returns existing objects' do
      Twitter::Identity.store(Twitter::Identity.new(:id => 1))
      Twitter::Identity.fetch(:id => 1).should be
    end

    it "raises an error on objects that don't exist" do
      lambda {
        Twitter::Identity.fetch(:id => 6)
      }.should raise_error(Twitter::Error::IdentityMapKeyError)
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
