require "helper"

describe X::TargetUser do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      saved_search = described_class.new(id: 1, name: "foo")
      other = described_class.new(id: 1, name: "bar")
      expect(saved_search == other).to be true
    end

    it "returns false when objects IDs are different" do
      saved_search = described_class.new(id: 1)
      other = described_class.new(id: 2)
      expect(saved_search == other).to be false
    end

    it "returns false when classes are different" do
      saved_search = described_class.new(id: 1)
      other = X::Identity.new(id: 1)
      expect(saved_search == other).to be false
    end
  end
end
