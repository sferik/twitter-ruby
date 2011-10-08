require 'helper'

describe Twitter::Place do

  describe "#bounding_box" do

    it "should return a Twitter::Place when set" do
      place = Twitter::Place.new(:bounding_box => {:type => "Polygon", :coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})
      place.bounding_box.should be_a Twitter::Polygon
    end

    it "should return nil when not set" do
      place = Twitter::Place.new
      place.bounding_box.should be_nil
    end

  end
end
