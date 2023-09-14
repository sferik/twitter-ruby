require "helper"

describe Twitter::Version do
  before do
    allow(described_class).to receive_messages(major: 1, minor: 2, patch: 3, pre: nil)
  end

  describe ".to_h" do
    it "returns a hash with the right values" do
      expect(described_class.to_h).to be_a Hash
      expect(described_class.to_h[:major]).to eq(1)
      expect(described_class.to_h[:minor]).to eq(2)
      expect(described_class.to_h[:patch]).to eq(3)
      expect(described_class.to_h[:pre]).to be_nil
    end
  end

  describe ".to_a" do
    it "returns an array with the right values" do
      expect(described_class.to_a).to be_an Array
      expect(described_class.to_a).to eq([1, 2, 3])
    end
  end

  describe ".to_s" do
    it "returns a string with the right value" do
      expect(described_class.to_s).to be_a String
      expect(described_class.to_s).to eq("1.2.3")
    end
  end
end
