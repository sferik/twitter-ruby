require 'helper'

describe Twitter::Settings do
  describe '#trend_location' do
    it 'returns a Twitter::Place when trend_location is set' do
      settings = Twitter::Settings.new(trend_location: {countryCode: 'US', name: 'San Francisco', country: 'United States', placeType: {name: 'Town', code: 7}, woeid: 2_487_956, parentid: 23_424_977, url: 'http://where.yahooapis.com/v1/place/2487956'})
      expect(settings.trend_location).to be_a Twitter::Place
    end
    it 'returns nil when trend_location is not set' do
      settings = Twitter::Settings.new
      expect(settings.trend_location).to be_nil
    end
  end

  describe '#trend_location?' do
    it 'returns true when trend_location is set' do
      settings = Twitter::Settings.new(trend_location: {countryCode: 'US', name: 'San Francisco', country: 'United States', placeType: {name: 'Town', code: 7}, woeid: 2_487_956, parentid: 23_424_977, url: 'http://where.yahooapis.com/v1/place/2487956'})
      expect(settings.trend_location?).to be true
    end
    it 'returns false when trend_location is not set' do
      settings = Twitter::Settings.new
      expect(settings.trend_location?).to be false
    end
  end
end
