require "helper"

describe X::Suggestion do
  describe "#==" do
    it "returns true for empty objects" do
      suggestion = described_class.new
      other = described_class.new
      expect(suggestion == other).to be true
    end

    it "returns true when objects slugs are the same" do
      suggestion = described_class.new(slug: 1, name: "foo")
      other = described_class.new(slug: 1, name: "bar")
      expect(suggestion == other).to be true
    end

    it "returns false when objects slugs are different" do
      suggestion = described_class.new(slug: 1)
      other = described_class.new(slug: 2)
      expect(suggestion == other).to be false
    end

    it "returns false when classes are different" do
      suggestion = described_class.new(slug: 1)
      other = X::Base.new(slug: 1)
      expect(suggestion == other).to be false
    end
  end

  describe "#users" do
    it "returns a User when user is set" do
      users = described_class.new(users: [{id: 7_505_382}]).users
      expect(users).to be_an Array
      expect(users.first).to be_a X::User
    end

    it "is empty when not set" do
      users = described_class.new.users
      expect(users).to be_empty
    end
  end
end
