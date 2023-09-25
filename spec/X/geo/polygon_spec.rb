require "helper"

describe X::Geo::Polygon do
  before do
    @polygon = described_class.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
  end

  describe "#==" do
    it "returns true for empty objects" do
      polygon = described_class.new
      other = described_class.new
      expect(polygon == other).to be true
    end

    it "returns true when objects coordinates are the same" do
      other = described_class.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      expect(@polygon == other).to be true
    end

    it "returns false when objects coordinates are different" do
      other = described_class.new(coordinates: [[[37.77752898, -122.40348192], [37.77752898, -122.387436], [37.79448597, -122.387436], [37.79448597, -122.40348192]]])
      expect(@polygon == other).to be false
    end

    it "returns false when classes are different" do
      other = X::Geo.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      expect(@polygon == other).to be false
    end
  end
end
