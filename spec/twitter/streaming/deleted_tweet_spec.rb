require "helper"

describe X::Streaming::DeletedTweet do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      deleted_tweet = described_class.new(id: 1)
      other = described_class.new(id: 1)
      expect(deleted_tweet == other).to be true
    end

    it "returns false when objects IDs are different" do
      deleted_tweet = described_class.new(id: 1)
      other = described_class.new(id: 2)
      expect(deleted_tweet == other).to be false
    end

    it "returns false when classes are different" do
      deleted_tweet = described_class.new(id: 1)
      other = X::Identity.new(id: 1)
      expect(deleted_tweet == other).to be false
    end
  end
end
