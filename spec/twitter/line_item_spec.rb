require 'helper'

describe Twitter::LineItem do
  context '#==' do
    it 'returns true when objects IDs are the same' do
      campaign = Twitter::LineItem.new(id: 'ab312', name: 'foo')
      other = Twitter::LineItem.new(id: 'ab312', name: 'bar')
      expect(campaign == other).to be true
    end
    it 'returns false when IDs are different' do
      campaign = Twitter::LineItem.new(id: 'ab312', name: 'foo')
      other = Twitter::LineItem.new(id: 'bxfdf', name: 'foo')
      expect(campaign == other).to be false
    end
    it 'returns false when classes are different' do
      campaign = Twitter::LineItem.new(id: 'ab312', name: 'foo')
      other = Twitter::Identity.new(id: 'ab312')
      expect(campaign == other).to be false
    end
  end

  context '#created_at' do
    it 'returns a Time when created at is set' do
      campaign = Twitter::LineItem.new(id: 'abc123', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(campaign.created_at).to be_a Time
      expect(campaign.created_at).to be_utc
    end
    it 'returns nil when it is not set' do
      campaign = Twitter::LineItem.new(id: 'abc123')
      expect(campaign.created_at).to be_nil
    end
  end
end
