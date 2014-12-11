require 'helper'

describe Twitter::Geo::Point do
  before do
    @point = Twitter::Geo::Point.new(coordinates: [-122.399983, 37.788299])
  end

  describe '#==' do
    it 'returns true for empty objects' do
      point = Twitter::Geo::Point.new
      other = Twitter::Geo::Point.new
      expect(point == other).to be true
    end
    it 'returns true when objects coordinates are the same' do
      other = Twitter::Geo::Point.new(coordinates: [-122.399983, 37.788299])
      expect(@point == other).to be true
    end
    it 'returns false when objects coordinates are different' do
      other = Twitter::Geo::Point.new(coordinates: [37.788299, -122.399983])
      expect(@point == other).to be false
    end
    it 'returns false when classes are different' do
      other = Twitter::Geo.new(coordinates: [-122.399983, 37.788299])
      expect(@point == other).to be false
    end
  end

  describe '#latitude' do
    it 'returns the latitude' do
      expect(@point.latitude).to eq(-122.399983)
    end
  end

  describe '#longitude' do
    it 'returns the longitude' do
      expect(@point.longitude).to eq(37.788299)
    end
  end
end
