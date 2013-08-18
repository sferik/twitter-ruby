require 'helper'

describe Twitter::Relationship do

  describe "#source" do
    it "returns a User when source is set" do
      relationship = Twitter::Relationship.new(:relationship => {:source => {:id => 7505382}})
      expect(relationship.source).to be_a Twitter::SourceUser
    end
    it "returns nil when source is not set" do
      relationship = Twitter::Relationship.new(:relationship => {})
      expect(relationship.source).to be_nil
    end
  end

  describe "#source?" do
    it "returns true when source is set" do
      relationship = Twitter::Relationship.new(:relationship => {:source => {:id => 7505382}})
      expect(relationship.source?).to be_true
    end
    it "returns false when source is not set" do
      relationship = Twitter::Relationship.new(:relationship => {})
      expect(relationship.source?).to be_false
    end
  end

  describe "#target" do
    it "returns a User when target is set" do
      relationship = Twitter::Relationship.new(:relationship => {:target => {:id => 7505382}})
      expect(relationship.target).to be_a Twitter::TargetUser
    end
    it "returns nil when target is not set" do
      relationship = Twitter::Relationship.new(:relationship => {})
      expect(relationship.target).to be_nil
    end
  end

  describe "#target?" do
    it "returns true when target is set" do
      relationship = Twitter::Relationship.new(:relationship => {:target => {:id => 7505382}})
      expect(relationship.target?).to be_true
    end
    it "returns false when target is not set" do
      relationship = Twitter::Relationship.new(:relationship => {})
      expect(relationship.target?).to be_false
    end
  end

  describe "#update" do
    it "updates a relationship" do
      relationship = Twitter::Relationship.new(:relationship => {:target => {:id => 7505382}})
      relationship.update(:relationship => {:target => {:id => 14100886}})
      expect(relationship.target.id).to eq(14100886)
    end
  end

end
