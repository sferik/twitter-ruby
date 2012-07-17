require 'helper'

describe Twitter::Relationship do

  describe "#source" do
    it "returns a User when source is set" do
      source = Twitter::Relationship.new(:relationship => {:source => {:id => 7505382}}).source
      source.should be_a Twitter::SourceUser
    end
    it "returns nil when source is not set" do
      source = Twitter::Relationship.new(:relationship => {}).source
      source.should be_nil
    end
  end

  describe "#target" do
    it "returns a User when target is set" do
      target = Twitter::Relationship.new(:relationship => {:target => {:id => 7505382}}).target
      target.should be_a Twitter::TargetUser
    end
    it "returns nil when target is not set" do
      target = Twitter::Relationship.new(:relationship => {}).target
      target.should be_nil
    end
  end

  describe "#update" do
    it "updates a relationship" do
      relationship = Twitter::Relationship.new(:relationship => {:target => {:id => 7505382}})
      relationship.update(:relationship => {:target => {:id => 14100886}})
      relationship.target.id.should eq 14100886
    end
  end

end
