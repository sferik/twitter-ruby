require 'helper'

describe Twitter::Geo::Polygon do
  before do
    @polygon = Twitter::Geo::Polygon.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
  end

  describe '#==' do
    it 'returns true for empty objects' do
      polygon = Twitter::Geo::Polygon.new
      other = Twitter::Geo::Polygon.new
      expect(polygon == other).to be true
    end
    it 'returns true when objects coordinates are the same' do
      other = Twitter::Geo::Polygon.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      expect(@polygon == other).to be true
    end
    it 'returns false when objects coordinates are different' do
      other = Twitter::Geo::Polygon.new(coordinates: [[[37.77752898, -122.40348192], [37.77752898, -122.387436], [37.79448597, -122.387436], [37.79448597, -122.40348192]]])
      expect(@polygon == other).to be false
    end
    it 'returns false when classes are different' do
      other = Twitter::Geo.new(coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]])
      expect(@polygon == other).to be false
    end
  end
end
