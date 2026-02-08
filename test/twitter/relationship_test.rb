require "helper"

describe Twitter::Relationship do
  describe "#source" do
    it "returns a User when source is set" do
      relationship = described_class.new(relationship: {source: {id: 7_505_382}})
      expect(relationship.source).to be_a Twitter::SourceUser
    end

    it "returns nil when source is not set" do
      relationship = described_class.new(relationship: {})
      expect(relationship.source).to be_nil
    end
  end

  describe "#source?" do
    it "returns true when source is set" do
      relationship = described_class.new(relationship: {source: {id: 7_505_382}})
      expect(relationship.source?).to be true
    end

    it "returns false when source is not set" do
      relationship = described_class.new(relationship: {})
      expect(relationship.source?).to be false
    end
  end

  describe "#target" do
    it "returns a User when target is set" do
      relationship = described_class.new(relationship: {target: {id: 7_505_382}})
      expect(relationship.target).to be_a Twitter::TargetUser
    end

    it "returns nil when target is not set" do
      relationship = described_class.new(relationship: {})
      expect(relationship.target).to be_nil
    end
  end

  describe "#target?" do
    it "returns true when target is set" do
      relationship = described_class.new(relationship: {target: {id: 7_505_382}})
      expect(relationship.target?).to be true
    end

    it "returns false when target is not set" do
      relationship = described_class.new(relationship: {})
      expect(relationship.target?).to be false
    end
  end

  describe "#initialize" do
    it "supports initialization without arguments" do
      relationship = described_class.new
      expect(relationship.source).to be_nil
      expect(relationship.target).to be_nil
    end

    it "uses hash defaults when relationship key is missing" do
      attrs = Hash.new({source: {id: 7_505_382}})
      relationship = described_class.new(attrs)
      expect(relationship.source).to be_a(Twitter::SourceUser)
      expect(relationship.source.id).to eq(7_505_382)
    end
  end
end
