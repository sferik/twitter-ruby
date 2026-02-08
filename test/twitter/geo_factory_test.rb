require "test_helper"

describe Twitter::GeoFactory do
  describe ".new" do
    it "generates a Point" do
      geo = Twitter::GeoFactory.new(type: "Point")

      assert_kind_of(Twitter::Geo::Point, geo)
    end

    it "generates a Polygon" do
      geo = Twitter::GeoFactory.new(type: "Polygon")

      assert_kind_of(Twitter::Geo::Polygon, geo)
    end

    it "raises an IndexError when type is not specified" do
      assert_raises(IndexError) { Twitter::GeoFactory.new }
    end
  end
end
