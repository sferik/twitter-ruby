require 'helper'

describe Twitter::Place do
  describe '.new' do
    it 'raises an IndexError when id or woeid is not specified' do
      expect { Twitter::Place.new(id: 1) }.not_to raise_error
      expect { Twitter::Place.new(woeid: 1) }.not_to raise_error
      expect { Twitter::Place.new }.to raise_error(IndexError)
    end
  end

  describe '#eql?' do
    it 'returns true when objects WOE IDs are the same' do
      place = Twitter::Place.new(woeid: 1, name: 'foo')
      other = Twitter::Place.new(woeid: 1, name: 'bar')
      expect(place).to eql(other)
    end
    it 'returns false when objects WOE IDs are different' do
      place = Twitter::Place.new(woeid: 1)
      other = Twitter::Place.new(woeid: 2)
      expect(place).not_to eql(other)
    end
    it 'returns false when classes are different' do
      place = Twitter::Place.new(woeid: 1)
      other = Twitter::Base.new(woeid: 1)
      expect(place).not_to eql(other)
    end
  end

  describe '#bounding_box' do
    it 'returns a Twitter::Geo when bounding_box is set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', bounding_box: {type: 'Polygon', coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})
      expect(place.bounding_box).to be_a Twitter::Geo::Polygon
    end
    it 'returns nil when not bounding_box is not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.bounding_box).to be_nil
    end
  end

  describe '#==' do
    it 'returns true when objects WOE IDs are the same' do
      place = Twitter::Place.new(woeid: 1, name: 'foo')
      other = Twitter::Place.new(woeid: 1, name: 'bar')
      expect(place == other).to be true
    end
    it 'returns false when objects WOE IDs are different' do
      place = Twitter::Place.new(woeid: 1)
      other = Twitter::Place.new(woeid: 2)
      expect(place == other).to be false
    end
    it 'returns false when classes are different' do
      place = Twitter::Place.new(woeid: 1)
      other = Twitter::Base.new(woeid: 1)
      expect(place == other).to be false
    end
  end

  describe '#bounding_box' do
    it 'returns a Twitter::Geo when bounding_box is set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', bounding_box: {type: 'Polygon', coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})
      expect(place.bounding_box).to be_a Twitter::Geo::Polygon
    end
    it 'returns nil when not bounding_box is not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.bounding_box).to be_nil
    end
  end

  describe '#bounding_box?' do
    it 'returns true when bounding_box is set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', bounding_box: {type: 'Polygon', coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})
      expect(place.bounding_box?).to be true
    end
    it 'returns false when bounding_box is not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.bounding_box?).to be false
    end
  end

  describe '#contained_within' do
    it 'returns a Twitter::Place when contained_within is set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', contained_within: {woeid: '247f43d441defc04'})
      expect(place.contained_within).to be_a Twitter::Place
    end
    it 'returns nil when not contained_within is not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.contained_within).to be_nil
    end
  end

  describe '#contained_within?' do
    it 'returns true when contained_within is set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', contained_within: {woeid: '247f43d441defc04'})
      expect(place.contained?).to be true
    end
    it 'returns false when contained_within is not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.contained?).to be false
    end
  end

  describe '#country_code' do
    it 'returns a country code when set with country_code' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', country_code: 'US')
      expect(place.country_code).to eq('US')
    end
    it 'returns a country code when set with countryCode' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', countryCode: 'US')
      expect(place.country_code).to eq('US')
    end
    it 'returns nil when not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.country_code).to be_nil
    end
  end

  describe '#parent_id' do
    it 'returns a parent ID when set with parentid' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', parentid: 1)
      expect(place.parent_id).to eq(1)
    end
    it 'returns nil when not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.parent_id).to be_nil
    end
  end

  describe '#place_type' do
    it 'returns a place type when set with place_type' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', place_type: 'city')
      expect(place.place_type).to eq('city')
    end
    it 'returns a place type when set with placeType[name]' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', placeType: {name: 'Town'})
      expect(place.place_type).to eq('Town')
    end
    it 'returns nil when not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.place_type).to be_nil
    end
  end

  describe '#uri' do
    it 'returns a URI when the url is set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', url: 'https://api.twitter.com/1.1/geo/id/247f43d441defc03.json')
      expect(place.uri).to be_an Addressable::URI
      expect(place.uri.to_s).to eq('https://api.twitter.com/1.1/geo/id/247f43d441defc03.json')
    end
    it 'returns nil when the url is not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.uri).to be_nil
    end
  end

  describe '#uri?' do
    it 'returns true when the url is set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03', url: 'https://api.twitter.com/1.1/geo/id/247f43d441defc03.json')
      expect(place.uri?).to be true
    end
    it 'returns false when the url is not set' do
      place = Twitter::Place.new(woeid: '247f43d441defc03')
      expect(place.uri?).to be false
    end
  end
end
