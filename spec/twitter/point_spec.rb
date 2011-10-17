require 'helper'

describe Twitter::Point do

  before do
    @point = Twitter::Point.new('coordinates' => [-122.399983, 37.788299])
  end

  describe "#==" do
    it "should return true when coordinates are equal" do
      other = Twitter::Point.new('coordinates' => [-122.399983, 37.788299])
      (@point == other).should be_true
    end
    it "should return false when coordinates are not equal" do
      other = Twitter::Point.new('coordinates' => [37.788299, -122.399983])
      (@point == other).should be_false
    end
  end

  describe "#latitude" do
    it "should return the latitude" do
      @point.latitude.should == -122.399983
    end
  end

  describe "#longitude" do
    it "should return the longitude" do
      @point.longitude.should == 37.788299
    end
  end

end
