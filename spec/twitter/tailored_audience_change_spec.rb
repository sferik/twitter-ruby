require 'helper'

describe Twitter::TailoredAudienceChange do
  context '#==' do
    it 'returns true when objects IDs are the same' do
      change = Twitter::TailoredAudienceChange.new(id: 'ab312')
      other = Twitter::TailoredAudienceChange.new(id: 'ab312')
      expect(change == other).to be true
    end
    it 'returns false when IDs are different' do
      change = Twitter::TailoredAudienceChange.new(id: 'ab312')
      other = Twitter::TailoredAudienceChange.new(id: 'bxfdf')
      expect(change == other).to be false
    end
    it 'returns false when classes are different' do
      change = Twitter::TailoredAudienceChange.new(id: 'ab312')
      other = Twitter::Identity.new(id: 'ab312')
      expect(change == other).to be false
    end
  end

  context '#completed?' do
    it 'returns true if state is COMPLETED' do
      change = Twitter::TailoredAudienceChange.new(id: 'abc', state: 'COMPLETED')
      expect(change).to be_completed
    end
  end
end
