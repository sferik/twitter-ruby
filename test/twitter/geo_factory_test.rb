require "helper"

describe Twitter::GeoFactory do
  describe ".new" do
    it "generates a Point" do
      geo = described_class.new(type: "Point")
      expect(geo).to be_a Twitter::Geo::Point
    end

    it "generates a Polygon" do
      geo = described_class.new(type: "Polygon")
      expect(geo).to be_a Twitter::Geo::Polygon
    end

    it "raises an IndexError when type is not specified" do
      expect { described_class.new }.to raise_error(IndexError)
    end
  end
end
