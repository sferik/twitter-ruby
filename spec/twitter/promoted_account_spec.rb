require 'helper'

describe Twitter::PromotedAccount do
  context '#==' do
    it 'returns true when objects IDs are the same' do
      promoted_account = Twitter::PromotedAccount.new(id: 'ab312')
      other = Twitter::PromotedAccount.new(id: 'ab312')
      expect(promoted_account == other).to be true
    end
    it 'returns false when IDs are different' do
      promoted_account = Twitter::PromotedAccount.new(id: 'ab312')
      other = Twitter::PromotedAccount.new(id: 'bxfdf')
      expect(promoted_account == other).to be false
    end
    it 'returns false when classes are different' do
      promoted_account = Twitter::PromotedAccount.new(id: 'ab312')
      other = Twitter::Identity.new(id: 'ab312')
      expect(promoted_account == other).to be false
    end
  end

  describe '#created_at' do
    it 'returns a Time when created at is set' do
      promoted_account = Twitter::PromotedAccount.new(id: 'abc123', created_at: 'Mon July 16 12:59:01 +0000 2007')
      expect(promoted_account.created_at).to be_a Time
      expect(promoted_account.created_at).to be_utc
    end
    it 'returns nil when it is not set' do
      promoted_account = Twitter::PromotedAccount.new(id: 'abc123')
      expect(promoted_account.created_at).to be_nil
    end
  end
end
