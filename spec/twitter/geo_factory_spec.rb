require 'helper'

describe Twitter::GeoFactory do

  describe ".new" do
    it "should generate a Point" do
      geo = Twitter::GeoFactory.new('type' => 'Point')
      geo.should be_a Twitter::Point
    end
    it "should generate a Polygon" do
      geo = Twitter::GeoFactory.new('type' => 'Polygon')
      geo.should be_a Twitter::Polygon
    end
    it "should raise an ArgumentError when type is not specified" do
      lambda do
        Twitter::GeoFactory.new({})
      end.should raise_error(ArgumentError, "argument must have a 'type' key")
    end
  end

end
