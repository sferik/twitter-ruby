require 'helper'

describe Twitter::Place do

  describe "#==" do
    it "should return true when ids and classes are equal" do
      place = Twitter::Place.new('id' => 1)
      other = Twitter::Place.new('id' => 1)
      (place == other).should be_true
    end
    it "should return false when classes are not equal" do
      place = Twitter::Place.new('id' => 1)
      other = Twitter::User.new('id' => 1)
      (place == other).should be_false
    end
    it "should return false when ids are not equal" do
      place = Twitter::Place.new('id' => 1)
      other = Twitter::Place.new('id' => 2)
      (place == other).should be_false
    end
  end

  describe "#bounding_box" do
    it "should return a Twitter::Place when set" do
      place = Twitter::Place.new('bounding_box' => {'type' => 'Polygon', 'coordinates' => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})
      place.bounding_box.should be_a Twitter::Polygon
    end
    it "should return nil when not set" do
      place = Twitter::Place.new
      place.bounding_box.should be_nil
    end
  end

  describe "#country_code" do
    it "should return a country code when set with country_code" do
      place = Twitter::Place.new('country_code' => 'US')
      place.country_code.should == 'US'
    end
    it "should return a country code when set with countryCode" do
      place = Twitter::Place.new('countryCode' => 'US')
      place.country_code.should == 'US'
    end
    it "should return nil when not set" do
      place = Twitter::Place.new
      place.country_code.should be_nil
    end
  end

  describe "#parent_id" do
    it "should return a parent ID when set with parentid" do
      place = Twitter::Place.new('parentid' => 1)
      place.parent_id.should == 1
    end
    it "should return nil when not set" do
      place = Twitter::Place.new
      place.parent_id.should be_nil
    end
  end

  describe "#place_type" do
    it "should return a place type when set with place_type" do
      place = Twitter::Place.new('place_type' => 'city')
      place.place_type.should == 'city'
    end
    it "should return a place type when set with placeType[name]" do
      place = Twitter::Place.new('placeType' => {'name' => 'Town'})
      place.place_type.should == 'Town'
    end
    it "should return nil when not set" do
      place = Twitter::Place.new
      place.place_type.should be_nil
    end
  end

end
