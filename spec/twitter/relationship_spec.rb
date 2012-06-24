require 'helper'

describe Twitter::Relationship do

  describe "#source" do
    it "returns a User when source is set" do
      source = Twitter::Relationship.new(:relationship => {:source => {}}).source
      source.should be_a Twitter::User
    end
    it "returns nil when source is not set" do
      source = Twitter::Relationship.new.source
      source.should be_nil
    end
  end

  describe "#target" do
    it "returns a User when target is set" do
      target = Twitter::Relationship.new(:relationship => {:target => {}}).target
      target.should be_a Twitter::User
    end
    it "returns nil when target is not set" do
      target = Twitter::Relationship.new.target
      target.should be_nil
    end
  end

end
