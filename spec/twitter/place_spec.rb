require 'helper'

describe Twitter::Place do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      place = Twitter::Place.new(:id => 1, :name => "foo")
      other = Twitter::Place.new(:id => 1, :name => "bar")
      expect(place == other).to be_true
    end
    it "returns false when objects IDs are different" do
      place = Twitter::Place.new(:id => 1)
      other = Twitter::Place.new(:id => 2)
      expect(place == other).to be_false
    end
    it "returns false when classes are different" do
      place = Twitter::Place.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      expect(place == other).to be_false
    end
  end

  describe "#bounding_box" do
    it "returns a Twitter::Place when set" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :bounding_box => {:type => 'Polygon', :coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})
      expect(place.bounding_box).to be_a Twitter::Geo::Polygon
    end
    it "returns nil when not set" do
      place = Twitter::Place.new(:id => "247f43d441defc03")
      expect(place.bounding_box).to be_nil
    end
  end

  describe "#country_code" do
    it "returns a country code when set with country_code" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :country_code => 'US')
      expect(place.country_code).to eq 'US'
    end
    it "returns a country code when set with countryCode" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :countryCode => 'US')
      expect(place.country_code).to eq 'US'
    end
    it "returns nil when not set" do
      place = Twitter::Place.new(:id => "247f43d441defc03")
      expect(place.country_code).to be_nil
    end
  end

  describe "#parent_id" do
    it "returns a parent ID when set with parentid" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :parentid => 1)
      expect(place.parent_id).to eq 1
    end
    it "returns nil when not set" do
      place = Twitter::Place.new(:id => "247f43d441defc03")
      expect(place.parent_id).to be_nil
    end
  end

  describe "#place_type" do
    it "returns a place type when set with place_type" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :place_type => 'city')
      expect(place.place_type).to eq 'city'
    end
    it "returns a place type when set with placeType[name]" do
      place = Twitter::Place.new(:id => "247f43d441defc03", :placeType => {:name => 'Town'})
      expect(place.place_type).to eq 'Town'
    end
    it "returns nil when not set" do
      place = Twitter::Place.new(:id => "247f43d441defc03")
      expect(place.place_type).to be_nil
    end
  end

end
