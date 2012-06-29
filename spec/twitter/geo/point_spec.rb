require 'helper'

describe Twitter::Point do

  before do
    @point = Twitter::Point.new(:coordinates => [-122.399983, 37.788299])
  end

  describe "#==" do
    it "returns false for empty objects" do
      point = Twitter::Point.new
      other = Twitter::Point.new
      (point == other).should be_false
    end
    it "returns true when objects coordinates are the same" do
      other = Twitter::Point.new(:coordinates => [-122.399983, 37.788299])
      (@point == other).should be_true
    end
    it "returns false when objects coordinates are different" do
      other = Twitter::Point.new(:coordinates => [37.788299, -122.399983])
      (@point == other).should be_false
    end
    it "returns false when classes are different" do
      other = Twitter::Geo.new(:coordinates => [-122.399983, 37.788299])
      (@point == other).should be_false
    end
  end

  describe "#latitude" do
    it "returns the latitude" do
      @point.latitude.should eq -122.399983
    end
  end

  describe "#longitude" do
    it "returns the longitude" do
      @point.longitude.should eq 37.788299
    end
  end

end
