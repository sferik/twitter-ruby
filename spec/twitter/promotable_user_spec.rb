require 'helper'

describe Twitter::PromotableUser do
  context '#==' do
    it 'returns true when objects IDs are the same' do
      promotable_user = Twitter::PromotableUser.new(id: 'ab312')
      other = Twitter::PromotableUser.new(id: 'ab312')
      expect(promotable_user == other).to be true
    end
    it 'returns false when IDs are different' do
      promotable_user = Twitter::PromotableUser.new(id: 'ab312')
      other = Twitter::PromotableUser.new(id: 'bxfdf')
      expect(promotable_user == other).to be false
    end
    it 'returns false when classes are different' do
      promotable_user = Twitter::PromotableUser.new(id: 'ab312')
      other = Twitter::Identity.new(id: 'ab312')
      expect(promotable_user == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created at is set' do
      promotable_user = Twitter::PromotableUser.new(id: 'abc123', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(promotable_user.created_at).to be_a Time
      expect(promotable_user.created_at).to be_utc
    end
    it 'returns nil when it is not set' do
      promotable_user = Twitter::PromotableUser.new(id: 'abc123')
      expect(promotable_user.created_at).to be_nil
    end
  end
end
