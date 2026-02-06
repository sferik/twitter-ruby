require "helper"

describe Twitter::Version do
  describe ".major" do
    it "returns the correct major version" do
      expect(described_class.major).to eq(8)
    end
  end

  describe ".minor" do
    it "returns the correct minor version" do
      expect(described_class.minor).to eq(2)
    end
  end

  describe ".patch" do
    it "returns the correct patch version" do
      expect(described_class.patch).to eq(0)
    end
  end

  describe ".pre" do
    it "returns nil for stable releases" do
      expect(described_class.pre).to be_nil
    end
  end

  describe ".to_h" do
    it "returns a hash with version components" do
      result = described_class.to_h
      expect(result[:major]).to eq(8)
      expect(result[:minor]).to eq(2)
      expect(result[:patch]).to eq(0)
      expect(result).to have_key(:pre)
    end
  end

  describe ".to_a" do
    it "returns an array with major, minor, patch" do
      expect(described_class.to_a).to eq([8, 2, 0])
    end
  end

  describe ".to_s" do
    it "returns version string joined with dots" do
      expect(described_class.to_s).to eq("8.2.0")
    end
  end
end
