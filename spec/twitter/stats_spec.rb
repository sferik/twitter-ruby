require 'helper'

describe Twitter::Stats do
  it 'can be instantiated' do
    stats = Twitter::Stats.new(id: 'abcdefg', promoted_tweet_timeline_url_clicks: [123, 355])

    expect(stats.id).to eq('abcdefg')
    expect(stats.promoted_tweet_timeline_url_clicks).to eq([123, 355])
  end

  describe '#start_time' do
    it 'returns a Time when start time is set' do
      stats = Twitter::Stats.new(id: 'abc123', start_time: 'Mon July 16 12:59:01 +0000 2007')
      expect(stats.start_time).to be_a Time
      expect(stats.start_time).to be_utc
    end
    it 'returns nil when it is not set' do
      stats = Twitter::Stats.new(id: 'abc123')
      expect(stats.start_time).to be_nil
    end
  end

  describe '#end_time' do
    it 'returns a Time when end time is set' do
      stats = Twitter::Stats.new(id: 'abc123', end_time: 'Mon July 16 12:59:01 +0000 2007')
      expect(stats.end_time).to be_a Time
      expect(stats.end_time).to be_utc
    end
    it 'returns nil when it is not set' do
      stats = Twitter::Stats.new(id: 'abc123')
      expect(stats.end_time).to be_nil
    end
  end
end
