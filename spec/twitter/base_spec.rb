require 'helper'

describe Twitter::Base do

  before do
    @base = Twitter::Base.new(:id => 1)
  end

  describe "#[]" do
    it "calls methods using [] with symbol" do
      @base[:object_id].should be_an Integer
    end
    it "calls methods using [] with string" do
      @base['object_id'].should be_an Integer
    end
    it "returns nil for missing method" do
      @base[:foo].should be_nil
      @base['foo'].should be_nil
    end
  end

  describe "#to_hash" do
    it "returns a hash" do
      @base.to_hash.should be_a Hash
      @base.to_hash[:id].should eq 1
    end
  end

  describe "identical objects" do
    it "have the same object_id" do
      @base.object_id.should eq Twitter::Base.fetch(:id => 1).object_id
    end
  end

end
