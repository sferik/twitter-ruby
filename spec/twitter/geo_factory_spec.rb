require 'helper'

describe Twitter::GeoFactory do

  describe ".new" do
    it "generates a Point" do
      geo = Twitter::GeoFactory.new(:type => "Point")
      expect(geo).to be_a Twitter::Geo::Point
    end
    it "generates a Polygon" do
      geo = Twitter::GeoFactory.new(:type => "Polygon")
      expect(geo).to be_a Twitter::Geo::Polygon
    end
    it "raises an ArgumentError when type is not specified" do
      expect{Twitter::GeoFactory.new}.to raise_error ArgumentError
    end
  end

end
