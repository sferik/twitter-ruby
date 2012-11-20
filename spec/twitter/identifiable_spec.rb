require 'helper'

describe Twitter::Identity do

  describe "#initialize" do
    it "raises an ArgumentError when type is not specified" do
      expect{Twitter::Identity.new}.to raise_error ArgumentError
    end
  end

  context "identity map enabled" do
    before do
      Twitter.identity_map = Twitter::IdentityMap
    end

    after do
      Twitter.identity_map = false
    end

    describe ".fetch" do
      it "returns existing objects" do
        Twitter::Identity.store(Twitter::Identity.new(:id => 1))
        expect(Twitter::Identity.fetch(:id => 1)).to be
      end

      it "raises an error on objects that don't exist" do
        expect{Twitter::Identity.fetch(:id => 6)}.to raise_error Twitter::Error::IdentityMapKeyError
      end
    end
  end

  describe "#==" do
    it "returns true when objects IDs are the same" do
      one = Twitter::Identity.new(:id => 1, :screen_name => "sferik")
      two = Twitter::Identity.new(:id => 1, :screen_name => "garybernhardt")
      expect(one == two).to be_true
    end
    it "returns false when objects IDs are different" do
      one = Twitter::Identity.new(:id => 1)
      two = Twitter::Identity.new(:id => 2)
      expect(one == two).to be_false
    end
    it "returns false when classes are different" do
      one = Twitter::Identity.new(:id => 1)
      two = Twitter::Base.new(:id => 1)
      expect(one == two).to be_false
    end
  end

end
