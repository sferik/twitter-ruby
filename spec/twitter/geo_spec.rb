require 'helper'

describe Twitter::Geo do

  before do
    @geo = Twitter::Geo.new(:coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
  end

  describe "#==" do
    it "returns false for empty objects" do
      geo = Twitter::Geo.new
      other = Twitter::Geo.new
      (geo == other).should be_false
    end
    it "returns true when objects coordinates are the same" do
      other = Twitter::Geo.new(:coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      (@geo == other).should be_true
    end
    it "returns false when objects coordinates are different" do
      other = Twitter::Geo.new(:coordinates => [[[37.77752898, -122.40348192], [37.77752898, -122.387436], [37.79448597, -122.387436], [37.79448597, -122.40348192]]])
      (@geo == other).should be_false
    end
    it "returns false when classes are different" do
      other = Twitter::Polygon.new(:coordinates => [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      (@geo == other).should be_false
    end
  end

end
