require 'helper'

describe Twitter::Campaign do
  context '#==' do
    it 'returns true when objects IDs are the same' do
      campaign = Twitter::Campaign.new(id: 'ab312', name: 'foo')
      other = Twitter::Campaign.new(id: 'ab312', name: 'bar')
      expect(campaign == other).to be true
    end
    it 'returns false when IDs are different' do
      campaign = Twitter::Campaign.new(id: 'ab312', name: 'foo')
      other = Twitter::Campaign.new(id: 'bxfdf', name: 'foo')
      expect(campaign == other).to be false
    end
    it 'returns false when classes are different' do
      campaign = Twitter::Campaign.new(id: 'ab312', name: 'foo')
      other = Twitter::Identity.new(id: 'ab312')
      expect(campaign == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created at is set' do
      campaign = Twitter::Campaign.new(id: 'abc123', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(campaign.created_at).to be_a Time
      expect(campaign.created_at).to be_utc
    end
    it 'returns nil when it is not set' do
      campaign = Twitter::Campaign.new(id: 'abc123')
      expect(campaign.created_at).to be_nil
    end
  end

  describe '#start_time' do
    it 'returns a Time when start time is set' do
      campaign = Twitter::Campaign.new(id: 'abc123', start_time: 'Mon July 16 12:59:01 +0000 2007')
      expect(campaign.start_time).to be_a Time
      expect(campaign.start_time).to be_utc
    end
    it 'returns nil when it is not set' do
      campaign = Twitter::Campaign.new(id: 'abc123')
      expect(campaign.start_time).to be_nil
    end
  end

  describe '#end_time' do
    it 'returns a Time when end time is set' do
      campaign = Twitter::Campaign.new(id: 'abc123', end_time: 'Mon July 16 12:59:01 +0000 2007')
      expect(campaign.end_time).to be_a Time
      expect(campaign.end_time).to be_utc
    end
    it 'returns nil when it is not set' do
      campaign = Twitter::Campaign.new(id: 'abc123')
      expect(campaign.end_time).to be_nil
    end
  end

  describe '#total_budget_amount_local_micro' do
    it 'returns an Integer if set' do
      campaign = Twitter::Campaign.new(id: 'abc123', total_budget_amount_local_micro: 75_000_000)
      expect(campaign.total_budget_amount_local_micro).to eq(75_000_000)
    end
    it 'returns nil when it is not set' do
      campaign = Twitter::Campaign.new(id: 'abc123')
      expect(campaign.total_budget_amount_local_micro).to be_nil
    end
  end
end
