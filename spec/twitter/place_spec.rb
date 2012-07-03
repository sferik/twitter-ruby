require 'helper'

describe Twitter::Place do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      place = Twitter::Place.new(:id => 1, :name => "foo")
      other = Twitter::Place.new(:id => 1, :name => "bar")
      (place == other).should be_true
    end
    it "returns false when objects IDs are different" do
      place = Twitter::Place.new(:id => 1)
      other = Twitter::Place.new(:id => 2)
      (place == other).should be_false
    end
    it "returns false when classes are different" do
      place = Twitter::Place.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      (place == other).should be_false
    end
  end

  describe "#bounding_box" do
    it "returns a Twitter::Place when set" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :bounding_box => {:type => 'Polygon', :coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})
      place.bounding_box.should be_a Twitter::Polygon
    end
    it "returns nil when not set" do
      place = Twitter::Place.new(:id => "247f43d441defc03")
      place.bounding_box.should be_nil
    end
  end

  describe "#country_code" do
    it "returns a country code when set with country_code" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :country_code => 'US')
      place.country_code.should eq 'US'
    end
    it "returns a country code when set with countryCode" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :countryCode => 'US')
      place.country_code.should eq 'US'
    end
    it "returns nil when not set" do
      place = Twitter::Place.new(:id => "247f43d441defc03")
      place.country_code.should be_nil
    end
  end

  describe "#parent_id" do
    it "returns a parent ID when set with parentid" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :parentid => 1)
      place.parent_id.should eq 1
    end
    it "returns nil when not set" do
      place = Twitter::Place.new(:id => "247f43d441defc03")
      place.parent_id.should be_nil
    end
  end

  describe "#place_type" do
    it "returns a place type when set with place_type" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :place_type => 'city')
      place.place_type.should eq 'city'
    end
    it "returns a place type when set with placeType[name]" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :placeType => {:name => 'Town'})
      place.place_type.should eq 'Town'
    end
    it "returns nil when not set" do
      place = Twitter::Place.new(:id => "247f43d441defc03")
      place.place_type.should be_nil
    end
  end

end
