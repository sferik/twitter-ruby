require "helper"

describe X::Geo do
  before do
    @geo = described_class.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
  end

  describe "#==" do
    it "returns true for empty objects" do
      geo = described_class.new
      other = described_class.new
      expect(geo == other).to be true
    end

    it "returns true when objects coordinates are the same" do
      other = described_class.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      expect(@geo == other).to be true
    end

    it "returns false when objects coordinates are different" do
      other = described_class.new(coordinates: [[[37.77752898, -122.40348192], [37.77752898, -122.387436], [37.79448597, -122.387436], [37.79448597, -122.40348192]]])
      expect(@geo == other).to be false
    end

    it "returns true when classes are different" do
      other = X::Geo::Polygon.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      expect(@geo == other).to be true
    end
  end
end
