require 'helper'

describe Twitter::TailoredAudience do
  context '#==' do
    it 'returns true when objects IDs are the same' do
      audience = Twitter::TailoredAudience.new(id: 'ab312', name: 'foo')
      other = Twitter::TailoredAudience.new(id: 'ab312', name: 'bar')
      expect(audience == other).to be true
    end
    it 'returns false when IDs are different' do
      audience = Twitter::TailoredAudience.new(id: 'ab312', name: 'foo')
      other = Twitter::TailoredAudience.new(id: 'bxfdf', name: 'foo')
      expect(audience == other).to be false
    end
    it 'returns false when classes are different' do
      audience = Twitter::TailoredAudience.new(id: 'ab312', name: 'foo')
      other = Twitter::Identity.new(id: 'ab312')
      expect(audience == other).to be false
    end
  end

  context '#created_at' do
    it 'returns a Time when created at is set' do
      audience = Twitter::TailoredAudience.new(id: 'abc123', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(audience.created_at).to be_a Time
      expect(audience.created_at).to be_utc
    end
    it 'returns nil when it is not set' do
      audience = Twitter::TailoredAudience.new(id: 'abc123')
      expect(audience.created_at).to be_nil
    end
  end
end
