require "test_helper"

describe Twitter::Relationship do
  describe "#source" do
    it "returns a User when source is set" do
      relationship = Twitter::Relationship.new(relationship: {source: {id: 7_505_382}})

      assert_kind_of(Twitter::SourceUser, relationship.source)
    end

    it "returns nil when source is not set" do
      relationship = Twitter::Relationship.new(relationship: {})

      assert_nil(relationship.source)
    end
  end

  describe "#source?" do
    it "returns true when source is set" do
      relationship = Twitter::Relationship.new(relationship: {source: {id: 7_505_382}})

      assert_predicate(relationship, :source?)
    end

    it "returns false when source is not set" do
      relationship = Twitter::Relationship.new(relationship: {})

      refute_predicate(relationship, :source?)
    end
  end

  describe "#target" do
    it "returns a User when target is set" do
      relationship = Twitter::Relationship.new(relationship: {target: {id: 7_505_382}})

      assert_kind_of(Twitter::TargetUser, relationship.target)
    end

    it "returns nil when target is not set" do
      relationship = Twitter::Relationship.new(relationship: {})

      assert_nil(relationship.target)
    end
  end

  describe "#target?" do
    it "returns true when target is set" do
      relationship = Twitter::Relationship.new(relationship: {target: {id: 7_505_382}})

      assert_predicate(relationship, :target?)
    end

    it "returns false when target is not set" do
      relationship = Twitter::Relationship.new(relationship: {})

      refute_predicate(relationship, :target?)
    end
  end

  describe "#initialize" do
    it "supports initialization without arguments" do
      relationship = Twitter::Relationship.new

      assert_empty(relationship.attrs)
      assert_nil(relationship.source)
      assert_nil(relationship.target)
    end

    it "uses hash defaults when relationship key is missing" do
      attrs = Hash.new { |_hash, _key| {source: {id: 7_505_382}} }
      relationship = Twitter::Relationship.new(attrs)

      assert_kind_of(Twitter::SourceUser, relationship.source)
      assert_equal(7_505_382, relationship.source.id)
    end
  end
end
