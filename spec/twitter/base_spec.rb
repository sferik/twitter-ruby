require 'helper'

describe Twitter::Base do

  before do
    @base = Twitter::Base.new('id' => 1)
  end

  describe "#[]" do
    it "should be able to call methods using [] with symbol" do
      @base[:object_id].should be_an Integer
    end
    it "should be able to call methods using [] with string" do
      @base['object_id'].should be_an Integer
    end
    it "should return nil for missing method" do
      @base[:foo].should be_nil
      @base['foo'].should be_nil
    end
  end

  describe "#to_hash" do
    it "should return a hash" do
      @base.to_hash.should be_a Hash
      @base.to_hash['id'].should == 1
    end
  end

  describe "identical objects" do
    it "should have the same object_id" do
      @base.object_id.should == Twitter::Base.new('id' => 1).object_id
    end
  end

end
