require 'helper'
require 'shared_examples_for_enumerables'

describe Twitter::TrendResults do
  it_behaves_like 'an enumerable' do
    let(:enumerable) { Twitter::TrendResults.new(trends: [{id: 1}, {id: 2}, {id: 3}, {id: 4}, {id: 5}, {id: 6}]) }
  end

  describe '#as_of' do
    it 'returns a Time when as_of is set' do
      trend_results = Twitter::TrendResults.new(id: 1, as_of: '2012-08-24T23:25:43Z')
      expect(trend_results.as_of).to be_a Time
      expect(trend_results.as_of).to be_utc
    end
    it 'returns nil when as_of is not set' do
      trend_results = Twitter::TrendResults.new(id: 1)
      expect(trend_results.as_of).to be_nil
    end
  end

  describe '#as_of?' do
    it 'returns true when as_of is set' do
      trend_results = Twitter::TrendResults.new(id: 1, as_of: '2012-08-24T23:24:14Z')
      expect(trend_results.as_of?).to be true
    end
    it 'returns false when as_of is not set' do
      trend_results = Twitter::TrendResults.new(id: 1)
      expect(trend_results.as_of?).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created_at is set' do
      trend_results = Twitter::TrendResults.new(id: 1, created_at: '2012-08-24T23:24:14Z')
      expect(trend_results.created_at).to be_a Time
      expect(trend_results.created_at).to be_utc
    end
    it 'returns nil when created_at is not set' do
      trend_results = Twitter::TrendResults.new(id: 1)
      expect(trend_results.created_at).to be_nil
    end
  end

  describe '#created?' do
    it 'returns true when created_at is set' do
      trend_results = Twitter::TrendResults.new(id: 1, created_at: '2012-08-24T23:24:14Z')
      expect(trend_results.created?).to be true
    end
    it 'returns false when created_at is not set' do
      trend_results = Twitter::TrendResults.new(id: 1)
      expect(trend_results.created?).to be false
    end
  end

  describe '#location' do
    it 'returns a Twitter::Place when location is set' do
      trend_results = Twitter::TrendResults.new(id: 1, locations: [{name: 'Worldwide', woeid: 1}])
      expect(trend_results.location).to be_a Twitter::Place
    end
    it 'returns nil when location is not set' do
      trend_results = Twitter::TrendResults.new(id: 1)
      expect(trend_results.location).to be_nil
    end
  end

  describe '#location?' do
    it 'returns true when location is set' do
      trend_results = Twitter::TrendResults.new(id: 1, locations: [{name: 'Worldwide', woeid: 1}])
      expect(trend_results.location?).to be true
    end
    it 'returns false when location is not set' do
      trend_results = Twitter::TrendResults.new(id: 1)
      expect(trend_results.location?).to be false
    end
  end
end
