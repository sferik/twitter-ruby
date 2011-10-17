describe Twitter::Polygon do

  before do
    @polygon = Twitter::Polygon.new('coordinates' => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
  end

  describe "#==" do
    it "should return true when coordinates are equal" do
      other = Twitter::Polygon.new('coordinates' => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      (@polygon == other).should be_true
    end
    it "should return false when coordinates are not equal" do
      other = Twitter::Polygon.new('coordinates' => [[[37.77752898, -122.40348192], [37.77752898, -122.387436], [37.79448597, -122.387436], [37.79448597, -122.40348192]]])
      (@polygon == other).should be_false
    end
  end

end
