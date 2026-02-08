require "test_helper"

describe Twitter::Geo do
  before do
    @geo = Twitter::Geo.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
  end

  describe "#==" do
    it "returns true for empty objects" do
      geo = Twitter::Geo.new
      other = Twitter::Geo.new

      assert_equal(geo, other)
    end

    it "returns true when objects coordinates are the same" do
      other = Twitter::Geo.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])

      assert_equal(@geo, other)
    end

    it "returns false when objects coordinates are different" do
      other = Twitter::Geo.new(coordinates: [[[37.77752898, -122.40348192], [37.77752898, -122.387436], [37.79448597, -122.387436], [37.79448597, -122.40348192]]])

      refute_equal(@geo, other)
    end

    it "returns true when classes are different" do
      other = Twitter::Geo::Polygon.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])

      assert_equal(@geo, other)
    end
  end
end
