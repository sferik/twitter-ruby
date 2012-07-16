require 'helper'

describe Twitter::GeoFactory do

  describe ".new" do
    it "generates a Point" do
      geo = Twitter::GeoFactory.fetch_or_new(:type => 'Point')
      geo.should be_a Twitter::Point
    end
    it "generates a Polygon" do
      geo = Twitter::GeoFactory.fetch_or_new(:type => 'Polygon')
      geo.should be_a Twitter::Polygon
    end
    it "raises an ArgumentError when type is not specified" do
      lambda do
        Twitter::GeoFactory.fetch_or_new
      end.should raise_error(ArgumentError, "argument must have a :type key")
    end
  end

end
